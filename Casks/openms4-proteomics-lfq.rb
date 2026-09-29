cask "openms4-proteomics-lfq" do
  arch arm: "arm64", intel: "x64"

  version "1.0.0-ci.7,ba76073b658b"
  sha256 arm:   "533e7664e7870feac5ebbd41ad81269516224c1fd54660c3e85add5f29f98439",
         intel: "79be5a32edaa20104ae96cc279d994035fb22bae50cc7ba372a444722b95a75b"

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
    next if core == "83ce20da78337b0b329f5c634e52226585e4788d"

    raise Cask::CaskError, "openms4-proteomics-lfq #{version.csv.first} was built against openms4-core 83ce20da7833, " \
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
