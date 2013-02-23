# Install common packages
install_common_pkg:
  pkg.installed:
    - pkgs:
        - ack
        - aspell-en
        - aspell-fr
        - feh
        - ghc
        - git
        - gnome-terminal
        - htop
        - net-tools
        - spectrwm
        - sudo
        - ttf-bitstream-vera
        - vim
        - xmobar
        - xorg-xinit
        - xorg-xsetroot
        - xorg-server
        - zsh
# virtualbox-guest-utils comes 'builtin' with the base box
vboxservice:
  service:
    - enabled
  service:
    - running
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
    - password: $1$URNNwhJc$XEFruDlNvM3DIIoeXc92H/
    - shell: /bin/zsh
    - groups:
      - adm
      - vboxsf
# Configure the default vagrant user
/home/vagrant:
  file.recurse:
    - clean: False
    - user: vagrant
    - group: vagrant
    - source: salt://home
    - require:
      - user: vagrant
