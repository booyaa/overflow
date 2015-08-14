# useful domino ldap queries

tested oracle and notes/domino installs

````sh
ldapsearch -h dominoserver "objectClass=*" # everything
ldapsearch -h dominoserver -b "OU1=HR,OU2=London,O=ACME" "objectClass=dominoPerson" cn mail # show common name and email addres for people in /HR/London/ACME 
ldapsearch -h dominoserver member="CN=Jerry Sennfield,OU=Foo,O=BAR" dominoAccessGroup # show all groups where Jerry is a member of
```

further reading:
- (http://www-01.ibm.com/support/docview.wss?uid=swg27002627)[http://www-01.ibm.com/support/docview.wss?uid=swg27002627]
- (http://www-01.ibm.com/support/docview.wss?uid=swg21270777)[http://www-01.ibm.com/support/docview.wss?uid=swg21270777]
- (http://stealthpuppy.com/quering-domino-via-ldap-with-vbscript/)[http://stealthpuppy.com/quering-domino-via-ldap-with-vbscript/]
- (http://www-12.lotus.com/ldd/doc/domino_notes/rnext/help6_admin.nsf/89d3962efd85426f85256b870069c0aa/b48d6d832ba0068985256c1d00393dd9)[http://www-12.lotus.com/ldd/doc/domino_notes/rnext/help6_admin.nsf/89d3962efd85426f85256b870069c0aa/b48d6d832ba0068985256c1d00393dd9]
- (http://www-12.lotus.com/ldd/doc/domino_notes/rnext/help6_admin.nsf/f4b82fbb75e942a6852566ac0037f284/032acbcede1f466785256c1d00393d89?OpenDocument)[http://www-12.lotus.com/ldd/doc/domino_notes/rnext/help6_admin.nsf/f4b82fbb75e942a6852566ac0037f284/032acbcede1f466785256c1d00393d89?OpenDocument]
- (http://www-12.lotus.com/ldd/doc/domino_notes/rnext/help6_admin.nsf/f4b82fbb75e942a6852566ac0037f284/8fa98f5f52c4277085256c1d00393d4c?OpenDocument)[http://www-12.lotus.com/ldd/doc/domino_notes/rnext/help6_admin.nsf/f4b82fbb75e942a6852566ac0037f284/8fa98f5f52c4277085256c1d00393d4c?OpenDocument]
- (http://stackoverflow.com/questions/13414958/query-ad-using-lotusscript-lastlogon-value-empty)[http://stackoverflow.com/questions/13414958/query-ad-using-lotusscript-lastlogon-value-empty]
