from sqlalchemy import create_engine
import yaml
import pytest
from pathlib import Path
from urllib.parse import quote
import os

dir_path = os.path.dirname(os.path.realpath(__file__))


@pytest.fixture
def config():
    with open(Path(f"{dir_path}/conf/dbuser.yaml")) as conf_file:
        conf = yaml.load(conf_file, Loader=yaml.FullLoader)
        return conf


@pytest.fixture
def conn_str(config):
    db = config["db_connection"]
    conn_str = f"{db['prefix']}{db['user']}:{quote(db['password'])}@{db['db_url']}"
    return "sqlite:///:memory:"
    return conn_str


@pytest.fixture
def db_engine(conn_str):
    print(conn_str)
    engine = create_engine(conn_str)
    return engine
