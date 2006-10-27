From: Dan Smith <danms@us.ibm.com>
Subject: Re: [PATCH 1/2] dm-userspace: use ring buffer instead of
	system call
Date: Fri, 27 Oct 2006 07:01:41 -0700
Message-ID: <m31wotsvqy.fsf@guaranine.beaverton.ibm.com>
References: <20061025194412J.fujita.tomonori@lab.ntt.co.jp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0614955427=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20061025194412J.fujita.tomonori@lab.ntt.co.jp> (FUJITA
	Tomonori's message of "Wed, 25 Oct 2006 19:44:12 +0900")
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

--===============0614955427==
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"

--=-=-=
Content-Transfer-Encoding: quoted-printable

FT> It's against on the top of the following patches:

Would you mind sending a patch against a vanilla tree?  I'm having a
hard time getting the patches (old and new) to apply cleanly and in
the right order.

FT> In my experiments, the ring buffer interface provides 10% better
FT> write performance with disktest benchmark, though dbench gives
FT> comparable performances (about 340 MB/s).

This is good to hear.  I am interested in testing it in some of my
real-life situations where performance is slower due to the high
latency.  This mostly affects the boot time of Xen guests.

I have added kernel caching back into my local version (which only
adds 200 lines).  It improves Xen guest boot performance
significantly, but does not affect dbench performance.  I will be
interested to see what kind of performance I can get from your
ringbuffer version, as well as possibly a combination of the two.

Thanks!

=2D-=20
Dan Smith
IBM Linux Technology Center
Open Hypervisor Team
email: danms@us.ibm.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQFFQhFKwtEf7b4GJVQRAoGjAJ0UUlNROC3jpefIkidqXLjMrcE64QCbBRBe
tBGT8LygY5iC7zMAc/ZfWMk=
=cPtU
-----END PGP SIGNATURE-----
--=-=-=--


--===============0614955427==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0614955427==--
