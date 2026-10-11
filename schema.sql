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
    tasks(project_id, title)
VALUES
    (1, 'Database'),
    (1, 'Define database schema'),
    (1, 'Mobile app for keyholders'),
    (1, 'BLE integration'),
    (1, 'Native key storage'),
    (1, 'Unlock'),
    (1, 'Auth'),
    (1, 'Web app for administrators'),
    (1, 'Keyholder CRUD'),
    (1, 'Credential CRUD'),
    (1, 'Enrollment/registration'),
    (1, 'Key propagation'),
    (1, 'Logging/auditing'),
    (1, 'Auth'),
    (1, 'Hardware'),
    (1, 'Controller'),
    (1, 'RF sending'),
    (1, 'RF receiving'),
    (1, 'Key propagation/storage'),
    (1, 'Nonce generation'),
    (1, 'Reader'),
    (1, 'RF sending'),
    (1, 'RF receiving');

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
    (23, 21, 1);
