cask "openms4-proteomics-lfq" do
  arch arm: "arm64", intel: "x64"

  version "1.0.0-ci.2,cf12fe9163e3"
  sha256 arm:   "37e52eb0072cd14b9e249885eaa34c8475178ec5374b14661aa01e0b987a5b4c",
         intel: "c6a91452de569def1850cabf9c135b09203c7164510bebb7bd1315ddf819d65f"

  url "https://github.com/okohlbacher/OpenMS4-proteomics-lfq/releases/download/" \
      "proteomics-lfq-v#{version.csv.first}/OpenMS4-proteomics-lfq-macos-#{arch}-Homebrew-#{version.csv.second}.tar.gz"
  name "OpenMS 4 proteomics-lfq tools"
  desc "Command-line mass-spectrometry tools built against the OpenMS Core SDK"
  homepage "https://github.com/okohlbacher/OpenMS4-proteomics-lfq"

  depends_on formula: "okohlbacher/openms4-core/openms4-core"
  depends_on macos: :sequoia

  payload = "OpenMS4-proteomics-lfq-macos-#{arch}-Homebrew-#{version.csv.second}"
  binary "#{payload}/bin/ProteomicsLFQ"

  postflight_steps do
    run "/usr/bin/xattr",
        args:           ["-dr", "com.apple.quarantine", "."],
        chdir:          ".",
        writable_paths: ["."]
  end
end
