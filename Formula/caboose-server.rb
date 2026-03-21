class CabooseServer < Formula
  desc "The caboose-server application"
  version "0.7.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/kahanscious/caboose/releases/download/v0.7.1/caboose-server-aarch64-apple-darwin.tar.xz"
      sha256 "ecea8a3b266e9d691cf0382d8811960c0fca4b60426e3270184af66b7f3378ad"
    end
    if Hardware::CPU.intel?
      url "https://github.com/kahanscious/caboose/releases/download/v0.7.1/caboose-server-x86_64-apple-darwin.tar.xz"
      sha256 "c1072620ccee8a9b41f78ee617b3151dce884a77d15ca1ee304ac60ec1d588d0"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/kahanscious/caboose/releases/download/v0.7.1/caboose-server-x86_64-unknown-linux-musl.tar.xz"
    sha256 "2040b27ef2e33e6ee97f98f44564acf427a4594f77af20977a69d98d9e0712d9"
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
