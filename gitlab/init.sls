git:
  user.present:
    - shell: /bin/bash
    - fullname: GitLab
    - home: /home/git
    - require:
      - user: rvm
      - rvm: ruby-1.9.3

# Responsible for installing Ruby (not gems)
rvm:
  group:
    - present
  user.present:
    - gid: rvm
    - home: /home/rvm
    - require:
      - group: rvm

# Install Ruby with the rvm user
ruby-1.9.3:
  rvm.installed:
    - order: 1
    - default: True
    - runas: rvm
    - require:
      - user: rvm

# Install gems with the git user (it should automatically use rvm under the carpet)
charlock_holmes:
  gem.install:
    - runas: git
    - require:
      - user: git

bundler:
  gem.install:
    - version: 0.6.9
    - runas: git
    - require:
      - user: git

bundle install --deployment --without development test postgres:
  cmd.run:
    - user: git
    - cwd: /home/git/gitlab
    - require:
      - gem: bundler

/home/git/.bash.env:
  file.managed:
    - source: salt://gitlab/bash.env
    - user: git

lab_shell_clone:
  git.latest:
    - name: https://github.com/gitlabhq/gitlab-shell.git
    - target: /home/git/gitlab-shell
    - runas: git
    - require:
      - user: git

lab_shell_install:
  cmd.run:
    - name: bin/install
    - cwd: /home/git/gitlab-shell
    - user: git
    - require:
      - pkg: ruby
      - gem: bundler
      - git: lab_shell_clone

lab_shell_config:
  cmd.run:
    - name: cp config.yml.example config.yml
    - cwd: /home/git/gitlab-shell
    - user: git
    - require:
      - git: lab_shell_clone

lab_clone:
  git.latest:
    - name: https://github.com/gitlabhq/gitlabhq.git
    - target: /home/git/gitlab
    - rev: 5-0-stable
    - runas: git
    - require:
      - user: git

/home/git/gitlab/config/gitlab.yml:
  file.managed:
    - source: salt://gitlab/config.yml
    - user: git
    - require:
      - git: lab_clone

/home/git/gitlab-satellites:
  file.directory:
    - user: git
    - makedirs: True
    - require:
      - user: git

/home/git/gitlab/tmp/pids:
  file.directory:
    - user: git
    - makedirs: True
    - require:
      - user: git

cp unicorn.rb.example unicorn.rb:
  cmd.run:
    - user: git
    - cwd: /home/git/gitlab/config
    - require:
      - user: git

cp database.yml.postgresql database.mysql:
  cmd.run:
    - user: git
    - cwd: /home/git/gitlab/config
    - require:
      - user: git
