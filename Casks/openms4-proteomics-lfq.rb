cask "openms4-proteomics-lfq" do
  arch arm: "arm64", intel: "x64"

  version "1.0.0-ci.6,7cdd81d601f4"
  sha256 arm:   "8164dad40b3b72c3608de836b38936339e5a95d89b5a136eb68be72cd15931ee",
         intel: "a1192d07f880446bd2f963905b5acab155aa7a95557f4c8afa8e8bbcbede213a"

  url "https://github.com/okohlbacher/OpenMS4-proteomics-lfq/releases/download/" \
      "proteomics-lfq-v#{version.csv.first}/OpenMS4-proteomics-lfq-macos-#{arch}-Homebrew-#{version.csv.second}.tar.gz"
  name "OpenMS 4 proteomics-lfq tools"
  desc "Command-line mass-spectrometry tools built against the OpenMS Core SDK"
  homepage "https://github.com/okohlbacher/OpenMS4-proteomics-lfq"

  depends_on formula: "okohlbacher/openms4-core/openms4-core"
  depends_on macos: :sequoia

  payload = "OpenMS4-proteomics-lfq-macos-#{arch}-Homebrew-#{version.csv.second}"
  binary "#{payload}/bin/ProteomicsLFQ"

  # libOpenMS has no versioned name, so a payload only runs with the Core it was built against.
  preflight do
    config = "#{HOMEBREW_PREFIX}/opt/openms4-core/lib/cmake/OpenMS/OpenMSConfig.cmake"
    core = File.exist?(config) ? File.read(config)[/set\(OpenMS_SOURCE_REVISION "([0-9a-f]{40})"\)/, 1] : nil
    next if core == "7d90cec8718d28518527acc10b495550f106de26"

    raise Cask::CaskError, "openms4-proteomics-lfq #{version.csv.first} was built against openms4-core 7d90cec8718d, " \
                           "but the installed openms4-core is #{core&.slice(0, 12) || "unknown"}. " \
                           "Install the openms4-proteomics-lfq release built for the installed Core."
  end

  postflight_steps do
    run "/usr/bin/xattr",
        args:           ["-dr", "com.apple.quarantine", "."],
        chdir:          ".",
        writable_paths: ["."]
  end
end
