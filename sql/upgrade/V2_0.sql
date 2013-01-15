ALTER TABLE project ADD COLUMN vcs_rev_url TEXT DEFAULT '';
CREATE TABLE test_file_tag  (
    id              INTEGER PRIMARY KEY AUTOINCREMENT,
    test_file    INTEGER NOT NULL,
    tag             TEXT DEFAULT '',
    CONSTRAINT 'fk_test_file_tag_test_file' FOREIGN KEY ('test_file') REFERENCES 'test_file' ('id') ON DELETE CASCADE
);
