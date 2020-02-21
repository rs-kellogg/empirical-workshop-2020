from pathlib import Path
import os
from kelloggrs import load_data

dir_path = os.path.dirname(os.path.realpath(__file__))


def test_engine(db_engine):
    assert db_engine is not None
    conn = db_engine.connect()
    assert not conn.closed


def test_create_table(db_engine):
    sql = Path(f"{dir_path}/../sql/create_db.sql").read_text()
    result = db_engine.execute(sql)


def test_load_data(data_path):
    load_data.create_db(data_path / "foo", None)
