class Moonlit < Formula
  desc "Moonlit CLI: run release pipelines and render their execution."
  homepage "https://moonlitbuild.dev/"
  version "1.1.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/wolfware-labs/moonlit/releases/download/moonlit-v1.1.5/moonlit-aarch64-apple-darwin.tar.xz"
      sha256 "088b3b96283339b2e0081bf36ca4d7a0357c188b4b9dc5b99a6dd915000cdb1a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/wolfware-labs/moonlit/releases/download/moonlit-v1.1.5/moonlit-x86_64-apple-darwin.tar.xz"
      sha256 "d6b499ed174535df8776c140399f07d65e4342bd2c87d8a5597ecb9961bc1d17"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/wolfware-labs/moonlit/releases/download/moonlit-v1.1.5/moonlit-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "be040b9037735db42ec5515e5933f4d4d353bcf787e3d18fffc5d4faad74f50a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/wolfware-labs/moonlit/releases/download/moonlit-v1.1.5/moonlit-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "deec22fe3e30546dc3af37c30f88361243117fc9d24d2f811132e209395a4057"
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
