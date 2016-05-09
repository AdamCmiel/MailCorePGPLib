MailCorePGPLib
==============

The encryption framework for using the [MailCore](github.com/adamcmiel/mailcore)
gmail app, which allows for publishing and fetching PGP public keys to the 
[keyserver network](mit.pgp.edu).


Features
--------

This framework allows the consumer to

- create PGP keys (using RSA 2048 bit keys)
- publish an existing PGP keypair
- download public keys from the keyserver
- store the keys in the iOS keychain
- store a list of keys in a UserDefaults


