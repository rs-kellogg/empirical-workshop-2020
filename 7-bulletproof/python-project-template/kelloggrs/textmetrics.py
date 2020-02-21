#!/usr/bin/env python3

from pathlib import Path
import argparse
import sys
import re
import textacy



def main():
    # parse arguments
    parser = argparse.ArgumentParser(prog="textmetrics")
    parser.add_argument(
        "in_dir", help="the directory holding the text files"
    )
    parser.add_argument("out_file", help="the output file")
    parser.add_argument("input_encoding", help="the encoding of the input files")
    parser.add_argument("output_encoding", help="the encoding of the output file")
    parser.add_argument("separator", help="the field separation character")
    parser.add_argument("file_suffix", help="the file extension for input files")
    parser.add_argument(
        "-u",
        "--underscore",
        help="replace space characters in header names with underscore",
        action="store_true",
    )
    parser.add_argument(
        "-v", "--verbose", help="increase output verbosity", action="store_true"
    )

    if len(sys.argv[1:]) == 0:
        parser.print_usage()  # for just the usage line
        print("example: textmetrics -v text/ out.txt iso-8859-1 utf-8 '|' txt")
        parser.exit()

    args = parser.parse_args()

    # process text files
    txt_files = list((Path(args.in_dir)).glob(f"**/*.{args.file_suffix}"))
    header = None

    # with (Path(args.out_file)).open(mode="a") as out:
    #     for txt_file in txt_files:
    #         with txt_file.open(mode="r", encoding=args.input_encoding) as f:
    #             new_header = f.readline()
    #             new_header = new_header.strip()
    #             new_header = re.sub(r"NAEM", "NAME", new_header)
    #             if args.underscore:
    #                 new_header = re.sub(r"[\s/]+", "_", new_header)
    #             new_header = new_header + '\n'
    #
    #             if header is None:
    #                 header = new_header
    #                 out.write(
    #                     header.encode(args.output_encoding).decode(args.output_encoding)
    #                 )
    #             if args.verbose:
    #                 print(
    #                     f"processing file: {f.name} ({len(header.split(args.separator))} fields)"
    #                 )
    #             assert new_header == header
    #             for line in f:
    #                 # fields = line.split(args.separator)
    #                 # line = args.separator.join(fields)
    #                 # if line[len(line)-1] != '\n':
    #                 #     line += '\n'
    #                 line = line.replace('true', '1')
    #                 line = line.replace('false', '0')
    #                 out.write(
    #                     line.encode(args.output_encoding).decode(args.output_encoding)
    #                 )
    #
    #     sys.exit(0)


if __name__ == "__main__":
    main()
