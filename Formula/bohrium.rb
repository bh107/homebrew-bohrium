class Bohrium < Formula
  desc "Runtime for efficiently executing vectorized applications using Python"
  homepage "http://bohrium.readthedocs.io/"
  url "https://github.com/bh107/bohrium/archive/v0.8.10.tar.gz"
  sha256 "c82488bd60636310ad9f5ce6ea9964a72d7e9ed7b75a1533086d6c3c832466b2"
  head "https://github.com/bh107/bohrium.git"

  def install
    puts "========="
    puts "This package is deprecated. Please install Bohrium via pip for Python instead."
    puts "This can be done by using:"
    puts "pip install -U bohrium"
    puts "========="
    exit 1
  end
end
