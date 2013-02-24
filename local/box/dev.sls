include:
 - box.base
 - pkg.haskell
 - pkg.extra-light

# Install Puppet circus
puppet:
  gem.installed:
    - names:
      - puppet
      - puppet-lint
    - runas: vagrant
    - require: 
      - pkg: ruby
