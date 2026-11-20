class Moonlit < Formula
  desc "Moonlit CLI: run release pipelines and render their execution."
  homepage "https://moonlit.rs/"
  version "3.0.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/wolfware-labs/moonlit/releases/download/moonlit-v3.0.3/moonlit-aarch64-apple-darwin.tar.xz"
      sha256 "f62316da0e1de139398b309d5c908d39e60641bde073ec93688410fb2015e78c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/wolfware-labs/moonlit/releases/download/moonlit-v3.0.3/moonlit-x86_64-apple-darwin.tar.xz"
      sha256 "6a079b43207a8143eb38646e09a2ba49c923077bbf025c3e9ac37ac41b0d017b"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/wolfware-labs/moonlit/releases/download/moonlit-v3.0.3/moonlit-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "925f201df0f419b7e04df8a8621fa4d468fcb16a8acdbffccb79a75cf870f22a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/wolfware-labs/moonlit/releases/download/moonlit-v3.0.3/moonlit-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "94d057107adc02ff9332ed097f3cf31e60da725299018c68c1392925dc915cc6"
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
