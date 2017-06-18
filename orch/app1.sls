
# Orchestration file to push update from github app1

"Refresh files on master server":
  salt.runner:
    - name: fileserver.update

"Deploy updated files files":
  salt.state:
    - tgt: 'app:app1'
    - tgt_type: grain
    - sls:
      - website.app1