{ lib
, acme
, aiohttp
, asynctest
, atomicwrites
, attrs
, buildPythonPackage
, fetchFromGitHub
, pycognito
, pytest-aiohttp
, pytestCheckHook
, snitun
, warrant
}:

buildPythonPackage rec {
  pname = "hass-nabucasa";
  version = "0.50.0";

  src = fetchFromGitHub {
    owner = "nabucasa";
    repo = pname;
    rev = version;
    sha256 = "sha256-0E8eiHzqbxHbtAd97MbvFMRDWTu25E9x/44oNGC4mUM=";
  };

  propagatedBuildInputs = [
    acme
    aiohttp
    atomicwrites
    attrs
    pycognito
    snitun
    warrant
  ];

  checkInputs = [
    asynctest
    pytest-aiohttp
    pytestCheckHook
  ];

  postPatch = ''
    sed -i 's/"acme.*"/"acme"/' setup.py
    substituteInPlace setup.py \
      --replace "snitun==" "snitun>="
  '';

  pythonImportsCheck = [ "hass_nabucasa" ];

  meta = with lib; {
    homepage = "https://github.com/NabuCasa/hass-nabucasa";
    description = "Python module for the Home Assistant cloud integration";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ Scriptkiddi ];
  };
}
