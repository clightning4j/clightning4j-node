#!/usr/bin/env python
import subprocess
import os
import sys
import fnmatch
import shutil
from os import path


def run_cmd(cmd: str, shell: bool = False) -> int:
    process = subprocess.run(cmd.split(), stdout=subprocess.PIPE)
    print(process.stdout.decode("utf-8"))
    return process.returncode


def look_cmd(cmd: str) -> int:
    p = subprocess.Popen(cmd.split(), stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
    for line in iter(p.stdout.readline, b""):
        print(line)
    p.stdout.close()
    return p.returncode


def copyfiles(srcdir: str, dstdir: str, filepattern: str):
    def failed(exc):
        raise exc

    for dirpath, dirs, files in os.walk(srcdir, topdown=True, onerror=failed):
        for file in fnmatch.filter(files, filepattern):
            shutil.copy2(os.path.join(dirpath, file), dstdir)


def run_tor():
    if path.exists("/home/clightning4j/.tor"):
        run_cmd("rm -r /home/clightning4j/.tor")

    run_cmd("tor --runasdaemon 1")
    run_cmd(
        "curl --socks5 localhost:9050 --socks5-hostname localhost:9050 -s https://check.torproject.org/ | cat | grep -m 1 Congratulations | xargs"
    )
    run_cmd("chown -R clightning4j /home/clightning4j/.tor")


def build_ln_directory() -> str:
    ln_dir = os.environ["CLIGHTNING_DATA"]
    if not path.exists(ln_dir):
        run_cmd(f"mkdir {ln_dir}")
        run_cmd(f"mkdir {ln_dir}/plugins")
    run_cmd(f"cp -rf /opt/config {ln_dir}/config")
    copyfiles("/opt", f"{ln_dir}/plugins", "*.sh")
    run_cmd(f"chown -R clightning4j {ln_dir}")
    run_tor()
    return ln_dir


if __name__ == "__main__":
    args_str = ""
    for arg in sys.argv:
        if arg == "/opt/conf_env.py":
            continue
        args_str += arg + " "

    if "lightning-cli" in args_str or not "--" in args_str:
        run_cmd(args_str)
    else:
        ln_dir = build_ln_directory()
        cmd = f"lightningd --lightning-dir={ln_dir} {args_str}"
        print(f"cmd prepared is: {cmd}")
        sys.exit(look_cmd(cmd))
