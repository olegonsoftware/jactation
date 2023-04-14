# coding=utf8
import sys
import os
import re
import numpy as np
import pandas as pd

# Each line of the psrecord is like this
psr_regexp = r"(\d+.\d+)\s+(\d+.\d+)\s+(\d+.\d+)\s+(\d+.\d+)"

# plots.py alpaquita,official
if (len(sys.argv) == 1):
    print("No configurations available")
    sys.exit()

configs = sys.argv[1].split(',')
print("configurations: ", configs)


def main():
    cdf = pd.DataFrame()  # summary dataframe with all configruations

    labels = []  # [alpaquita, official]

    for config in configs:
        print(config)
        df = read_df(config)  # input file -> dataframe
        df = remove_outliers(df, config)  # remove statistically unimportant data
        plot_single(df, config)  # create a histogram for each configuration
        labels.append(config)  # mark the configuration as processed

        # accumulate the data to create a summary plot
        if cdf.empty:
            cdf = df
        else:
            cdf[config] = df[config]

    plot_multiple(cdf, labels)  # create a summary histogram
    plot_multiple_median(cdf, labels)  # create a summary barplot


def read_df(config):
    # input file -> dataframe

    source = open(os.path.join('logs', config + '-log'), 'r')
    Lines = source.readlines()

    ram_list = []

    count = 0
    for srcline in Lines:
        count += 1
        if count == 1:
            continue
        line = srcline.strip()
        res = re.match(psr_regexp, line)
        ram = float(res.group(3))
        ram_list.append(ram)

    df = pd.DataFrame({config: ram_list})
    df.columns = [config]

    return df


def remove_outliers(df, config):
    # remove statistically unimportant data
    # using the Inter Quartile Range method

    Q1 = np.percentile(df[config], 25,
                       method='midpoint')

    Q3 = np.percentile(df[config], 75,
                       method='midpoint')

    IQR = Q3 - Q1

    old_shape = df.shape
    old_size = old_shape[0]

    # Upper and Lower bound
    upper = Q3 + 1.5 * IQR
    lower = Q1 - 1.5 * IQR

    # Removing the outliers
    df.drop(df[df[config] >= upper].index, inplace=True)
    df.drop(df[df[config] <= lower].index, inplace=True)

    new_shape = df.shape
    new_size = new_shape[0]

    size_diff = old_size - new_size

    print("Outliers removed: {diff:d}".format(diff=size_diff))
    return df


def plot_single(df, config):
    # create a histogram for each configuration

    hs = df.plot.hist(column=[config], figsize=(10, 8))
    fig = hs.get_figure()
    if not os.path.exists('plot'):
        os.makedirs('plot')
    fig.savefig(os.path.join("plot", config + ".png"))


def plot_multiple(df, labels):
    # create a summary hystogram

    hs = df.plot.hist(column=labels, figsize=(20, 8))
    fig = hs.get_figure()
    fig.savefig(os.path.join("plot", "frequency.png"))


def plot_multiple_median(df, labels):
    # create a summary barplot

    medians = []
    for label in labels:
        medians.append(df[label].median())

    df2 = pd.DataFrame({'image': labels, 'Median RAM (Mb)': medians})
    pb = df2.plot.bar(x="image", y="Median RAM (Mb)", rot=0)
    fig = pb.get_figure()
    fig.savefig(os.path.join("plot", "median.png"))


main()
