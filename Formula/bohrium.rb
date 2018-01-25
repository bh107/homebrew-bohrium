class Bohrium < Formula
  desc "Runtime for efficiently executing vectorized applications using Python"
  homepage "http://bohrium.readthedocs.io/"
  url "https://github.com/bh107/bohrium/archive/v0.8.9.tar.gz"
  sha256 "d19ca1362d9ffb2a8aecd8f534af5426fe32315114baf39c819a77af6ee92774"
  head "https://github.com/bh107/bohrium.git"

  depends_on :arch => :x86_64

  depends_on "cmake" => :build
  depends_on "boost" => [:build, "with-icu4c", "with-c++11"]
  depends_on "swig" => :build

  depends_on "python"
  depends_on "python3" => :optional
  # depends_on "cython" => [:python]
  depends_on "numpy"
  depends_on "llvm" => ["with-toolchain", "with-shared-libs"]

  depends_on "opencv" => :optional
  depends_on "clblas" => :optional

  def install
    # Set some env-variables
    ENV.prepend_create_path "C_INCLUDE_PATH",   "#{`llvm-config --includedir`.chop}"
    ENV.prepend_create_path "CPP_INCLUDE_PATH", "#{`llvm-config --includedir`.chop}"
    ENV.prepend_create_path "LIBRARY_PATH",     "#{`llvm-config --libdir`.chop}"

    # Make Bohrium
    system "cmake", ".", "-DCMAKE_BUILD_TYPE=Release",
                         "-DCMAKE_INSTALL_PREFIX=#{prefix}",
                         "-Wno-dev",
                         "-DEXT_VISUALIZER=OFF",
                         "-DUSE_WERROR=ON",
                         "-DCMAKE_CXX_COMPILER=clang++",
                         "-DCMAKE_C_COMPILER=clang",
                         "-DCMAKE_CXX_FLAGS='-Wno-expansion-to-defined'"

    system "make", "install"
  end

  def post_install
    mkdir_p "#{prefix}/var/bohrium/objects"
    mkdir_p "#{prefix}/var/bohrium/kernels"
    touch "#{prefix}/var/bohrium/objects/.empty"
    touch "#{prefix}/var/bohrium/kernels/.empty"
  end

  def caveats
    pyver = Language::Python.major_minor_version "python"
    if build.with?("python3")
      pyver = Language::Python.major_minor_version "python3"
    end

    # Make sure `llvm-config` is present in PATH
    ENV["PATH"]="/usr/local/opt/llvm/bin:#{ENV["PATH"]}"

    <<-EOS.undent
    You may need to include the following in various environment variables for Bohrium to work properly:
        export PYTHONPATH="/usr/local/lib/python#{pyver}/site-packages:$PYTHONPATH"
        export LIBRARY_PATH="#{`llvm-config --libdir`.chop}:$LIBRARY_PATH"
        export DYLD_LIBRARY_PATH="/usr/local/lib:$DYLD_LIBRARY_PATH"

    Also make sure that 'clang' is on your PATH with e.g.
        export PATH="/usr/local/opt/llvm/bin:$PATH"
    EOS
  end

  test do
    system "test/c/helloworld/bh_hello_world_c"
  end
end
