class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.559",
      revision: "c5a8970bb35ead4d19e662845f341fe6b6529e77"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4b09149362c7e49e00bc04edebe8c2f48938d6ee27835cb370cd3b56b1cc5793"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4b09149362c7e49e00bc04edebe8c2f48938d6ee27835cb370cd3b56b1cc5793"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4b09149362c7e49e00bc04edebe8c2f48938d6ee27835cb370cd3b56b1cc5793"
    sha256 cellar: :any_skip_relocation, ventura:        "6b9c99dcc610de2e0a46fee10b5edd9181443943960e771ec42334940cd499e4"
    sha256 cellar: :any_skip_relocation, monterey:       "6b9c99dcc610de2e0a46fee10b5edd9181443943960e771ec42334940cd499e4"
    sha256 cellar: :any_skip_relocation, big_sur:        "6b9c99dcc610de2e0a46fee10b5edd9181443943960e771ec42334940cd499e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7d6bf28d4629ed0f476abe546896bd74cc2866e6f24ab3a3a24f42e3cb0e3608"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
      -X github.com/superfly/flyctl/internal/buildinfo.environment=production
      -X github.com/superfly/flyctl/internal/buildinfo.buildDate=#{time.iso8601}
      -X github.com/superfly/flyctl/internal/buildinfo.version=#{version}
      -X github.com/superfly/flyctl/internal/buildinfo.commit=#{Utils.git_short_head}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    bin.install_symlink "flyctl" => "fly"

    generate_completions_from_executable(bin/"flyctl", "completion")
  end

  test do
    assert_match "flyctl v#{version}", shell_output("#{bin}/flyctl version")

    flyctl_status = shell_output("#{bin}/flyctl status 2>&1", 1)
    assert_match "Error: No access token available. Please login with 'flyctl auth login'", flyctl_status
  end
end
