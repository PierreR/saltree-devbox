labgit:
  user.present:
    - name: git
    - fullname: GitLab

labshell_clone:
  git.latest:
    - name: https://github.com/gitlabhq/gitlab-shell.git
    - target: /home/git/gitlab-shell
    - runas: git
    - require:
      - user: labgit

labshell_install:
  cmd.run:
    - name: bin/install
    - cwd: /home/git/gitlab-shell
    - user: git
    - require:
      - pkg: ruby
      - gem: bundler
      - git: labshell_clone

labshell_config:
  cmd.run:
    - name: cp config.yml.example config.yml
    - cwd: /home/git/gitlab-shell
    - user: git
    - require:
      - git: labshell_clone

lab_clone:
  git.latest:
    - name: https://github.com/gitlabhq/gitlabhq.git
    - target: /home/git/gitlab
    - runas: git
    - require:
      - user: labgit

