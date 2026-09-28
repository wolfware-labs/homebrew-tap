class Moonlit < Formula
  desc "Moonlit CLI: run release pipelines and render their execution."
  homepage "https://moonlit.rs/"
  version "3.0.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/wolfware-labs/moonlit/releases/download/moonlit-v3.0.0/moonlit-aarch64-apple-darwin.tar.xz"
      sha256 "45a39bcc4f974a4e3fc173f4c3ed990f8d7f1c7f62b809dbfd958a7c710061fb"
    end
    if Hardware::CPU.intel?
      url "https://github.com/wolfware-labs/moonlit/releases/download/moonlit-v3.0.0/moonlit-x86_64-apple-darwin.tar.xz"
      sha256 "3962a291a9a791c16cc3cee1fd676c5f42dbddc4f2fd79447861c6b29fb3d9a6"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/wolfware-labs/moonlit/releases/download/moonlit-v3.0.0/moonlit-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "7bac554932b9cea08c5efaee3341a684efc9df14f76d7bef0ce560132a1510fb"
    end
    if Hardware::CPU.intel?
      url "https://github.com/wolfware-labs/moonlit/releases/download/moonlit-v3.0.0/moonlit-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "b90148f679ed4ffda893be66417449134c21ebe0717589d14ea1d2f9023b842f"
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
