cask "openms4-proteomics-lfq" do
  arch arm: "arm64", intel: "x64"

  version "1.0.0-ci.4,c9439ea7c8d9"
  sha256 arm:   "24a1bec325c5b928fa6b0acd5f1b630d333a6046daae07952a727de844860e08",
         intel: "7f81178be0b5d6f84ee18968da0b183292831a92c6719726786c8f07d9f9c645"

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
    next if core == "84847138c0de67149601aaa860af7ac8e2e64534"

    raise Cask::CaskError, "openms4-proteomics-lfq #{version.csv.first} was built against openms4-core 84847138c0de, " \
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
