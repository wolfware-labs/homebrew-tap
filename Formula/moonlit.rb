class Moonlit < Formula
  desc "Moonlit CLI: run release pipelines and render their execution."
  homepage "https://moonlitbuild.dev/"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/wolfware-labs/moonlit/releases/download/moonlit-v0.2.0/moonlit-aarch64-apple-darwin.tar.xz"
      sha256 "4ec2ceece5a07393f33dd11895699880745a8e4f0fa2315c9f01ec1e9cd041f3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/wolfware-labs/moonlit/releases/download/moonlit-v0.2.0/moonlit-x86_64-apple-darwin.tar.xz"
      sha256 "c8019b16ef666b230a12f677b49ccb069d7877e5c44eff57e5a3f6c06b9f3780"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/wolfware-labs/moonlit/releases/download/moonlit-v0.2.0/moonlit-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "cb07dd7fd3df5cf40623f06194c69ad39cf1338aee449da036e27e29eba682e9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/wolfware-labs/moonlit/releases/download/moonlit-v0.2.0/moonlit-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "affb8383b2bbfea259c251b6e3cf63c0ba936ecb759c5540f17a50cb9f1ba9d3"
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
