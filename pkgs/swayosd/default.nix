{ lib
, rustPlatform
, fetchFromGitHub
, ...
}:
{
  # TODO: Finish this package
  # Taking a template from bat in nixpkgs
  rustPlatform.buildRustPackage = rec {
    pname = "SwayOSD";
    version = "8ef76c1";

    src = fetchFromGitHub {
      owner = "ErikReider";
      repo = pname;
      rev = "v${version}";
      hash = lib.fakeSha256;
    };
    cargoHash = "sha256-wZNdYGCLKD80gV1QUTgKsFSNYkbDubknPB3e6dsyEgs=";

    meta = with lib; {
      description = "A OSD window for common actions like volume and capslock";
      homepage = "https://github.com/sharkdp/bat";
      changelog = "https://github.com/sharkdp/bat/raw/v${version}/CHANGELOG.md";
      license = with licenses; [ asl20 /* or */ mit ];
      maintainers = with maintainers; [ dywedir lilyball zowoq SuperSandro2000 ];
    };
  };
}
