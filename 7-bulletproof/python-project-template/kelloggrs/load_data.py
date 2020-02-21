#!/usr/bin/env python3

from sqlalchemy import create_engine, Table, MetaData
from pathlib import Path
from urllib.parse import quote
import argparse
import sys
import json
import yaml


def create_database(config):
    db = config["db_connection"]
    if db['type'] == "sqlite" and db['name'] == ":memory:":
        conn_str = "sqlite:///:memory:"
    else:
        conn_str = f"{db['type']}{db['user']}:{quote(db['password'])}@{db['url']}"
    engine = create_engine(conn_str)
    sql = Path(config["create_transcript_sql"]).read_text()
    engine.execute(sql)
    sql = Path(config["create_component_sql"]).read_text()
    engine.execute(sql)

    return engine


def insert_records(path, engine):
    print(path)
    meta = MetaData(bind=engine)
    transcript_table = Table('Transcript', meta, autoload=True, autoload_with=engine)
    component_table = Table('Component', meta, autoload=True, autoload_with=engine)

    for json_file in path.glob('*.json'):
        text = json_file.read_text()
        transcript_dict = json.loads(text)
        components_dict = transcript_dict["components"]
        transcript_dict = {key:value for key, value in transcript_dict.items() if key != "components"}
        engine.execute(transcript_table.insert(), [transcript_dict])
        for c in components_dict:
            c["transcriptid"] = transcript_dict["transcriptid"]
            engine.execute(component_table.insert(), [c])


    return engine


def main():
    # parse the arguments
    parser = argparse.ArgumentParser(prog="load_data")
    parser.add_argument(
        "path", help="the path to the directory holding the json files"
    )
    parser.add_argument(
        "config", help="yaml file containing the db parameters"
    )
    parser.add_argument(
        "-v", "--verbose", help="increase output verbosity", action="store_true"
    )

    if len(sys.argv[1:]) == 0:
        parser.print_usage()  # for just the usage line
        print("example: load_data -v text/ config.yml")
        parser.exit()

    args = parser.parse_args()

    # create the database
    try:
        if args.verbose:
            print(f"Loading configuration params from file: {args.config}")
        with open(Path(args.config)) as conf_file:
            conf = yaml.load(conf_file, Loader=yaml.FullLoader)
    except FileNotFoundError:
        if args.verbose:
            print(f"Config file not found: {args.config}")
        sys.exit(1)

    # insert the records
    try:
        if args.verbose:
            print(f"Loading data from directory: {args.path}")
        insert_records(Path(args.path), None)
    except Exception:
        if args.verbose:
            print(f"Something bad happened trying to create database")
        sys.exit(1)

    sys.exit(1)


if __name__ == "__main__":
    main()
