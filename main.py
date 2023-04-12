""" File with basic scripts used in Case Study """

import sqlite3
from typing import Iterable
import json


class SqlLiteExecutor(object):

    def __init__(self, db_file):
        self.db_file = db_file
        self.conn = None

    def __enter__(self) -> sqlite3.Cursor:
        self.conn = sqlite3.connect(self.db_file)
        self.conn.row_factory = sqlite3.Row
        return self.conn.cursor()

    def __exit__(self ,type, value, traceback):
        if self.conn:
            self.conn.close()
        return None


def get_unique_customer_ids():
    unique_customer_list_sql = open("./sql/unique_customer_list.sql", "r").read()
    with SqlLiteExecutor(r"./db/assessment_database.sqlite") as conn:
        conn.execute(unique_customer_list_sql)

        rows: Iterable[sqlite3.Row] = conn.fetchall()
        for row in rows:
            print(dict(row))


def get_orders():
    unique_customer_list_sql = open("./sql/orders.sql", "r").read()
    with SqlLiteExecutor(r"./db/assessment_database.sqlite") as conn:
        conn.execute(unique_customer_list_sql)

        rows: Iterable[sqlite3.Row] = conn.fetchall()
        with open("./output/orders.jsonl", "w+") as f:
            for row in rows:
                f.write(f"{json.dumps(dict(row))}\n")


if __name__ == '__main__':

    get_unique_customer_ids()
    get_orders()
