class Bohrium < Formula
  desc "Runtime for efficiently executing vectorized applications using Python"
  homepage "http://bohrium.readthedocs.io/"
  url "https://github.com/bh107/bohrium/archive/v0.5.tar.gz"
  sha256 "4457cd6faf4f014d58824d161704b5ab0fefa813256110b04f3b9bae39c39dfa"
  head "https://github.com/bh107/bohrium.git"

  depends_on :arch => :x86_64

  depends_on "cmake" => :build
  depends_on "swig" => :build
  depends_on "hwloc" => [:build, "universal"]
  depends_on "boost" => [:build, "--with-icu4c"]

  depends_on "mono" => [:build, :optional]

  depends_on :python => :run
  depends_on "numpy" => :run

  def install
    cmake_args = ["-DCMAKE_BUILD_TYPE=Release", "-DCMAKE_INSTALL_PREFIX=#{prefix}", "-Wno-dev", "-DUSE_WERROR=ON"]

    if build.without?("mono")
      cmake_args << "-DTEST_CIL=OFF"
      cmake_args << "-DBRIDGE_CIL=OFF"
      cmake_args << "-DBRIDGE_NUMCIL=OFF"
    end

    system "cmake", ".", *cmake_args

    system "make"
    system "make", "install"

    mkdir_p "#{prefix}/var/bohrium/objects"
    mkdir_p "#{prefix}/var/bohrium/kernels"
    touch "#{prefix}/var/bohrium/objects/.empty"
    touch "#{prefix}/var/bohrium/kernels/.empty"
  end

  test do
    system "test/c/helloworld/bh_hello_world_c"
  end
end
