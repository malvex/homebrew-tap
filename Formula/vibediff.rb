class Vibediff < Formula
  desc "Local Git diff viewer with real-time updates and code review features"
  homepage "https://github.com/malvex/vibediff"
  version "1.0.0"
  license "MIT"

  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/malvex/vibediff/releases/download/v1.0.0/vibediff-darwin-arm64"
    sha256 "111f835e3721608fc5731d3131289a6331fd43165da1613d638d62c012083136"
  elsif OS.mac? && Hardware::CPU.intel?
    url "https://github.com/malvex/vibediff/releases/download/v1.0.0/vibediff-darwin-amd64"
    sha256 "477c4e212caeaada4790f00494a0ec1cf5f5dbc6e14fc91d48f704aae4481881"
  elsif OS.linux? && Hardware::CPU.arm?
    url "https://github.com/malvex/vibediff/releases/download/v1.0.0/vibediff-linux-arm64"
    sha256 "5564b20679feeffa843bc620fd8dc885ec54df26d092eb677d0dc1b26360ecd8"
  elsif OS.linux? && Hardware::CPU.intel?
    url "https://github.com/malvex/vibediff/releases/download/v1.0.0/vibediff-linux-amd64"
    sha256 "9142f8662a0db3e849c5bede611fe4198313700a81871688e89f6c7af43a4285"
  end

  def install
    bin.install Dir["vibediff-*"].first => "vibediff"
  end

  test do
    # Test version output
    assert_match version.to_s, shell_output("#{bin}/vibediff -version")

    # Test that the binary starts
    port = free_port

    # Start the server in the background
    pid = fork do
      exec bin/"vibediff", "-port", port.to_s
    end

    # Wait for server to start
    sleep 3

    begin
      # Check that the server is responding
      response = shell_output("curl -s -o /dev/null -w '%{http_code}' http://localhost:#{port}")
      assert_equal "200", response.strip
    ensure
      # Clean up
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
