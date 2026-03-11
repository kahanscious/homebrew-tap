class Caboose < Formula
  desc "A terminal-native AI coding agent built in Rust"
  homepage "https://trycaboose.dev"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/kahanscious/caboose/releases/download/v0.2.0/caboose-aarch64-apple-darwin.tar.xz"
      sha256 "9089119882211432c300b1181afa5e19d47bcf77361e63da3d90b729a6f8a3b3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/kahanscious/caboose/releases/download/v0.2.0/caboose-x86_64-apple-darwin.tar.xz"
      sha256 "85f39ebeeb28495df9a10f446987337ae1d9fc6e5ed59941170e5b96960737ed"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
      url "https://github.com/kahanscious/caboose/releases/download/v0.2.0/caboose-x86_64-unknown-linux-musl.tar.xz"
      sha256 "02851a5a686ca8ecf9363474b02196a6ac2679784e3d35444afe2033d3795a00"
  end

  BINARY_ALIASES = {
    "aarch64-apple-darwin":              {},
    "x86_64-apple-darwin":               {},
    "x86_64-pc-windows-gnu":             {},
    "x86_64-unknown-linux-gnu":          {},
    "x86_64-unknown-linux-musl-dynamic": {},
    "x86_64-unknown-linux-musl-static":  {},
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
    bin.install "caboose" if OS.mac? && Hardware::CPU.arm?
    bin.install "caboose" if OS.mac? && Hardware::CPU.intel?
    bin.install "caboose" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
