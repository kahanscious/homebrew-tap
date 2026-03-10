class Caboose < Formula
  desc "A terminal-native AI coding agent built in Rust"
  homepage "https://trycaboose.dev"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/kahanscious/caboose/releases/download/v0.1.1/caboose-aarch64-apple-darwin.tar.xz"
      sha256 "e03e94514bcf371b83c559a5e5fa6482207a8cc8d80851b1c29507f533bb6f8c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/kahanscious/caboose/releases/download/v0.1.1/caboose-x86_64-apple-darwin.tar.xz"
      sha256 "169bce83212af77f619a28abefbbd152fbcbc9503acda18f82a5ca5bf5d8ca9f"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
      url "https://github.com/kahanscious/caboose/releases/download/v0.1.1/caboose-x86_64-unknown-linux-musl.tar.xz"
      sha256 "ed09c0c4b639acf733303dd5a2d6514debda1eba50355af699de458ac9307de1"
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
