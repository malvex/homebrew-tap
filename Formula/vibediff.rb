class Vibediff < Formula
  desc "Local Git diff viewer with real-time updates and code review features"
  homepage "https://github.com/malvex/vibediff"
  version "1.1.0"
  license "MIT"

  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/malvex/vibediff/releases/download/v1.1.0/vibediff-darwin-arm64"
    sha256 "bcc005ab9ba4cb7dc635832f64a2ab32d304dc20ee1ce3c7f7818e359405a80a"
  elsif OS.mac? && Hardware::CPU.intel?
    url "https://github.com/malvex/vibediff/releases/download/v1.1.0/vibediff-darwin-amd64"
    sha256 "4e81e993723a8e79c336766d8cff30f3e88529af12f3a815afb6ff4c4da443d1"
  elsif OS.linux? && Hardware::CPU.arm?
    url "https://github.com/malvex/vibediff/releases/download/v1.1.0/vibediff-linux-arm64"
    sha256 "e1f83ed9a9211a0c3c1f7d5c7445de687eaf0e7c6f670b09e88cc2e2b2d3bc16"
  elsif OS.linux? && Hardware::CPU.intel?
    url "https://github.com/malvex/vibediff/releases/download/v1.1.0/vibediff-linux-amd64"
    sha256 "fbc4a09a008c7cc83a0df3892c2a881f38af7b0ba5d5d0e674fd68f35a9c26f4"
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
