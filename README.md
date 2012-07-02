About
=====

*what?*: A script to try to battle linkrot/memory holes/disappearing internet sources

*why?*: Research is (in part) about credible sources. Today you might find a certain piece of
      information only on the internet and not on dead tree anymore. Think for example about
      a blogpost when you are a social scientist. Are there any good dead tree data sources
      about current events? If so, are they enough? Many fear using the internet since it is a
      pretty volatile medium. Having a book means having the same unchanged source to work
      with, almost independently of time and place. That is what researchers want.
      This script is an attempt to make saving webpages more credible by throwing in the magic
      of checksums. This way a researcher can always present a source as s/he saw it, so
      other can draw their own conclusions.

*how?*:

- get current snapshot
- archive material
- provide some context information
- provide checksums for tamper resistance

*license*: [WTFPL v2](http://sam.zoy.org/wtfpl/) (unless noted otherwise)

*dependencies*:
- [Xvfb](http://www.x.org/)
- [GNU core utilities](http://www.gnu.org/software/coreutils/)
- [AdamN/python-webkit2png](https://github.com/AdamN/python-webkit2png)
- [GnuPrivacyGuard](http://www.gnupg.org/)
- [md5deep](http://md5deep.sourceforge.net/)


References
==========

General
-------
- [The GNU Privacy Handbook](http://www.gnupg.org/gph/en/manual.html)
- [GnuPG manpage](http://www.gnupg.org/gph/de/manual/r1023.html)
- [Gnu Privacy Guard (GnuPG) Mini Howto (English)](http://www.dewinter.com/gnupg_howto/english/GPGMiniHowto.html)
- [Henk Penning's Key Signing HOWTO](https://people.apache.org/~henkp/sig/pgp-key-signing.txt)
- [The Keysigning Party HOWTO](http://www.cryptnet.net/fdp/crypto/keysigning_party/en/keysigning_party.html)
- [Signatures with PGP](http://www.pgpi.org/doc/pgpintro/#p12)

Cryptography
------------
- [US-Cert Vulnerability Note VU#836068](http://www.kb.cert.org/vuls/id/836068)
- [Tao Xie and Dengguo Feng (30 May 2009). How To Find Weak Input Differences For MD5 Collision Attacks](http://eprint.iacr.org/2009/223.pdf)
- [Schneier on Security: More MD5 Collisions](http://www.schneier.com/blog/archives/2005/06/more_md5_collis.html)
- [Jian Guo, Krystian Matusiewicz (2008-11-25). Preimages for Step-Reduced SHA-2](http://eprint.iacr.org/2009/477.pdf)
- [Tiger: A Fast New Hash Function](http://www.cs.technion.ac.il/~biham/Reports/Tiger/tiger/tiger.html)
- [John Kelsey and Stefan Lucks, Collisions and Near-Collisions for Reduced-Round Tiger](http://th.informatik.uni-mannheim.de/People/Lucks/papers/Tiger_FSE_v10.pdf)