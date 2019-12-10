#!/usr/bin/env python3

import csv
import os

import pandas as pd

if __name__ == "__main__":
    import argparse

    parser = argparse.ArgumentParser()
    parser.add_argument("--column", type=str)
    parser.add_argument("file", type=str)

    args = parser.parse_args()
    filename = os.path.abspath(args.file)
 
    df = pd.read_csv(filename, index_col=None, header=0, 
                     parse_dates=False, infer_datetime_format=False)
    df = df[[args.column]]

    df.to_csv('/dev/stdout', index=False, quoting=csv.QUOTE_NONNUMERIC)
