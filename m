From: Dan Smith <danms@us.ibm.com>
Subject: Re: dm-userspace (no in-kernel cache version)
Date: Tue, 12 Sep 2006 09:31:23 -0700
Message-ID: <m3odtlqc6c.fsf@guaranine.beaverton.ibm.com>
References: <20060912080748X.fujita.tomonori@lab.ntt.co.jp>
	<m3zmd5rk8y.fsf@guaranine.beaverton.ibm.com>
	<20060912095041U.fujita.tomonori@lab.ntt.co.jp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0983592397=="
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

--===============0983592397==
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"

--=-=-=
Content-Transfer-Encoding: quoted-printable

FT> I've attached a modified version of your example program in
FT> libdmu.

What kind of machine are you testing this on?

On an x86_64 box, the kernel and userspace do not seem to communicate
at all (userspace reports invalid event types).

On an i386 box, the communication seems to work, but if I mkfs the
device, then try to mount it, it reports that the superblock is gone.
An fsck finds a backup superblock, but then something hangs and it
never completes.

Both machines are SMP.

Thoughts?

=2D-=20
Dan Smith
IBM Linux Technology Center
Open Hypervisor Team
email: danms@us.ibm.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2.2 (GNU/Linux)

iD8DBQFFBuDgwtEf7b4GJVQRAtWNAJwNR+lrDN7DtgJi8AAVzlruma+VswCeKYSm
PrhxGbfc4EuMBR3nliqAIRQ=
=tRzo
-----END PGP SIGNATURE-----
--=-=-=--


--===============0983592397==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0983592397==--
