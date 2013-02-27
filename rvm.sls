# Create a specific user to install rubies and gems
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

