PRAGMA foreign_keys = ON;

CREATE TABLE IF NOT EXISTS projects (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS tasks (
    id INTEGER PRIMARY KEY,
    project_id INTEGER NOT NULL REFERENCES projects(id),
    name TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS views (
    id INTEGER PRIMARY KEY,
    project_id INTEGER NOT NULL REFERENCES projects(id),
    name TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS sections (
    id INTEGER PRIMARY KEY,
    view_id INTEGER NOT NULL REFERENCES views(id),
    name TEXT NOT NULL,
    ordinal INTEGER NOT NULL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS section_tasks (
    id INTEGER PRIMARY KEY,
    section_id INTEGER REFERENCES sections(id),
    task_id INTEGER NOT NULL REFERENCES tasks(id),
    ordinal INTEGER NOT NULL DEFAULT 0
);

INSERT INTO projects(name) VALUES ('Steppe');

INSERT INTO
    tasks(project_id, name)
VALUES
    (1, 'Schema definition'),
    (1, 'BLE integration'),
    (1, 'Native key storage'),
    (1, 'Unlock'),
    (1, 'Auth'),
    (1, 'Keyholder CRUD'),
    (1, 'Credential CRUD'),
    (1, 'Enrollment/registration'),
    (1, 'Key propagation'),
    (1, 'Logging/auditing'),
    (1, 'Auth'),
    (1, 'Key propagation/storage');

INSERT INTO views(project_id, name) VALUES (1, 'Platform');

INSERT INTO
    sections(view_id, name)
VALUES
    (1, 'Database'),
    (1, 'Mobile app for keyholders'),
    (1, 'Web app for admins'),
    (1, 'Controller hardware');

INSERT INTO
    section_tasks(section_id, task_id, ordinal)
VALUES
    (1, 1, 0),
    (2, 2, 0),
    (2, 3, 1),
    (2, 4, 2),
    (2, 5, 3),
    (3, 6, 0),
    (3, 7, 1),
    (3, 8, 2),
    (3, 9, 3),
    (3, 10, 4),
    (3, 11, 5),
    (4, 12, 0);
