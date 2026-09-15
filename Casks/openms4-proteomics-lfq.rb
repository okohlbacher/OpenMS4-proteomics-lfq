cask "openms4-proteomics-lfq" do
  arch arm: "arm64", intel: "x64"

  version "1.0.0-ci.3,953ccc18ab40"
  sha256 arm:   "b0432720671d912d399ecf00b3a99d5df39895c480bca02e5814417535ea977c",
         intel: "12d2e704633193bc64fd5203a1ee400bdb02dfd63c72d9e92a4a8808fba78616"

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
    next if core == "ac41cc177023e24a8fbc711a6ce9010187c54c44"

    raise Cask::CaskError, "openms4-proteomics-lfq #{version.csv.first} was built against openms4-core ac41cc177023, " \
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
