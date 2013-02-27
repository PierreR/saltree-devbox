# Salt behaves quite badly with ruby
# Install gems with the rvm ruby version specified
charlock_holmes:
  gem.installed:
    - version: "0.6.9"
    - runas: git
    - require:
      - user: git

bundler:
  gem.installed:
    - runas: git
    - require:
      - user: git
