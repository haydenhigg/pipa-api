import { Hono } from 'hono'
import { cors } from 'hono/cors'
import * as model from './model'

const app = new Hono()

app.use('*', async (c, next) => {
  const corsMiddleware = cors({
    origin: c.env.CORS_ORIGIN || 'http://localhost:3000',
    credentials: true,
  })
  return corsMiddleware(c, next)
})

app.get('/', (c) => c.json({ time: Date.now() / 1e3 }))

app.get('/projects', async (c) => {
	return c.json(await model.getProjects(c))
})

app.post('/projects', async (c) => {
	let body

	try {
		body = await c.req.json()
	} catch {
		return c.json({ error: 'invalid request body' }, 400)
	}

	const name = body?.name?.trim()
	if (!name) {
		return c.json({ error: 'project name must not be empty' }, 400)
	}

	const { meta } = await c.env.DB.prepare(`
		INSERT INTO projects(name) VALUES (?)
	`)
	.bind(name)
	.run()

	return c.json({ id: meta.last_row_id, name }, 201)
})

app.get('/projects/:projectId', async (c) => {
	const projectId = c.req.param('projectId')

	const project = await model.getProject(c, projectId)

	const views = await model.getViews(c, projectId)
	const defaultView = views.find((view) => view.is_default === 1)

	const sections = defaultView
		? await model.getTasksForView(c, projectId, defaultView.id)
		: await model.getDefaultTasks(c, projectId)

	return c.json({
		id: project.id,
		name: project.name,
		views,
		sections
	})
})

app.get('/projects/:projectId/views', async (c) => {
	return c.json(await model.getViews(c, c.req.param('projectId')))
})

app.get('/projects/:projectId/views/:viewId', async (c) => {
	return c.json(await model.getTasksForView(c, c.req.param('projectId'), c.req.param('viewId')))
})

export default app
