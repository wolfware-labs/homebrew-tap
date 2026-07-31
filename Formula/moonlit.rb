class Moonlit < Formula
  desc "Moonlit CLI: run release pipelines and render their execution."
  homepage "https://moonlitbuild.dev/"
  version "1.0.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/wolfware-labs/moonlit/releases/download/moonlit-v1.0.0/moonlit-aarch64-apple-darwin.tar.xz"
      sha256 "a523f0ae30b42363c6bc5607707a36c6a5d55478a60a6abb69a0e5a14a986153"
    end
    if Hardware::CPU.intel?
      url "https://github.com/wolfware-labs/moonlit/releases/download/moonlit-v1.0.0/moonlit-x86_64-apple-darwin.tar.xz"
      sha256 "133ef1c96f3d29d781c529c11bd2a655dbedd5a6ad4425db6345ad299f68d379"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/wolfware-labs/moonlit/releases/download/moonlit-v1.0.0/moonlit-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "dc0988f7606ca9ae1c009e5bada218ae18e01ea0188264d8b382e5a6b6364572"
    end
    if Hardware::CPU.intel?
      url "https://github.com/wolfware-labs/moonlit/releases/download/moonlit-v1.0.0/moonlit-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "c953374c676b59d0a7c768a067b1a551710135f9f7d42edf202426bc9704c376"
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
