include:
  - gitlab.ruby

redis:
  pkg.installed

git:
  group:
    - present
  user.present:
    - fullname: GitLab
    - gid: git
    - require:
      - group: git
  file.managed:
    - name: /home/git/.bash_rc
    - source: salt://gitlab/bash_rc
    - user: git


gitlab_shellclone:
  git.latest:
    - name: https://github.com/gitlabhq/gitlab-shell.git
    - target: /home/git/gitlab-shell
    - runas: git
    - require:
      - user: git

gitlab_shellconfig:
  cmd.run:
    - name: cp config.yml.example config.yml
    - cwd: /home/git/gitlab-shell
    - user: git
    - require:
      - git: gitlab_shellclone

lab_shell_install:
  cmd.run:
    - name: bin/install
    - cwd: /home/git/gitlab-shell
    - user: git
    - require:
      - cmd: gitlab_shellconfig

gitlab_clone:
  git.latest:
    - name: https://github.com/gitlabhq/gitlabhq.git
    - target: /home/git/gitlab
    # does not exist yet:- rev: 5-0-stable
    - runas: git
    - require:
      - user: git

/home/git/gitlab/config/gitlab.yml:
  file.managed:
    - source: salt://gitlab/gitlab.yml
    - user: git
    - require:
      - git: gitlab_clone

/home/git/gitlab-satellites:
  file.directory:
    - user: git
    - group: git
    - makedirs: True
    - require:
      - user: git

gitlab_config:
  file.directory:
    - name: /home/git/gitlab/tmp/pids
    - user: git
    - makedirs: True
    - require:
      - git: gitlab_clone
  cmd.run:
    - name: cp unicorn.rb.example unicorn.rb
    - user: git
    - cwd: /home/git/gitlab/config
    - require:
      - git: gitlab_clone
  cmd.run:
    - name: cp database.yml.postgresql database.postgres
    - user: git
    - cwd: /home/git/gitlab/config
    - require:
      - git: gitlab_clone

bundle install --deployment --without development test postgres:
  cmd.run:
    - user: git
    - cwd: /home/git/gitlab
    - require:
      - cmd: gitlab_config
      - gem: bundler
      - gem: charlock_holmes
