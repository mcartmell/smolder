CREATE TABLE project (
    id                  INTEGER PRIMARY KEY AUTOINCREMENT, 
    name                TEXT NOT NULL,
    start_date          TEXT DEFAULT '',
    public              INTEGER DEFAULT 1,
    enable_feed         INTEGER DEFAULT 1,
    default_platform    TEXT DEFAULT '',
    default_arch        TEXT DEFAULT '',
    graph_start         TEXT DEFAULT 'project',
    allow_anon          INTEGER DEFAULT 0,
    max_reports         INTEGER DEFAULT 100,
    extra_css           TEXT DEFAULT '',
		vcs_rev_url					TEXT DEFAULT ''
);

CREATE UNIQUE INDEX i_project_name_project on project (name);

