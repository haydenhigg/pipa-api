export async function getProjects(c) {
	const { results } = await c.env.DB.prepare(`SELECT id, name, created_at FROM projects`).all()
	return results
}

export async function getProject(c, projectId) {
	return await c.env.DB.prepare(`SELECT id, name FROM projects WHERE id = ?`)
		.bind(projectId)
		.first()
}

function groupTasks(rows) {
	const tasks = []
	const indicesById = {}

	for (const row of rows) {
		const task = { ...row, tasks: [] };

		if (!task.parent_task_id) {
			tasks.push(task)
			indicesById[task.id] = [tasks.length - 1]
		} else if (!indicesById.hasOwnProperty(task.parent_task_id)) {
			continue
		} else {
			const parentIndices = indicesById[row.parent_task_id]

			let parent = tasks
			for (const index of parentIndices) parent = parent[index]

			parent.tasks.push(task)
			indicesById[task.id] = parentIndices.concat(['tasks', parent.tasks.length - 1])
		}
	}

	return tasks
}

export async function getTasks(c, projectId) {
	const { results } = await c.env.DB.prepare(`
		SELECT
			t.id,
			t.title,
			t.body,
			t.status,
			t.created_at,
			tl.parent_task_id,
			tl.ordinal
		FROM
			tasks t
		JOIN
			task_locations tl ON tl.task_id = t.id
		WHERE
			t.project_id = ?
		ORDER BY
			tl.parent_task_id,
			tl.ordinal
	`)
		.bind(projectId)
		.all()

	return groupTasks(results)
}

export async function updateTask(c, projectId, taskId, newValues) {
	if (!newValues || typeof newValues !== 'object') {
		return false
	}

	const allowedFields = ['title', 'body', 'status']
	const allowedStatuses = ['unstarted', 'started', 'done']
	const updates = []
	const values = []

	for (const field of allowedFields) {
		if (!Object.hasOwn(newValues, field)) continue

		const value = newValues[field].toString()
		if (field === 'status' && !allowedStatuses.includes(value)) continue

		updates.push(`${field} = ?`)
		values.push(value)
	}

	if (updates.length === 0) return

	return await c.env.DB.prepare(`
		UPDATE
			tasks
		SET
			${updates.join(',')}
		WHERE
			id = ? AND
			project_id = ?
	`)
		.bind(...values, taskId, projectId)
		.run()
}
