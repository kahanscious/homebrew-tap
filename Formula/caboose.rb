class Caboose < Formula
  desc "A terminal-native AI coding agent built in Rust"
  homepage "https://trycaboose.dev"
  version "0.5.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/kahanscious/caboose/releases/download/v0.5.0/caboose-aarch64-apple-darwin.tar.xz"
      sha256 "1d478f81d0d320fa00aeadf72d5af44e9df0442f826a06c6d95cb2bc79935794"
    end
    if Hardware::CPU.intel?
      url "https://github.com/kahanscious/caboose/releases/download/v0.5.0/caboose-x86_64-apple-darwin.tar.xz"
      sha256 "1f09681b975caad2c9022ff886ffa9c47e9bd89d858020c9565f89e02df04e76"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
      url "https://github.com/kahanscious/caboose/releases/download/v0.5.0/caboose-x86_64-unknown-linux-musl.tar.xz"
      sha256 "564957c8028c46ce546645a69319e138b7fa96f3cb4522b4196ca6e8e32d81c6"
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
