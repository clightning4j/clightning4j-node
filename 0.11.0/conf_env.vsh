#!/usr/local/bin/v run

// V script to manage the envoirment lightning env
//
// author: https://github.com/vincenzopalazzo
import os

fn build_ln_directory() string {
	ln_dir := os.environ()['CLIGHTNING_DATA']
	if !os.exists(ln_dir) {
		os.mkdir(ln_dir) or { panic('dir at path $ln_dir not created') }
		os.cp('/opt/conf', ln_dir) or { panic('can not copy the directory') }
		os.execute_or_panic('chown -R clightning4j $ln_dir')
	}
	return ln_dir
}

mut args_str := ''
for idx in 1..os.args.len {
	arg := os.args[idx]
	args_str += arg + ' '
}
ln_dir := build_ln_directory()
os.execute_or_panic('lightningd --lightning-dir=$ln_dir $args_str')
