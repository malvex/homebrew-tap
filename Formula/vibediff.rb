class Vibediff < Formula
  desc "Local Git diff viewer with real-time updates and code review features"
  homepage "https://github.com/malvex/vibediff"
  version "1.2.0"
  license "MIT"

  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/malvex/vibediff/releases/download/v1.2.0/vibediff-darwin-arm64"
    sha256 "4d3ac2ff8f6bf9b6cdbf940f499f8d942bb519bbb2d83f919bd5c45272a800bb"
  elsif OS.mac? && Hardware::CPU.intel?
    url "https://github.com/malvex/vibediff/releases/download/v1.2.0/vibediff-darwin-amd64"
    sha256 "110678b89bf0142b398875b3359c0ac9fb762e68377a58618e8582d088e455c1"
  elsif OS.linux? && Hardware::CPU.arm?
    url "https://github.com/malvex/vibediff/releases/download/v1.2.0/vibediff-linux-arm64"
    sha256 "4116a0e5b7fb8c4e5523a81c48c4e71cfaa759de1d8bb4cb3ea2968f580c5708"
  elsif OS.linux? && Hardware::CPU.intel?
    url "https://github.com/malvex/vibediff/releases/download/v1.2.0/vibediff-linux-amd64"
    sha256 "7c48c82bb4a09b455eb1c044ba3b85bb4677ff62377a914b896d5f14b6ce4275"
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
