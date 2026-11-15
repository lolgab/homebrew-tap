cask "livedrift" do
  version "0.2.0"

  on_arm do
    sha256 "c543c9be3b9519bc6633fbc49df4bc9df458784a531431c20eb8e138e6e37e09"

    url "https://github.com/lolgab/livedrift/releases/download/v#{version}/LiveDrift-#{version}-macos-arm64.zip"
  end
  on_intel do
    sha256 "effb98c91bf86a7cacc5e400f724db2525aadc9b2f64152bf5fbabfb7645be81"

    url "https://github.com/lolgab/livedrift/releases/download/v#{version}/LiveDrift-#{version}-macos-x86_64.zip"
  end

  name "LiveDrift"
  desc "Live P2P stream player that plays and shares acestream:// links"
  homepage "https://github.com/lolgab/livedrift"

  depends_on :macos

  app "LiveDrift.app"

  # The app is ad-hoc signed, not notarized, so Gatekeeper would refuse to open a quarantined
  # copy. Installing from this tap is the user's explicit choice; clear the quarantine flag and
  # register the app as the acestream:// handler.
  postflight_steps do
    run "/usr/bin/xattr",
        args:         ["-dr", "com.apple.quarantine", "{{appdir}}/LiveDrift.app"],
        must_succeed: false
    run "/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister",
        args:         ["-f", "{{appdir}}/LiveDrift.app"],
        must_succeed: false
  end

  zap trash: [
    "~/Library/Preferences/com.github.lolgab.livedrift.plist",
    "~/Library/Saved Application State/com.github.lolgab.livedrift.savedState",
  ]

  caveats <<~EOS
    LiveDrift needs a player installed: brew install mpv   (or VLC, IINA, ffmpeg)
  EOS
end
