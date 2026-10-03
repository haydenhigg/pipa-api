export async function getProjects(c) {
	const { results } = await c.env.DB.prepare(`SELECT id, name FROM projects`).all()
	return results
}

export async function getProject(c, projectId) {
	return await c.env.DB.prepare(`SELECT id, name FROM projects WHERE id = ?`)
		.bind(projectId)
		.first()
}

export async function getViews(c, projectId) {
	const { results } = await c.env.DB.prepare(`
		SELECT
			id,
			name,
			is_default
		FROM
			views
		WHERE
			project_id = ?
	`)
		.bind(projectId)
		.all()

	return results
}

function groupTasks(rows) {
	const tasks = []

	for (const row of rows) {
		const task = {
			id: row.id,
			content: row.content,
			ordinal: row.ordinal
		}

		if (!tasks || row.section_id !== tasks[tasks.length - 1]?.sectionId) {
			tasks.push({
				sectionId: row.section_id,
				sectionName: row.section_name,
				sectionOrdinal: row.section_ordinal,
				tasks: [task]
			})
		} else {
			tasks[tasks.length - 1].tasks.push(task)
		}
	}

	return tasks
}

export async function getDefaultTasks(c, projectId) {
	const { results } = await c.env.DB.prepare(`
		SELECT
			NULL section_id,
			NULL section_name,
			NULL section_ordinal,
			t.id,
			t.content,
			t.ordinal
		FROM
			tasks t
		WHERE
			t.project_id = ?1
		ORDER BY
			-- s.ordinal,
			-- st.ordinal,
			t.ordinal
	`)
		.bind(projectId)
		.all()

	return groupTasks(results)
}

export async function getTasksForView(c, projectId, viewId) {
	const { results } = await c.env.DB.prepare(`
		SELECT
			s.id section_id,
			s.name section_name,
			s.ordinal section_ordinal,
			t.id,
			t.content,
			st.ordinal
		FROM
			tasks t
		JOIN
			section_tasks st ON st.task_id = t.id
		JOIN
			sections s ON
				s.id = st.section_id AND
				s.view_id = ?2
		WHERE
			t.project_id = ?1
		ORDER BY
			s.ordinal,
			st.ordinal,
			t.ordinal
	`)
		.bind(projectId, viewId)
		.all()

	return groupTasks(results)
}
