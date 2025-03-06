{
  lib,
  stdenv,
  fetchFromGitHub,
  gitUpdater,
  z3_4_12,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "vampire";
  version = "4.9casc2024";

  src = fetchFromGitHub {
    owner = "vprover";
    repo = "vampire";
    rev = "v${version}";
    sha256 = "sha256-NHAlPIy33u+TRmTuFoLRlPCvi3g62ilTfJ0wleboMNU=";
  };

  buildInputs = [
    z3_4_12
    zlib
  ];

  makeFlags = [
    "vampire_z3_rel"
    "CC:=$(CC)"
    "CXX:=$(CXX)"
  ];

  postPatch = ''
    patch -p1 -i ${../avy/minisat-fenv.patch} -d Minisat || true
  '';

  enableParallelBuilding = true;

  fixupPhase = ''
    rm -rf z3
  '';

  installPhase = ''
    install -m0755 -D vampire_z3_rel* $out/bin/vampire
  '';

  passthru.updateScript = gitUpdater { rev-prefix = "v"; };

  meta = with lib; {
    homepage = "https://vprover.github.io/";
    description = "Vampire Theorem Prover";
    mainProgram = "vampire";
    platforms = platforms.unix;
    license = licenses.bsd3;
    maintainers = with maintainers; [ gebner puyral ];
  };
}
