lab_user:
  user.present:
    - shell: /bin/bash
    - name: git
    - fullname: GitLab

ruby-1.9.3:
  rvm.installed:
    - runas: git
    - require:
      - user: lab_user

/home/git/.bash.env:
  file.managed:
    - source: salt://gitlab/bash.env
    - user: git
    - order: 1
    - require:
      - user: lab_user

bundler:
  gem.installed:
    - runas: git
    - require:
      - rvm: ruby-1.9.3

charlock_holmes:
  gem.installed:
    - version: 0.6.9
    - runas: git

lab_shell_clone:
  git.latest:
    - name: https://github.com/gitlabhq/gitlab-shell.git
    - target: /home/git/gitlab-shell
    - runas: git
    - require:
      - user: lab_user

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
      - user: lab_user

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
      - user: lab_user

/home/git/gitlab/tmp/pids:
  file.directory:
    - user: git
    - makedirs: True
    - require:
      - user: lab_user

cp unicorn.rb.example unicorn.rb:
  cmd.run:
    - user: git
    - cwd: /home/git/gitlab/config
    - require:
      - user: lab_user

cp database.yml.postgresql database.mysql:
  cmd.run:
    - user: git
    - cwd: /home/git/gitlab/config
    - require:
      - user: lab_user

bundle install --deployment --without development test postgres:
  cmd.run:
    - user: git
    - cwd: /home/git/gitlab
    - require:
      - rvm: ruby-1.9.3
