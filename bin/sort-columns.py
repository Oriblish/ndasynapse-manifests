#!/usr/bin/env python3

"""Sort columns alphabetically in a CSV file.

"""

import csv
import os

import pandas as pd

if __name__ == "__main__":
    import argparse

    parser = argparse.ArgumentParser()

    args = parser.parse_args()
 
    df = pd.read_csv("/dev/stdin", index_col=None, header=0, 
                     parse_dates=False, infer_datetime_format=False)
    
    df = df.reindex(sorted(df.columns), axis=1)

    df.to_csv('/dev/stdout', index=False, quoting=csv.QUOTE_NONNUMERIC)
