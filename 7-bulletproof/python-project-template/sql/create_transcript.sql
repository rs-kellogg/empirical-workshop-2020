CREATE TABLE IF NOT EXISTS Transcript (
    transcriptid bigint PRIMARY KEY,
    keydevid bigint NOT NULL,
    companyid bigint NOT NULL,
    companyname varchar(100) NOT NULL,
    transcriptcreationdate varchar(20) NOT NULL,
    mostimportantdate varchar(20) NULL
);
