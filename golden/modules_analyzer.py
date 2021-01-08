import os
import csv
from argparse import ArgumentParser


def analyze(results):

    # Gets module name from filename
    _module_name = results.replace("_results.txt", "")
    _module_name = _module_name.replace("./out/", "")

    # Opens results file
    _file = open(results, 'r')
    _reader = csv.reader(_file, delimiter=' ')
    _rows = [row for row in _reader]

    # Discards last line since it is repeated
    _rows = _rows[:-1]

    # Retrieves number of signals and tests
    _n_signals = len(_rows[0])
    _n_tests = len(_rows)

    _sum = [0 for i in range(_n_signals + 1)]

    for row in _rows:

        _val = 0

        for i in range(_n_signals):
            _sum[i] += int(row[i])
            _val += int(row[i])

        if _val == _n_signals:
            _sum[_n_signals] += 1

    _results = [i / _n_tests * 100 for i in _sum]

    # Creates parent directory for output file
    _major_path = "./doc/data/modules/" + _module_name + '/'

    # Creates parent directory if necessary
    if not os.path.isdir(_major_path):
        os.makedirs(_major_path)

    # Opens output file
    _out_file = open(_major_path + _module_name + ".csv", 'w')

    # Creates labels for csv output file
    _labels = ["signal{}".format(i) for i in range(_n_signals)]
    _labels.append("accumulate")

    # Opens output file and writes labels and data
    _csv_writer = csv.writer(_out_file, delimiter=',')
    _csv_writer.writerow(_labels)
    _csv_writer.writerow(_results)

    print("{} has global accuracy of {}%".format(_module_name, _results[-1]))


if __name__ == "__main__":

    _parser = ArgumentParser(description="")

    _required = _parser.add_argument_group("Requireed argument")

    _required.add_argument(
        "-r",
        "--results",
        help="File with module results",
        type=str,
        required=True
    )

    args = _parser.parse_args()

    analyze(args.results)
