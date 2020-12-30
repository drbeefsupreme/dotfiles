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
          url = https://github.com/nix-community/emacs-overlay/archive/c052c8b1a02d2645abc1bad78ea391a9a2d1a43d.tar.gz;
          sha256 = "0hgp31bz5qfzwnc85dyzidbmwc5xh4nw2nhd9619wydnjaw3yi33";
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
