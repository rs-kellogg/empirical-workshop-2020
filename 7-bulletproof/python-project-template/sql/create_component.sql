CREATE TABLE IF NOT EXISTS Component (
    transcriptid bigint,
    componentid bigint PRIMARY KEY,
    componenttypename varchar(100),
    text varchar(100),
    componentorder integer,
    personname varchar(100),
    companyofperson varchar(100)
);