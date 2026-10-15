DROP TABLE IF EXISTS task_locations;
DROP TABLE IF EXISTS tasks;
-- DROP TABLE IF EXISTS views;
DROP TABLE IF EXISTS projects;

CREATE TABLE IF NOT EXISTS projects (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- CREATE TABLE IF NOT EXISTS views (
--     id INTEGER PRIMARY KEY,
--     project_id INTEGER NOT NULL REFERENCES projects(id),
--     name TEXT NOT NULL
-- );

CREATE TABLE IF NOT EXISTS tasks (
    id INTEGER PRIMARY KEY,
    project_id INTEGER NOT NULL REFERENCES projects(id),
    title TEXT NOT NULL DEFAULT '',
    body TEXT NOT NULL DEFAULT '',
    status TEXT NOT NULL CHECK (status IN ('unstarted', 'started', 'done')),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS task_locations (
    id INTEGER PRIMARY KEY,
    -- view_id INTEGER REFERENCES views(id),
    task_id INTEGER NOT NULL REFERENCES tasks(id),
    parent_task_id INTEGER REFERENCES tasks(id),
    ordinal INTEGER NOT NULL DEFAULT 0
    -- UNIQUE(view_id, task_id)
);

INSERT INTO projects(name) VALUES ('Steppe');

INSERT INTO
    tasks(project_id, title, status)
VALUES
    (1, 'Database', 'unstarted'),
    (1, 'Define database schema', 'unstarted'),
    (1, 'Mobile app for keyholders', 'unstarted'),
    (1, 'BLE integration', 'unstarted'),
    (1, 'Native key storage', 'unstarted'),
    (1, 'Unlock', 'unstarted'),
    (1, 'Auth', 'unstarted'),
    (1, 'Web app for administrators', 'unstarted'),
    (1, 'Keyholder CRUD', 'unstarted'),
    (1, 'Credential CRUD', 'unstarted'),
    (1, 'Enrollment/registration', 'unstarted'),
    (1, 'Key propagation', 'unstarted'),
    (1, 'Logging/auditing', 'unstarted'),
    (1, 'Auth', 'unstarted'),
    (1, 'Hardware', 'unstarted'),
    (1, 'Controller', 'unstarted'),
    (1, 'RF sending', 'unstarted'),
    (1, 'RF receiving', 'unstarted'),
    (1, 'Key propagation/storage', 'unstarted'),
    (1, 'Nonce generation', 'unstarted'),
    (1, 'Reader', 'started'),
    (1, 'BLE advertising', 'started'),
    (1, 'RF sending', 'unstarted'),
    (1, 'RF receiving', 'unstarted');

INSERT INTO
    task_locations(task_id, parent_task_id, ordinal)
VALUES
    (1, NULL, 0),
    (2, 1, 0),
    (3, NULL, 1),
    (4, 3, 0),
    (5, 3, 1),
    (6, 3, 2),
    (7, 3, 3),
    (8, NULL, 2),
    (9, 8, 0),
    (10, 8, 1),
    (11, 8, 2),
    (12, 8, 3),
    (13, 8, 4),
    (14, 8, 5),
    (15, NULL, 3),
    (16, 15, 0),
    (17, 16, 0),
    (18, 16, 1),
    (19, 16, 2),
    (20, 16, 3),
    (21, 15, 1),
    (22, 21, 0),
    (23, 21, 1),
    (24, 21, 2);
