{ stdenv, fetchurl, lib, zlib, pcre
, memorymappingHook, memstreamHook
, tlsSupport ? true, gnutls ? null
# ^ set { tlsSupport = false; } to reduce closure size by ~= 18.6 MB
}:

assert tlsSupport -> gnutls != null;

stdenv.mkDerivation rec {
  pname = "tintin";
  version = "2.02.11";

  src = fetchurl {
    url    = "mirror://sourceforge/tintin/tintin-${version}.tar.gz";
    sha256 = "sha256-s5KJ7x4m0vW39+M/cLzYlAYMld2WwVe7l28GPFmosfU=";
  };

  nativeBuildInputs = lib.optional tlsSupport gnutls.dev;
  buildInputs = [ zlib pcre ]
    ++ lib.optionals (stdenv.system == "x86_64-darwin") [ memorymappingHook memstreamHook ]
    ++ lib.optional tlsSupport gnutls;

  preConfigure = ''
    cd src
  '';

  meta = with lib; {
    description = "A free MUD client for macOS, Linux and Windows";
    homepage    = "http://tintin.sourceforge.net";
    license     = licenses.gpl2;
    maintainers = with maintainers; [ lovek323 ];
    platforms   = platforms.unix;
  };
}
