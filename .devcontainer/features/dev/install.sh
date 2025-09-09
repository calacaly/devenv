# >>> apt setting >>>
# echo "setting apt ✅"
# <<< apt setting <<<

# === 函数：安全地将路径添加到指定文件的 PATH 中 ===
add_to_path() {
  local target_path="$1"
  local config_file=$(get_config_file)

  # 检查参数
  if [ -z "$target_path" ]; then
    echo "❌ Usage: add_to_path '/path/to/bin'"
    return 1
  fi

  # 转义特殊字符（防止 / 或 . 导致 grep 错误）
  local escaped_path
  escaped_path=$(printf '%s\n' "$target_path" | sed 's/[[\.*^$()+?{|]/\\&/g')

  # 检查是否已存在
  if grep -qF "PATH.*$escaped_path" "$config_file" 2>/dev/null; then
    echo "🔍 $config_file already contains $target_path, skipping."
    return 0
  fi

  # 写入 export PATH
  echo "export PATH=\"\$PATH:$target_path\"" >> "$config_file"
  export PATH="$PATH:$target_path"
  echo "✅ Added $target_path to $config_file"
}

# === 获取当前用户 shell ===
get_user_shell() {
  getent passwd "$(id -u)" | cut -d: -f7
}

# === 获取 shell 名称（bash/zsh）===
get_shell_name() {
  basename "$(get_user_shell)"
}

get_config_file() {
  local shell_name=$(get_shell_name)
  case $shell_name in
    bash)
      echo "$HOME/.bashrc"
      ;;
    zsh)
      echo "$HOME/.zshrc"
      ;;
    *)
      echo "Unsupported shell: $shell_name"
      exit 1
      ;;
  esac
}


# >>> golang setting >>>
echo "setting golang ✅"
go env -w GO111MODULE=on
go env -w GOPROXY=https://goproxy.cn,direct

add_to_path "$HOME/go/bin"

# <<< golang setting <<<

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
source $HOME/.bashrc
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
    netcat-openbsd \
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

# >>> rust setting >>>
echo "setting rust ✅"
mkdir -p ~/.cargo
touch ~/.cargo/config.toml
tee ~/.cargo/config.toml <<EOF
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