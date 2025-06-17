#!/usr/bin/env python

from pathlib import Path
import argparse
import subprocess as sp

parser = argparse.ArgumentParser()
parser.add_argument("input_file", type=Path)
args = parser.parse_args()


def get_header(filename: Path) -> (str, str):
    lines = []
    bodylines = []
    in_header = True
    with open(filename) as infile:
        for line in infile:
            if in_header:
                lines.append(line)
            else:
                bodylines.append(line)
            if line.strip() == "...":
                in_header = False
        header = ''.join(lines)
        body = ''.join(bodylines)
    return header, body

def run_pandoc(body: str) -> str:
    args = ['flatpak', 'run', 'org.pandoc.Pandoc', '-t', 'revealjs', '--slide-level=2']

    p = sp.run(args, input=body.encode('utf-8'), capture_output=True)
    return p.stdout.decode()


header, body = get_header(args.input_file)
body = run_pandoc(body)
print(header, end='')
print(body, end='')

