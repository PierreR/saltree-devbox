# Install common packages
install_common_pkg:
  pkg.installed:
    - names:
        - vim
        - sudo
        - xorg-server
        - xorg-xinit
        - ghc
        - zsh
        - xmonad-contrib
# Sync time with NTP
ntp:
  pkg:
    - installed
  service.running:
    - name: ntpd
# One default user
vagrant:
  group:
    - present
  user.present:
    - gid_from_name: True
    - password: vagrant
    - shell: /bin/zsh
    - groups:
      - adm
# Configure the default vagrant user
/home/vagrant:
  file.recurse:
    - clean: True
    - user: vagrant
    - group: vagrant
    - source: salt://home
    - require:
      -group : vagrant
