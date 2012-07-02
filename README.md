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
- [Selenium](http://seleniumhq.org/) (via [pip](pypi.python.org/pypi/pip/))
- [GnuPrivacyGuard](http://www.gnupg.org/) ([GnuPG manpage](http://www.gnupg.org/gph/de/manual/r1023.html))
- [md5deep](http://md5deep.sourceforge.net/) ([manpage](http://md5deep.sourceforge.net/md5deep.html))


Thoughts
========

Design
------
Different hashing algorithms are used to spread the risk of collision/preimage attacks. MD5 is considered
harmful but still adds a layer of complexity for forging sources without changing their hash values. SHA1
and SHA2 getting scratched, but aren't broken yet (as of June 2012). The use of free/libre open source
software is mandatory to have at least some trust in any result provided/derived from this work. The use
of public key encryption is needed to provide opportunities for checks without compromising the signing
process.

Attacks
-------
Relying on keys with a short (thus limited) lifetime is foolish. First, GnuPG depends on the system time
to enforce expirations. Anyone with the ability to manipulate the clock is able to forge signatures after
their intended lifetime.



References
==========

General
-------
- [The GNU Privacy Handbook](http://www.gnupg.org/gph/en/manual.html)
- [Gnu Privacy Guard (GnuPG) Mini Howto (English)](http://www.dewinter.com/gnupg_howto/english/GPGMiniHowto.html)
- [Henk Penning's Key Signing HOWTO](https://people.apache.org/~henkp/sig/pgp-key-signing.txt)
- [The Keysigning Party HOWTO](http://www.cryptnet.net/fdp/crypto/keysigning_party/en/keysigning_party.html)
- [Signatures with PGP](http://www.pgpi.org/doc/pgpintro/#p12)

Cryptography
------------
- [US-Cert Vulnerability Note VU#836068](http://www.kb.cert.org/vuls/id/836068)
- [RFC 1321 - The MD5 Message-Digest Algorithm](http://tools.ietf.org/html/rfc1321)
- [Tao Xie and Dengguo Feng (30 May 2009). How To Find Weak Input Differences For MD5 Collision Attacks](http://eprint.iacr.org/2009/223.pdf)
- [Schneier on Security: More MD5 Collisions](http://www.schneier.com/blog/archives/2005/06/more_md5_collis.html)
- [Jian Guo, Krystian Matusiewicz (2008-11-25). Preimages for Step-Reduced SHA-2](http://eprint.iacr.org/2009/477.pdf)
- [Tiger: A Fast New Hash Function](http://www.cs.technion.ac.il/~biham/Reports/Tiger/tiger/tiger.html)
- [John Kelsey and Stefan Lucks, Collisions and Near-Collisions for Reduced-Round Tiger](http://th.informatik.uni-mannheim.de/People/Lucks/papers/Tiger_FSE_v10.pdf)
- [Whirlpool homepage](http://www.larc.usp.br/~pbarreto/WhirlpoolPage.html)
- [Florian Mendel1, Christian Rechberger, Martin Schläffer, Søren S. Thomsen (2009-02-24). "Cryptanalysis of Reduced Whirlpool and Grøstl"](https://www.cosic.esat.kuleuven.be/fse2009/slides/2402_1150_Schlaeffer.pdf)
- [RIPEMD160 homepage](http://www.esat.kuleuven.ac.be/~bosselae/ripemd160.html)
- [Xiaoyun Wang; Dengguo Feng; Xuejia Lai; Hongbo Yu (2004-08-17). "Collisions for Hash Functions MD4, MD5, HAVAL-128 and RIPEMD"](http://eprint.iacr.org/2004/199.pdf)