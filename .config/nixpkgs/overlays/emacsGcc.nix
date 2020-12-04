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
          url = https://github.com/nix-community/emacs-overlay/archive/4d7fdb786637213e2ff45bb868e27eb21a234f06.tar.gz;
          sha256 = "0m92fdrbz8x275y0h8pgy3g80rqgm66p9r253bxwhk2vbkmg6j4h";
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
