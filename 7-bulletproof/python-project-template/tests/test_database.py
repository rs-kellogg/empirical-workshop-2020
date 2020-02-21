from pathlib import Path
import os
from kelloggrs import load_data

dir_path = os.path.dirname(os.path.realpath(__file__))


def test_engine(db_engine):
    assert db_engine is not None
    conn = db_engine.connect()
    assert not conn.closed


def test_create_tables(db_engine, config):
    sql = Path(config["create_transcript_sql"]).read_text()
    result = db_engine.execute(sql)
    assert result.rowcount == -1

    sql = Path(config["create_component_sql"]).read_text()
    result = db_engine.execute(sql)
    assert result.rowcount == -1


def test_create_database(config):
    load_data.create_database(config)


def test_load_data(data_path):
    load_data.insert_records(data_path, None)
