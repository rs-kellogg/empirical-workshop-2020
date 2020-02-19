from sqlalchemy import create_engine


def test_engine(conn_str):
    print(f"\nconnection string: {conn_str}")
    engine = create_engine(conn_str)
    print(f"\n{engine}")
