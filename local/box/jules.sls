include:
  - box.base

python2:
  pkg.installed

ruby:
  pkg.installed

redis:
  pkg.installed

bundler:
  gem.installed:
    - runas: root
