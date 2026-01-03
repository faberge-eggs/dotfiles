cask "cleanmymac" do
  version "4.15.6"
  sha256 :no_check  # Skip checksum verification (use with caution)

  url "https://dl.devmate.com/com.macpaw.CleanMyMac4/CleanMyMacX.dmg"
  name "CleanMyMac X"
  desc "Tool to remove unnecessary files and optimize Mac performance"
  homepage "https://macpaw.com/cleanmymac"

  app "CleanMyMac X.app"

  zap trash: [
    "~/Library/Application Scripts/com.macpaw.CleanMyMac4",
    "~/Library/Application Support/CleanMyMac X",
    "~/Library/Application Support/CleanMyMac X Menu",
    "~/Library/Caches/com.macpaw.CleanMyMac4",
    "~/Library/Logs/CleanMyMac X.log",
    "~/Library/Preferences/com.macpaw.CleanMyMac4.plist",
  ]
end
