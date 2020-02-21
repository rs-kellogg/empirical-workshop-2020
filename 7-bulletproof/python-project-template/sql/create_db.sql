-- projects table
CREATE TABLE IF NOT EXISTS Transcripts (
    id integer PRIMARY KEY,
    name text NOT NULL,
    begin_date text,
    end_date text
);