From: Dan Smith <danms@us.ibm.com>
Subject: Re: Sending reads/writes to a userspace program?
Date: Wed, 16 May 2007 04:46:41 -0700
Message-ID: <m3fy5xyori.fsf@guaranine.beaverton.ibm.com>
References: <a01fc5d10705160353o582e074ep428d76d2a55ff39b@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0112124928=="
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============0112124928==
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"

--=-=-=
Content-Transfer-Encoding: quoted-printable

NJ> Does dm provide any way for a custom target type to redirect a read or
NJ> write to a userspace program? Or even for it to notify the program of
NJ> the read/write and wait until it gives the goahead, somewhat like the
NJ> way page faulting works?=20

I have been working on a userspace target, which allows you to do just
what you describe.  I have an hg tree up with some userspace tools, as
well as an out-of-body version of the kernel module:

  http://static.danplanet.com/hg/dm-userspace.ring/

I also have an actual kernel tree with dm-userspace support, from
which I could generate a patch if the above does not work well for
you.

NJ> I'm wondering if it's possible to create a target type that
NJ> implements a 'remote' block device with blocks stored on something
NJ> like Amazon S3, keeping only a local cache of mapped blocks, and
NJ> fetching / writing blocks as needed.

Yep, I have done similar things with dm-userspace.

=2D-=20
Dan Smith
IBM Linux Technology Center
Open Hypervisor Team
email: danms@us.ibm.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFGSu8hwtEf7b4GJVQRAnJgAKCM1bHgMR4XPpU8Wzd+Vjtqs+fU+wCgjKaG
2BACPC4aNore4FG+pQWA7HI=
=2B1Y
-----END PGP SIGNATURE-----
--=-=-=--


--===============0112124928==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0112124928==--
