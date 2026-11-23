class Moonlit < Formula
  desc "Moonlit CLI: run release pipelines and render their execution."
  homepage "https://moonlit.rs/"
  version "4.0.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/wolfware-labs/moonlit/releases/download/moonlit-v4.0.0/moonlit-aarch64-apple-darwin.tar.xz"
      sha256 "4c5864b51467a1999d29c68a9f1e5a877017f081830bd8cf4aef07e60c2042eb"
    end
    if Hardware::CPU.intel?
      url "https://github.com/wolfware-labs/moonlit/releases/download/moonlit-v4.0.0/moonlit-x86_64-apple-darwin.tar.xz"
      sha256 "4a8a4b97ca9524eb2444466267a3d9c52983613fa67d2ebe0805a10b713f8b9a"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/wolfware-labs/moonlit/releases/download/moonlit-v4.0.0/moonlit-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "c421c3a88ada8a1265d4bd2995ce17f994a2075f9d6eb1047f2895377b30e9c6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/wolfware-labs/moonlit/releases/download/moonlit-v4.0.0/moonlit-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d42a9fc669576b48c9a6ace93f6fd39e9275092d7246fb30a4931c7076af20fe"
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "moonlit"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "moonlit"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "moonlit"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "moonlit"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
