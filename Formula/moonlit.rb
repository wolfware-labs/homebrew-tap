class Moonlit < Formula
  desc "Moonlit CLI: run release pipelines and render their execution."
  homepage "https://moonlitbuild.dev/"
  version "1.1.6"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/wolfware-labs/moonlit/releases/download/moonlit-v1.1.6/moonlit-aarch64-apple-darwin.tar.xz"
      sha256 "9d2264387e1bea2e75677692260018e6d18910cc30fce3020f6b27df8f21c043"
    end
    if Hardware::CPU.intel?
      url "https://github.com/wolfware-labs/moonlit/releases/download/moonlit-v1.1.6/moonlit-x86_64-apple-darwin.tar.xz"
      sha256 "7507d71a7f6d63e6841fbbad61ebccb47964377924644e1f508c3f7143e19e9a"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/wolfware-labs/moonlit/releases/download/moonlit-v1.1.6/moonlit-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "9293484402b68ce283298cf9f54690bbe7ea2e690e6de4c7b299052b9b12742c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/wolfware-labs/moonlit/releases/download/moonlit-v1.1.6/moonlit-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "c806ef8e51398e9fdb26a0013a7d6da26e2f822d254ebded90d2adfbf9660fd9"
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
