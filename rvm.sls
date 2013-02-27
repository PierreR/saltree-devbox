# Create a specific user to install rubies and gems
rvm:
  group:
    - present
  user.present:
    - gid: rvm
    - require:
      - group: rvm