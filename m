From: Miklos Vajna <vmiklos@frugalware.org>
Subject: Improving dm-mirror as a final year project
Date: Tue, 25 Jan 2011 16:53:43 +0100
Message-ID: <20110125155342.GG26864@genesis.frugalware.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============5335719872117699520=="
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids


--===============5335719872117699520==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="peRj85VDUce1fu/0"
Content-Disposition: inline


--peRj85VDUce1fu/0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

I got the possibility to work on dm-mirror as a final year project at
ULX, the Hungarian distributor of Red Hat.

Get my feet wet, I created two small patches:

1) dm-mirror: allow setting ios count to 0

Always read from the default_mirror in that case.

2) dm-mirror: allow setting the default mirror

These can help in case one data leg of a mirror is a remote (iSCSI) one,
so the default RR aproach is not optimal for reading. (One may set the
ios count to 0, set the default mirror to the local one, and that will
cause a read speedup.)

I do not yet have the right to send those patches (I do this in
university time, so the copyright is not mine), but I hope to be able to
do so - to get them reviewed.

So the final year project's aim is to improve "the fault tolerance and
performance of dm-mirror". We (I and my mentors) have two ideas in that
area, not counting the above patches:

1) Make the currently hardwired RR read approach modular, that would
allow implementing for example a weighted RR algorithm. (In case one
disk is two times faster than the other one, etc.)

2) From our experiments, it seems that in case the dm-mirror looses one
of its legs and there is a write to the mirror, it gets converted to a
linear volume. It would be nice (not sure how easy) to use the mirror
log to mark the dirty blocks, so that the volume would not be converted
to a linear one: once the other leg is back, it could be updated based
on the mirror log.

The question: what do you (who have much more experience with dm-mirror
than me) think - are these reasonable goals? If not, what would you
improve/change/add/remove to the above list?

Thanks,

Miklos

PS: I'm not subscribed, please keep me in CC.

--peRj85VDUce1fu/0
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk0+8gYACgkQe81tAgORUJaTIgCfct6eQRFHCPEr4WIG2nsi4GAZ
ZvsAoKVLfWoGC1tPqc472ZTTKeXM9+RK
=nQa6
-----END PGP SIGNATURE-----

--peRj85VDUce1fu/0--


--===============5335719872117699520==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============5335719872117699520==--
