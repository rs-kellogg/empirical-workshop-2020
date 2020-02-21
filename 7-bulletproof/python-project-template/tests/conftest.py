from sqlalchemy import create_engine
import yaml
import pytest
from pathlib import Path
from urllib.parse import quote
import os

dir_path = os.path.dirname(os.path.realpath(__file__))


@pytest.fixture
def config():
    with open(Path(f"{dir_path}/config.yaml")) as conf_file:
        conf = yaml.load(conf_file, Loader=yaml.FullLoader)
        return conf


@pytest.fixture
def conn_str(config):
    try:
        db = config["db_connection"]
        if db['type'] == "sqlite" and db['name'] == ":memory:":
            return "sqlite:///:memory:"
        conn_str = f"{db['type']}{db['user']}:{quote(db['password'])}@{db['url']}"
        return conn_str
    except KeyError:
        return "sqlite:///:memory:"


@pytest.fixture
def db_engine(conn_str):
    print(conn_str)
    engine = create_engine(conn_str)
    return engine


@pytest.fixture
def data_path():
    return Path(dir_path) / "data/ciq_transcript_samples"
