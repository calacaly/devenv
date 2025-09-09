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
# tcping https://github.com/pouriyajamshidi/tcping
go install github.com/pouriyajamshidi/tcping/v2@latest

# https://github.com/fujiapple852/trippy
cargo install trippy --locked

# https://github.com/orhun/binsider
cargo install binsider
# # https://github.com/bee-san/RustScan
cargo install rustscan
# https://github.com/hatoo/oha
cargo install oha 
# https://github.com/ClementTsang/bottom
cargo install bottom
# https://github.com/hatoo/oha
cargo install oha
# https://github.com/dalance/procs
cargo install procs

# https://github.com/tristanisham/zvm
curl https://raw.githubusercontent.com/tristanisham/zvm/master/install.sh | bash
# zvm for zig version manager
zvm i master --zls

# ruyi sdk https://github.com/ruyisdk/ruyi
pipx install ruyi

# https://github.com/xmake-io/xmake
curl -fsSL https://xmake.io/shget.text | bash

apt update && apt-get install -y --no-install-recommends \
    strace \
    make \
    cmake \
    gdb \
    tcpdump \
    inetutils-telnet \
    netcat-openbsd
    procps \
    iproute2 \
    net-tools \ 
    bind9-dnsutils \
    iperf3 \
    vim \
    bash-completion \
    llvm \
    clangd \
    clang-tools

echo "tools installed ✅"
# <<< tools install <<<