include:
  - rvm

gitlab:
  rvm.gemset_present:
    - ruby: ruby-1.9.3
    - runas: rvm
    - require:
      - rvm: ruby-1.9.3

# Install gems with the rvm ruby version specified
charlock_holmes:
  gem.installed:
    - ruby: ruby-1.9.3@gitlab
    - version: "0.6.9"
    - runas: rvm
    - require:
      - rvm: gitlab


