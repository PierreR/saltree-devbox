# TODO: we still need to accept the key, remove xmonad from extra
haskell_libs:
  pkg.installed:
    - require:
      - pacman_conf
    - pkgs:
        - cabal-install
        - haskell-buildwrapper
        - haskell-haddock
        - haskell-hlint
        - haskell-quickcheck
        - haskell-network
        - haskell-parsec
        - haskell-scion-browser
        - haskell-stm
        - haskell-xmonad-contrib 
        - haskell-warp # for Hoogle: will install many deps

pacman_conf:
  file.managed:
    - name: /etc/pacman.conf
    - source: salt://root/etc/pacman-haskell.conf
    - user: root
    - group: root
    - mode: 644
