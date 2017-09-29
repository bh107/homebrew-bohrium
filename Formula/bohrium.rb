class Bohrium < Formula
  desc "Runtime for efficiently executing vectorized applications using Python"
  homepage "http://bohrium.readthedocs.io/"
  url "https://github.com/bh107/bohrium/archive/v0.8.7.tar.gz"
  sha256 "b23b6098b16cf081d27adb667af0150211e3cfd600fd88cce3df5c57fadc5ce4"
  head "https://github.com/bh107/bohrium.git"

  resource "Cython" do
    url "https://files.pythonhosted.org/packages/94/63/f54920c2ddbe3e1341a4c268f7091bf1bf53c3d84f4b115aa5beea64aef9/Cython-0.27.tar.gz"
    sha256 "b932b5194e87a8b853d493dc1b46e38632d6846a86f55b8346eb9c6ec3bdc00b"
  end

  depends_on :arch => :x86_64

  depends_on "cmake" => :build
  depends_on "llvm" => :build
  depends_on "boost" => [:build, "--with-icu4c"]
  depends_on "python" => :build
  depends_on "python3" => [:build, :optional]
  depends_on "swig" => :build

  # depends_on "Cython" => [:python, "Cython", :build]

  depends_on :python => :run
  depends_on :python3 => [:run, :optional]
  depends_on "numpy" => :run

  depends_on "opencv" => [:run, :optional]
  depends_on "clblas" => [:run, :optional]

  def install
    # Set some env-variables
    ENV["C_INCLUDE_PATH"] = "#{`llvm-config --includedir`.chop}"
    ENV["CPP_INCLUDE_PATH"] = "#{`llvm-config --includedir`.chop}"
    ENV["LIBRARY_PATH"] = "#{`llvm-config --libdir`.chop}:#{`echo $LIBRARY_PATH`.chop}"
    ENV["DYLD_LIBRARY_PATH"] = "#{`llvm-config --libdir`.chop}:#{`echo $DYLD_LIBRARY_PATH`.chop}"

    # Build Cython, because we can't depend on it
    pyver = Language::Python.major_minor_version "python"
    if build.with?("python3")
      pyver = Language::Python.major_minor_version "python3"
    end
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python#{pyver}/site-packages"
    ENV.prepend_create_path "PATH", libexec/"vendor/bin"
    resource("Cython").stage do
      system "python", *Language::Python.setup_install_args(libexec/"vendor")
    end

    # Make Bohrium
    system "cmake", ".", "-DCMAKE_BUILD_TYPE=Release",
                         "-DCMAKE_INSTALL_PREFIX=#{prefix}",
                         "-Wno-dev",
                         "-DUSE_WERROR=ON",
                         "-DCMAKE_CXX_COMPILER=clang++",
                         "-DCMAKE_C_COMPILER=clang",
                         "-DCMAKE_CXX_FLAGS='-Wno-expansion-to-defined'"

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
