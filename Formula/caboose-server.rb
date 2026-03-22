class CabooseServer < Formula
  desc "The caboose-server application"
  version "0.7.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/kahanscious/caboose/releases/download/v0.7.2/caboose-server-aarch64-apple-darwin.tar.xz"
      sha256 "44c2151cff096923729e407a208d29954475b7cf052b9383bd167ead2ec0a7ec"
    end
    if Hardware::CPU.intel?
      url "https://github.com/kahanscious/caboose/releases/download/v0.7.2/caboose-server-x86_64-apple-darwin.tar.xz"
      sha256 "c8f2396caf4c89b5d355ac6df8577117ec9295f8ff910d24b61197a9be55fa3f"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/kahanscious/caboose/releases/download/v0.7.2/caboose-server-x86_64-unknown-linux-musl.tar.xz"
    sha256 "a300fdf9460bc7169be95398542702db9b6c691f78332d072f41ef5b083f27e1"
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
    bin.install "caboose-server" if OS.mac? && Hardware::CPU.arm?
    bin.install "caboose-server" if OS.mac? && Hardware::CPU.intel?
    bin.install "caboose-server" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
