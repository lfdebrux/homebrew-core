class Ensmallen < Formula
  desc "Flexible C++ library for efficient mathematical optimization"
  homepage "https://ensmallen.org"
  url "https://github.com/mlpack/ensmallen/archive/2.14.0.tar.gz"
  sha256 "94a40e244a9fb3b0baec98df4bbf1446cbbba91bb9ae62775e5c97ebcd3ed2b2"
  license "BSD-3-Clause"
  head "https://github.com/mlpack/ensmallen.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "704aa9150434fadd578a6f485a392cc9eca5bde5cbb0c1692e0c8c34bc89976c" => :catalina
    sha256 "704aa9150434fadd578a6f485a392cc9eca5bde5cbb0c1692e0c8c34bc89976c" => :mojave
    sha256 "704aa9150434fadd578a6f485a392cc9eca5bde5cbb0c1692e0c8c34bc89976c" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "armadillo"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <ensmallen.hpp>
      using namespace ens;
      int main()
      {
        test::RosenbrockFunction f;
        arma::mat coordinates = f.GetInitialPoint();
        Adam optimizer(0.001, 32, 0.9, 0.999, 1e-8, 3, 1e-5, true);
        optimizer.Optimize(f, coordinates);
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-std=c++11", "-I#{include}", "-I#{Formula["armadillo"].opt_lib}/libarmadillo",
                    "-o", "test"
  end
end
