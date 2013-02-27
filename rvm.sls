# Create a specific user to install rubies and gems
rvm:
  group:
    - present
  user.present:
    - gid: rvm
    - require:
      - group: rvm

# Install Ruby with the rvm user
ruby-1.9.3:
  rvm.installed:
    - default: True
    - runas: rvm
    - require:
      - user: rvm

global:
  rvm.gemset_present:
    - ruby: ruby-1.9.3
    - runas: rvm
    - require:
      - rvm: ruby-1.9.3

bundler:
  gem.installed:
    - ruby: ruby-1.9.3@global
    - runas: rvm
    - require:
      - rvm: gitlab_ruby