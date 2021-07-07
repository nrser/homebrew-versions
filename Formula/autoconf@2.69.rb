# autoconf 2.69
# ============================================================================
# 
# Erlang apparently needs autoconf 2.69 to compile on Big Sur, at least using
# [asdf](https://asdf-vm.com).
# 
# 1.  https://stackoverflow.com/questions/67442905/asdf-erlang-fails-to-compile-on-macos
# 2.  https://elixirforum.com/t/erlang-otp-22-3-4-17-released/38748/11
# 
# This is adapted from
# 
# https://gist.github.com/oriolgual/2f881fa3a151dd5f643f755ddcf2a0bc
# 
# 
# Usage
# ----------------------------------------------------------------------------
# 
# Install:
# 
#     brew install --no-binaries nrser/versions/autoconf@2.69
# 
# The `--no-binaries` prevents linking of the executables, which would fail 
# anyway (assuming you have regular `autoconf` installed).
# 
# Install Erlang:
# 
#     PATH="$(brew --prefix autoconf@2.69)/bin:$PATH" \
#       asdf install erlang [VERSION]
# 
class AutoconfAT269 < Formula
  desc "Automatic configure script builder"
  homepage "https://www.gnu.org/software/autoconf"
  url "https://ftp.gnu.org/gnu/autoconf/autoconf-2.69.tar.gz"
  mirror "https://ftpmirror.gnu.org/autoconf/autoconf-2.69.tar.gz"
  sha256 "954bd69b391edc12d6a4a51a2dd1476543da5c6bbf05a95b59dc0dd6fd4c2969"
  license all_of: [
    "GPL-3.0-or-later",
    "GPL-3.0-or-later" => { with: "Autoconf-exception-3.0" },
  ]

  bottle do
    sha256  cellar: :any_skip_relocation, 
            arm64_big_sur: "6279cc6294da77a87b2e08783f39a97e8678bde9b3e2899685879cabee6d2945"
  end

  depends_on "m4"
  uses_from_macos "perl"

  def install
    on_macos do
      ENV["PERL"] = "/usr/bin/perl"

      # force autoreconf to look for and use our glibtoolize
      inreplace "bin/autoreconf.in", "libtoolize", "glibtoolize"
      # also touch the man page so that it isn't rebuilt
      inreplace "man/autoreconf.1", "libtoolize", "glibtoolize"
    end

    system "./configure", "--prefix=#{prefix}", "--with-lispdir=#{elisp}"
    system "make", "install"

    rm_f info/"standards.info"
  end

  test do
    cp pkgshare/"autotest/autotest.m4", "autotest.m4"
    system bin/"autoconf", "autotest.m4"

    (testpath/"configure.ac").write <<~EOS
      AC_INIT([hello], [1.0])
      AC_CONFIG_SRCDIR([hello.c])
      AC_PROG_CC
      AC_OUTPUT
    EOS
    (testpath/"hello.c").write "int foo(void) { return 42; }"

    system bin/"autoconf"
    system "./configure"
    assert_predicate testpath/"config.status", :exist?
    assert_match(/\nCC=.*#{ENV.cc}/, (testpath/"config.log").read)
  end
end