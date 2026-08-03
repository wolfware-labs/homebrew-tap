class Moonlit < Formula
  desc "Moonlit CLI: run release pipelines and render their execution."
  homepage "https://moonlitbuild.dev/"
  version "1.1.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/wolfware-labs/moonlit/releases/download/moonlit-v1.1.4/moonlit-aarch64-apple-darwin.tar.xz"
      sha256 "bb65aa1811adbf71de676bb0b80648327ea802151f9bfa40207b6984dca10301"
    end
    if Hardware::CPU.intel?
      url "https://github.com/wolfware-labs/moonlit/releases/download/moonlit-v1.1.4/moonlit-x86_64-apple-darwin.tar.xz"
      sha256 "87ab800cb5bf52f744e315c5ec56e493810bc7f4278758d61811352fcef3ff3c"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/wolfware-labs/moonlit/releases/download/moonlit-v1.1.4/moonlit-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "ba1ced478c008aee01c764d7e1b7bf1bf48767992433775fc2c42fbdeed2def4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/wolfware-labs/moonlit/releases/download/moonlit-v1.1.4/moonlit-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "618fa4341a8473163853399a66de0da3297d69904b91425c858caed1849ea9e0"
    end
  end
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "moonlit" if OS.mac? && Hardware::CPU.arm?
    bin.install "moonlit" if OS.mac? && Hardware::CPU.intel?
    bin.install "moonlit" if OS.linux? && Hardware::CPU.arm?
    bin.install "moonlit" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
