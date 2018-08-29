# Adapted this to install `libusb@1.0.19` in an attempt to get fucking Heimdall
# working, which doesn't seem to specify what version of `libusb` it requires
# but seems to completely fail if this specific, implicit dependency is not 
# guessed exactly correct. And I think I i saw 1.0.19 mentioned somewhere, so
# I tried it, and it seemed to cause ol' Heimy to fail at a later point then 
# with the latest release (which is `1.0.22`, a fucking *patch* difference).
# There is some frustration here.
# 
class LibusbAT1019 < Formula
  desc "Library for USB device access (version 1.0.19)"
  homepage "http://libusb.info"
  url "https://downloads.sourceforge.net/project/libusb/libusb-1.0/libusb-1.0.19/libusb-1.0.19.tar.bz2"
  sha256 "6c502c816002f90d4f76050a6429c3a7e0d84204222cbff2dce95dd773ba6840"

  bottle do
    cellar :any
    # revision 1
    sha256 "11ae6492cf30f3d137f72917ddf187aafc864c73d58b4a18b6da66209fbf9e7f" => :el_capitan
  end

  head do
    url "https://github.com/libusb/libusb.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  option :universal
  option "without-runtime-logging", "Build without runtime logging functionality"
  option "with-default-log-level-debug", "Build with default runtime log level of debug (instead of none)"

  deprecated_option "no-runtime-logging" => "without-runtime-logging"

  def install
    ENV.universal_binary if build.universal?

    args = %W[--disable-dependency-tracking --prefix=#{prefix}]
    args << "--disable-log" if build.without? "runtime-logging"
    args << "--enable-debug-log" if build.with? "default-log-level-debug"

    system "./autogen.sh" if build.head?
    system "./configure", *args
    system "make", "install"
  end
end
