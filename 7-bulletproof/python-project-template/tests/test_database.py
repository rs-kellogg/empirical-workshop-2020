from sqlalchemy import Table, MetaData
from pathlib import Path
import os
from kelloggrs import load_data

dir_path = os.path.dirname(os.path.realpath(__file__))


def test_engine(db_engine):
    assert db_engine is not None
    conn = db_engine.connect()
    assert not conn.closed


def test_create_tables(db_engine, config):
    meta = MetaData(bind=db_engine)

    sql = Path(config["create_transcript_sql"]).read_text()
    result = db_engine.execute(sql)
    transcript = Table('Transcript', meta, autoload=True, autoload_with=db_engine)
    assert str(transcript) == "Transcript"

    sql = Path(config["create_component_sql"]).read_text()
    result = db_engine.execute(sql)
    component = Table('Component', meta, autoload=True, autoload_with=db_engine)
    assert str(component) == "Component"


def test_create_database(config):
    engine = load_data.create_database(config)
    assert engine is not None


def test_insert_records(config, data_path):
    engine = load_data.create_database(config)
    engine = load_data.insert_records(data_path / "Tesla", engine)
    result = engine.execute("select count(*) as cnt from Transcript")
    row = result.fetchone()
    assert row["cnt"] == 34

