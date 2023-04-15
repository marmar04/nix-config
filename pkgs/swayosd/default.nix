{ lib
, rustPlatform
, fetchFromGitHub
}:
{
  # TODO: Finish this package
  # Taking a template from bat in nixpkgs
  rustPlatform.buildRustPackage rec {
  pname = "SwayOSD";
  version = "0.23.0";

  src = fetchFromGitHub {
    owner = "ErikReider";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-cGHxB3Wp8yEcJBMtSOec6l7iBsMLhUtJ7nh5fijnWZs=";
  };
  cargoHash = "sha256-wZNdYGCLKD80gV1QUTgKsFSNYkbDubknPB3e6dsyEgs=";

  meta = with lib; {
    description = "A cat(1) clone with syntax highlighting and Git integration";
    homepage = "https://github.com/sharkdp/bat";
    changelog = "https://github.com/sharkdp/bat/raw/v${version}/CHANGELOG.md";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ dywedir lilyball zowoq SuperSandro2000 ];
  };
}
