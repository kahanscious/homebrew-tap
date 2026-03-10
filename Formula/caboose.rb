class Caboose < Formula
  desc "A terminal-native AI coding agent built in Rust"
  homepage "https://trycaboose.dev"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/kahanscious/caboose/releases/download/v0.1.1/caboose-aarch64-apple-darwin.tar.xz"
      sha256 "821535105b4640dacd286c855ba908f17e08aa049df9fef88357b49d64aafb42"
    end
    if Hardware::CPU.intel?
      url "https://github.com/kahanscious/caboose/releases/download/v0.1.1/caboose-x86_64-apple-darwin.tar.xz"
      sha256 "6ba3cb9f46f0e836b41b1ff32ab24f296275354206f66472d54424f1ebc43650"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
      url "https://github.com/kahanscious/caboose/releases/download/v0.1.1/caboose-x86_64-unknown-linux-musl.tar.xz"
      sha256 "7bc460d7c60ee9d9b912a4b8d6e3d3fef70092a41593908a5c8d69d5c2637481"
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
