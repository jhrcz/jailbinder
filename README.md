# jailbinder

this tools prepares readonly copy of current system using only minimal
set of directories with the possibility to fake the structure and add some additional directories

in efect for chrooted user, there is only basic system and dat the user should work with

  - config filename is used as username and chroot naming base
  - only /tmp, users HOME and directories specified in P are writable

this is alternative way to http://olivier.sessink.nl/jailkit/
the main benefit why not use jailkit is to not duplicate the base system files/libraries and do not reuire updating the chroot environment

## setup chroot env
```
./jailbinder.sh deployertest.conf up
```

## unset chroot env
```
./jailbinder.sh deployertest.conf down
```

## needed sshd configuration:
```
Match user deployertest
        AuthorizedKeysFile /home/JAILED/%u/.ssh/authorized_keys
        ChrootDirectory /opt/jails/%u-root
```

## REQUIRED STEPS FOR NEW USER
  1. useradd
  2. move home to JAILED dir
  3. prepare .conf file
  4. add Match to sshd_config
  5. ./jailbinder.sh newuser.conf up
  6. test ssh login

