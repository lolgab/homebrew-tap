cask "livedrift" do
  version "0.2.1"

  on_arm do
    sha256 "8ec8574de6b6bc47e7edc0266e1bc31a45050ec10abb9323558cd06c14fd8fd6"

    url "https://github.com/lolgab/livedrift/releases/download/v#{version}/LiveDrift-#{version}-macos-arm64.zip"
  end
  on_intel do
    sha256 "ddba9511b59c8cdbf1da526bdb124bcd98d2e409d995bf8c906ddf965fb960d9"

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
