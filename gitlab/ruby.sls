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
ruby-1.9.3:
  rvm.installed:
    - default: True
    - runas: rvm
    - require:
      - user: rvm

# Install gems with the git user (it should automatically use rvm under the carpet)
charlock_holmes:
  gem.installed:
    - ruby: ruby-1.9.3
    - version: "0.6.9"
    - runas: rvm
    - require:
      - user: rvm

bundler:
  gem.installed:
    - ruby: ruby-1.9.3
    - runas: rvm
    - require:
      - user: rvm
