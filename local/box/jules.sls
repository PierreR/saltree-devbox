include:
  - box.base

python2:
  pkg.installed

ruby:
  pkg.installed

brew:
  gem.installed:
    - runas: root

user_git:
  user.present:
    - name: git
    - shell: /bin/nologin
    - home: /home/git
    - fullname: GitLab

gitlab_clone:
  git.latest:
    - name: https://github.com/gitlabhq/gitlab-shell.git
    - target: /home/git/gitlab-shell
    - require: user_git


cmd.run:
  - name: bin/install
  - require: gitlab_clone 
  - cwd: /home/git/gitlab-shell 
  - user: git
  

cmd.run:
  - name: cp config.yml.example config.yml
  - require: gitlab_clone
  - cwd: /home/git/gitlab-shell
  - user: git
