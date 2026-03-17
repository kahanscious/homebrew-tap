class Caboose < Formula
  desc "A terminal-native AI coding agent built in Rust"
  homepage "https://trycaboose.dev"
  version "0.4.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/kahanscious/caboose/releases/download/v0.4.0/caboose-aarch64-apple-darwin.tar.xz"
      sha256 "639d9e8eb1762fadd7036835108a08fec979e4a0487c90e2a0e1a8b7c5c8bc21"
    end
    if Hardware::CPU.intel?
      url "https://github.com/kahanscious/caboose/releases/download/v0.4.0/caboose-x86_64-apple-darwin.tar.xz"
      sha256 "2ad20088615a3e44a66c33fc74420bc5e58ef8629fb71bc1e8f67e4049daa2c6"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
      url "https://github.com/kahanscious/caboose/releases/download/v0.4.0/caboose-x86_64-unknown-linux-musl.tar.xz"
      sha256 "5659b9959a7ee8cbacf048472f76febadbc73269c089dcbc1abca90445095e28"
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
