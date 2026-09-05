class Moonlit < Formula
  desc "Moonlit CLI: run release pipelines and render their execution."
  homepage "https://moonlitbuild.dev/"
  version "1.1.8"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/wolfware-labs/moonlit/releases/download/moonlit-v1.1.8/moonlit-aarch64-apple-darwin.tar.xz"
      sha256 "5178fec8a469dc683e48a97457f925a557a7b7e2704a9ee9dcecca3acaaddbde"
    end
    if Hardware::CPU.intel?
      url "https://github.com/wolfware-labs/moonlit/releases/download/moonlit-v1.1.8/moonlit-x86_64-apple-darwin.tar.xz"
      sha256 "291c7c382c43187591cc11ae599533cb44e2e3a0266d6f443c5901b373af48ad"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/wolfware-labs/moonlit/releases/download/moonlit-v1.1.8/moonlit-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "472ecc817dcaf172a2a20daeb98d35401533d905c4182b544553c88594d0cb65"
    end
    if Hardware::CPU.intel?
      url "https://github.com/wolfware-labs/moonlit/releases/download/moonlit-v1.1.8/moonlit-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "7fbc02fbbc2be08a0f43d3a60ce7345c59118ac4fc35494a14a8ae4e654aa404"
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
