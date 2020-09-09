class CrystalAT035 < Formula
  desc "Fast and statically typed, compiled language with Ruby-like syntax"
  homepage "https://crystal-lang.org/"
  license "Apache-2.0"
  version "0.35.1"
  url "https://github.com/crystal-lang/crystal/releases/download/0.35.1/crystal-0.35.1-1-darwin-x86_64.tar.gz"
  sha256 "7d75f70650900fa9f1ef932779bc23f79a199427c4219204fa9e221c330a1ab6"
  
  keg_only :alternative_version,
    "bin conflicts with `crystal` package"
  
  depends_on "gmp" # std uses it but it's not linked
  depends_on "libevent"
  depends_on "libyaml"
  depends_on "llvm"
  depends_on "openssl@1.1" # std uses it but it's not linked
  depends_on "pcre"
  depends_on "pkg-config" # @[Link] will use pkg-config if available

  def install
    # Copy everything *except* `bin` -- Homebrew automatically links anything in
    # the installation `bin` dir into `/usr/local/bin`, and we need to rename
    # `bin/crystal` so it doesn't conflict with the standard executable name
    prefix.install Dir["*"]
    # Now install `bin/crystal` as `bin/crystal-0.35`!
    # bin.install "bin/crystal" => "crystal-0.35"
  end

  test do
    assert_match "1", shell_output("#{bin}/crystal eval puts 1")
  end
end
