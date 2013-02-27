include:
  - rvm

# Install Ruby with the rvm user
gitlab_ruby:
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
      - rvm: gitlab_ruby

bundler:
  gem.installed:
    - ruby: ruby-1.9.3
    - runas: rvm
    - require:
      - rvm: gitlab_ruby
