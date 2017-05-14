---
layout: post
title:  "Pluggable Authentication With PAM"
date:   2017-05-14 10:58:14 -0500
tags: 
- security
- programming
---

Authentication and authorization is one of foundational aspects of any security system.
However writing an authentication and authorization system can be anything but:
There are complex, ever-changing requirements, not to mention differences for differing interfaces it can quickly become daunting.
However, there already exists a system on Linux and Unix that allows for dynamic and complex authentication: PAM.

## PAM Modules and Authentication Types

Fundamentally, PAM is a collection of modules that provide several methods.
These methods provide: authentication (auth: `pam_authenticate`), account management (account `pam_acct_mgmt`), 
session management (session `pam_open_session`/ `pam_close_session`), and password/token management (password `pam_chauthtok`).
For each service the administrator provides a "chain" of modules that will be used for each method.
The admin can specify if a module is required (must succeed for the chain to succeed), sufficient (alone is enough to succeed), or optional (must be run but need not succeed).

There are already PAM authentication modules for a variety of services including:

+	Traditional UNIX `passwd` 
+	Biometrics such as fingerprint readers
+	Time based passwords  such as Google Authenticator
+	Enterprise authentication systems such as LDAP or Kerberos
+	SQL/NoSQL databases

The session modules allow developers to preform actions when a users opens a session on their service.
Some examples include:

+	mount the users home directory
+	check if the user has mail
+	print a message of the day

Password modules allow the user to update their login credentials and are generally paired with an authentication module.
Finally, account modules determine if a user is authorized to view specific information.
Some existing modules include:

+	Time of day restrictions
+	location restrictions


Additionally developers can easily write their own modules if the needed modules do not yet exist.

## PAM with Different Services

But the user must be thinking, what if my application involves multiple kinds of information with differing requirements.
The command to start a PAM connection takes a service identifier as an argument.
PAM uses this information to query the file system for a configuration file that specifies the chain to be used for this service.
Additionally PAM provides a set of inheritance like facilities to allow applications to inherit login permissions from existing applications/configurations. 

## What about non-terminal applications?

You may be thinking that this sounds great, but doesn't account for graphical or web applications.
Well the PAM authors thought of that too.
All communication with the user is done via a communication callback function.
If you are using a graphical application, use a call back that presents message boxes (or similar) to the user.
If you are using a web application, use a callback that returns a web form to the user.
It is a surprisingly robust tool.

Hope this excites you to read more.  Happy Programming!
