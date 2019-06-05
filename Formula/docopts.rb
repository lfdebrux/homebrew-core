# Documentation: https://docs.brew.sh/Formula-Cookbook
#                https://rubydoc.brew.sh/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
class Docopts < Formula
  desc "Shell interpreter for docopt, the command-line interface description language."
  homepage "https://github.com/docopt/docopts"
  url "https://github.com/docopt/docopts/archive/v0.6.3-alpha1.tar.gz"
  sha256 "bb8ecc5d0731ab8f7364899fef92e44bd8864f0e36aff0cbdb937dce4bb6820d"
  head "https://github.com/docopt/docopts.git"

  depends_on "go" => :build

  resource "docopt-go" do
    url "https://github.com/docopt/docopt.go/archive/0.6.2.tar.gz"
    sha256 "bfd2816c9b1830eff84fc97fdad8fbf88ed56b6fccfe29d40c85c55e676edea9"
  end

  def install
    ENV["GOPATH"] = buildpath
    ENV.prepend_create_path "PATH", buildpath/"bin"

    dir = buildpath/"src/github.com/docopt/docopts"
    dir.install buildpath.children - [buildpath/".brew_home"]

    cd dir do
      system "make", "docopt-go"
      system "make", "docopts-OSX"
      system "mv", "docopts-OSX", "docopts"

      bin.install "docopts", "docopts.sh"
      prefix.install_metafiles
    end
  end

  test do
    assert_equal "echo 'Usage: test [-h]'\nexit 0", shell_output("#{bin}/docopts -h 'Usage: test [-h]' : -h").strip
  end
end
