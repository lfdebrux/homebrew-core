class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https://convox.com/"
  url "https://github.com/convox/convox/archive/3.0.38.tar.gz"
  sha256 "5ab341efe1b0277e8c911132d69275f0c16cbd8f0662c3f78c596ec9d7a5d73c"
  license "Apache-2.0"
  version_scheme 1

  bottle do
    cellar :any_skip_relocation
    sha256 "ac3a83694bc173fda6a606dfea636e81502fbd7c157b86caad08832089ce1476" => :catalina
    sha256 "820a0875da7eb54163538565619afbd685580c7b8a55c956b6deebb9c5dbcbae" => :mojave
    sha256 "df658e99deb12cd108d4ec2bfdae0418c3f224554bcf0b5913fa6c04104e803e" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X main.version=#{version}
    ].join(" ")

    system "go", "build", *std_go_args, "-mod=vendor", "-ldflags", ldflags, "./cmd/convox"
  end

  test do
    assert_equal "Authenticating with localhost... ERROR: invalid login\n",
      shell_output("#{bin}/convox login -t invalid localhost 2>&1", 1)
  end
end
