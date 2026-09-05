class Moonlit < Formula
  desc "Moonlit CLI: run release pipelines and render their execution."
  homepage "https://moonlitbuild.dev/"
  version "1.1.9"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/wolfware-labs/moonlit/releases/download/moonlit-v1.1.9/moonlit-aarch64-apple-darwin.tar.xz"
      sha256 "43e0a831fb710d4f095cd5fc90498235952e30dd8f975e9daca0d0a36a9a3eef"
    end
    if Hardware::CPU.intel?
      url "https://github.com/wolfware-labs/moonlit/releases/download/moonlit-v1.1.9/moonlit-x86_64-apple-darwin.tar.xz"
      sha256 "0408cb3794fb04b37d4e62543f403f81f9c721e7aed3b8ba86b93cedfb937101"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/wolfware-labs/moonlit/releases/download/moonlit-v1.1.9/moonlit-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "914dc6bbc1912eb5b99e135e8336c2ced038b1674b68e94d71ade8c79d78274e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/wolfware-labs/moonlit/releases/download/moonlit-v1.1.9/moonlit-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "0fe7b6e3363d67180fc6fd09a894069372f9fbf05ba98297f90d4ccea6fa4c30"
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
