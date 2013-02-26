charlock_holmes:
  gem.installed:
    - version: 0.6.9
    - runas: root

lab_user:
  user.present:
    - name: git
    - shell: /sbin/nologin
    - fullname: GitLab

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

mkdir /home/git/gitlab-satellites:
  cmd.run:
    - user: git
    - require:
      - git: lab_user

mkdir tmp/pids/ :
  cmd.run:
    - user: git
    - require:
      - git: lab_user

cp unicorn.rb.example unicorn.rb:
  cmd.run:
    - user: git
    - cwd: /home/git/gitlab/config
    - require:
      - git: lab_user

cp database.yml.postgresql database.mysql:
  cmd.run:
    - user: git
    - cwd: /home/git/gitlab/config
    - require:
      - git: lab_user

bundle install --deployment --without development test postgres:
  cmd.run:
    - user: git
    - cwd: /home/git/gitlab
    - require:
      - git: lab_user