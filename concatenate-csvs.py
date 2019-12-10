#!/usr/bin/env python3

import csv
import os

import pandas as pd

if __name__ == "__main__":
    import argparse

    parser = argparse.ArgumentParser()
    parser.add_argument("files", type=str, nargs="+")

    args = parser.parse_args()
    all_csv = [os.path.abspath(file_name) for file_name in args.files]
 
    li = []

    for filename in all_csv:
        try:
            df = pd.read_csv(filename, index_col=None, header=0, 
                            parse_dates=False, infer_datetime_format=False)
            li.append(df)
        except pd.errors.EmptyDataError:
            pass

    frame = pd.concat(li, axis=0, ignore_index=True)
    frame.to_csv('/dev/stdout', index=False, quoting=csv.QUOTE_NONNUMERIC)
