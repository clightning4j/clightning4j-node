#!/usr/bin/env python
import subprocess
import os
import sys
from os import path

def run_cmd(cmd: str) -> str:
	process = subprocess.run(cmd.split(), stdout=subprocess.PIPE, stderr=subprocess.PIPE,
    check=True, text=True)
	print(process.stdout)

def run_tor():
	if path.exists('/home/clightning4j/.tor'):
		run_cmd('rm -r /home/clightning4j/.tor')

	run_cmd('tor --runasdaemon 1')
	run_cmd('curl --socks5 localhost:9050 --socks5-hostname localhost:9050 -s https://check.torproject.org/ | cat | grep -m 1 Congratulations | xargs')
	run_cmd('chown -R clightning4j /home/clightning4j/.tor')


def build_ln_directory() -> str:
	ln_dir = os.environ['CLIGHTNING_DATA']
	if not path.exists(ln_dir):
		run_cmd(f"mkdir {ln_dir}")
		run_cmd('cp /opt/config $ln_dir/config')
		run_cmd('mkdir $ln_dir/plugins')
		run_cmd('cp /opt/*.sh $ln_dir/plugins/')
		run_cmd('chown -R clightning4j $ln_dir')
	run_tor()
	return ln_dir

args_str = ''
for arg in sys.argv:
	args_str += arg + ' '

if 'lightning-cli' in args_str or not '--' in args_str:
	run_cmd(args_str)
else:
	ln_dir = build_ln_directory()
	run_cmd(f'lightningd --lightning-dir={ln_dir} {args_st}')
