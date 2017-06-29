class Bohrium < Formula
  desc "Runtime for efficiently executing vectorized applications using Python"
  homepage "http://bohrium.readthedocs.io/"
  url "https://github.com/bh107/bohrium/archive/v0.8.5.tar.gz"
  sha256 "64e32eb1a2db1913ea3d9cd360dc4152cab0241a3ada41aaabe22ab4f7863f9c"
  head "https://github.com/bh107/bohrium.git"

  depends_on :arch => :x86_64

  depends_on "cmake" => :build
  depends_on "llvm" => :build
  depends_on "swig" => :build
  depends_on "boost" => [:build, "--with-icu4c"]

  depends_on :python => :run
  depends_on "numpy" => :run
  depends_on "cython" => [:python, "cython", :build]

  depends_on "opencv3" => [:run, :optional]
  depends_on "clblas" => [:run, :optional]

  def install
    cmake_args = []
    cmake_args << "-DCMAKE_BUILD_TYPE=Release"
    cmake_args << "-DCMAKE_INSTALL_PREFIX=#{prefix}"
    cmake_args << "-Wno-dev"
    cmake_args << "-DUSE_WERROR=ON"

    cmake_args << "-DCMAKE_CXX_COMPILER=clang++"
    cmake_args << "-DCMAKE_C_COMPILER=clang"

    cmake_args << "-DCMAKE_CXX_FLAGS='-Wno-expansion-to-defined'"

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
