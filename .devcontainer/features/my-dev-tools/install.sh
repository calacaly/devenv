# >>> apt setting >>>
# echo "setting apt ✅"
# <<< apt setting <<<

# >>> golang setting >>>
echo "setting golang ✅"
go env -w GO111MODULE=on
go env -w GOPROXY=https://goproxy.cn,direct
# <<< golang setting <<<

# >>> rust setting >>>
echo "setting rust ✅"
tee ~/.cargo/config <<EOF
[source.crates-io]
replace-with = 'rsproxy-sparse'
[source.rsproxy]
registry = "https://rsproxy.cn/crates.io-index"
[source.rsproxy-sparse]
registry = "sparse+https://rsproxy.cn/index/"
[registries.rsproxy]
index = "https://rsproxy.cn/crates.io-index"
[net]
git-fetch-with-cli = true
EOF
# <<< rust setting <<<

# >>> pip setting >>>
echo "setting pip ✅"
pip config set global.index-url https://mirrors.aliyun.com/pypi/simple
# <<< pip setting <<<

# >>> uv init >>>
# <<< uv init <<<

# >>> tools install >>>
# tcping
go install github.com/pouriyajamshidi/tcping/v2@latest
# trippy like tracerout
cargo install trippy --locked
# zvm for zig version manager
curl https://raw.githubusercontent.com/tristanisham/zvm/master/install.sh | bash
zvm i master --zls
# nmap
cargo install rustscan

# ruyi sdk
pipx install ruyi

apt update && apt-get install -y strace gdb

echo "tools installed ✅"
# <<< tools install <<<