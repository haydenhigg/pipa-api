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

app.get('/projects/:projectId', async (c) => {
	const projectId = c.req.param('projectId')

	const project = await model.getProject(c, projectId)
	const tasks = await model.getTasks(c, projectId)

	return c.json({
		id: project.id,
		name: project.name,
		views: [],
		tasks
	})
})

export default app
