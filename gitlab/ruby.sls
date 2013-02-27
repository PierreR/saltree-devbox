# Rubies are installed by rvm
# Gems are installed by rvm unless you use gemset
rvm:
  group:
    - present
  user.present:
    - gid: rvm
    - require:
      - group: rvm

# Install Ruby with the rvm user
ruby:
  rvm.installed:
    - name: ruby-1.9.3
    - default: True
    - runas: rvm
    - require:
      - user: rvm

# Install gems with the rvm ruby version specified
charlock_holmes:
  gem.installed:
    - ruby: ruby-1.9.3
    - version: "0.6.9"
    - runas: rvm
    - require:
      - rvm: ruby

bundler:
  gem.installed:
    - ruby: ruby-1.9.3
    - runas: rvm
    - require:
      - rvm: ruby
