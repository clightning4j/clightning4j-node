// V script to manage the envoirment lightning env
//
// author: https://github.com/vincenzopalazzo
import os

fn run_tor() {
	if os.exists('/home/clightning4j/.tor') {
		os.execute_or_panic('rm -r /home/clightning4j/.tor')
	}
	println(os.execute_or_panic('tor --runasdaemon 1').output)
	curl_res := os.execute_or_panic('curl --socks5 localhost:9050 --socks5-hostname localhost:9050 -s https://check.torproject.org/ | cat | grep -m 1 Congratulations | xargs')
	println(curl_res.output)
	os.execute_or_panic('chown -R clightning4j /home/clightning4j/.tor')
}

fn build_ln_directory() string {
	ln_dir := os.environ()['CLIGHTNING_DATA']
	if !os.exists(ln_dir) {
		os.mkdir(ln_dir) or { panic('dir at path $ln_dir not created') }
		os.execute_or_panic('cp /opt/config $ln_dir/config')
		os.execute_or_panic('chown -R clightning4j $ln_dir')
	}
	run_tor()
	return ln_dir
}

println(os.args)

mut args_str := ''
for idx in 1 .. os.args.len {
	arg := os.args[idx]
	args_str += arg + ' '
}

if args_str.contains('lightning-cli') || !args_str.contains('--') {
	println(os.execute_or_panic(args_str).output)
} else {
	ln_dir := build_ln_directory()
	os.execute_or_panic('lightningd --lightning-dir=$ln_dir $args_str')
}
