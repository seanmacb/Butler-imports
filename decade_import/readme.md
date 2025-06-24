# Troubleshooting help

- If you receive an error that your ssh connection was not created, run `eval $(ssh-agent -s)` and then `ssh-add ~/.ssh/NCSAKey` to restart your ssh client and add your key to the client again. Then, restart `download_fits_files.sh`

Here is the ssh config, for reference

```
Host remote2-via-jump
    HostName descmp2.cosmology.illinois.edu
    User seanmacb
    ProxyJump seanmacb@deslogin.cosmology.illinois.edu
    IdentityFile ~/.ssh/NCSAKey


Host descmp2-proxy
  HostName descmp2.cosmology.illinois.edu
  User seanmacb
  ProxyJump seanmacb@deslogin.cosmology.illinois.edu
  IdentityFile ~/.ssh/NCSAKey
  ForwardAgent yes

Host descmp2.cosmology.illinois.edu
    User seanmacb
    ProxyJump seanmacb@deslogin.cosmology.illinois.edu
    ForwardAgent yes
```

One of the host configurations is probably redundant...