{
  security.pki.certificates = [
    (builtins.readFile ../../../certificates/nixcfg-ca.crt)
  ];
}
