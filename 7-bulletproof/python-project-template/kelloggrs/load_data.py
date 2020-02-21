#!/usr/bin/env python3

from pathlib import Path
import sqlalchemy
import argparse
import sys
import re


def create_db(path, engine):
    print(path)
    for json_file in path.glob('*.json'):
        print(json_file.name)

    # sample_file = path / "Tesla/transcript_id__1025482.json"
    # text = sample_file.read_text()
    # transcript_dict = json.loads(text)
    # components = transcript_dict["components"]
    # tesla_answers = [c for c in components if c["componenttypename"] == "Answer"]


def main():
    # parse arguments
    parser = argparse.ArgumentParser(prog="load_data")
    parser.add_argument(
        "path", help="the path to the directory holding the json files"
    )
    parser.add_argument(
        "db_params", help="yaml file containing the db parameters"
    )
    parser.add_argument(
        "-v", "--verbose", help="increase output verbosity", action="store_true"
    )

    if len(sys.argv[1:]) == 0:
        parser.print_usage()  # for just the usage line
        print("example: load_data -v text/ config.yml")
        parser.exit()

    args = parser.parse_args()

    try:
        if args.verbose:
            print(f"Loading data from directory: {args.path}")
        create_db(Path(args.path), None)
    except Exception:
        if args.verbose:
            print(f"Bad arguments")
    finally:
        sys.exit(1)


if __name__ == "__main__":
    main()
