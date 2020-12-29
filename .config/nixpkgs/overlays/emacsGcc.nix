self: super:
let
  libPath = with super; lib.concatStringsSep ":" [
    "${lib.getLib libgccjit}/lib/gcc/${stdenv.targetPlatform.config}/$libgccjit.version}"
    "${lib.getLib stdenv.cc.cc}/lib"
    "${lib.getLib stdenv.glibc}/lib"
  ];

  emacs-overlay =
    let
      src = builtins.fetchTarball
        {
          url = https://github.com/nix-community/emacs-overlay/commit/c052c8b1a02d2645abc1bad78ea391a9a2d1a43d;
          sha256 = "0r78q5cqd528gjrppi5hp3v620v6lrr20xxd9kxcnkmxvn8wf2ad";
        };
    in import src self super;
in {

  emacsGccWrapped = super.symlinkJoin {
    name = "emacsGccWrapped";
    paths = [ emacs-overlay.emacsGcc ];
    buildInputs = [ super.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/emacs \
      --set LIBRARY_PATH ${libPath}
    '';
    meta.platforms = super.stdenv.lib.platforms.linux;
    passthru.nativeComp = true;
    src = emacs-overlay.emacsGcc.src;
  };
}  // emacs-overlay
