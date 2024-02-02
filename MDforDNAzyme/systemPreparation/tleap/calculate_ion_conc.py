#!/usr/bin/env python
# -*- coding:utf-8 -*-
import argparse
import math
import os
import socket
import time

def _parse_args():
    parser = argparse.ArgumentParser(
        description='Parse arguments for this module!',
        formatter_class=argparse.ArgumentDefaultsHelpFormatter
        )
    parser.add_argument(
        '-bv', '--box_volume', default=0.0, type=float,
        help='Box volume (in A^3)'
        )
    parser.add_argument(
        '-ic', '--ion_conc', default=150, type=float,
        help='Ion concentration (in mM)'
        )

    return parser.parse_args()


if __name__ == "__main__":
    args = _parse_args()
    print(time.strftime("%c"))
    print(f"This task started on host {socket.gethostname()}.")

    V = args.box_volume * (1./1.e10**3.) * (1.e2**3.) * (1./1.e3)
    Cl_ions_per_liter = args.ion_conc * (1./1.e3) * (6.022*1.e23)
    Cl_ions = V * Cl_ions_per_liter

    print()
    print("=====================================================")
    print(f"The box volume is {'{:.2e}'.format(V)} Liter.")
    print(f"The ion concentration is {args.ion_conc} mM.")
    print()
    print(f"The number of chloride ions is {math.ceil(Cl_ions)}.")
    print("=====================================================")