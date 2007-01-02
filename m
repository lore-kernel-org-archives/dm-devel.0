From: Dan Smith <danms@us.ibm.com>
Subject: Re: [PATCH 1/2] dm-userspace: use ring buffer instead
	of	system call
Date: Tue, 02 Jan 2007 08:06:16 -0800
Message-ID: <m3mz51jtvr.fsf@guaranine.beaverton.ibm.com>
References: <m3lklj2u81.fsf@guaranine.beaverton.ibm.com>
	<20061208095939I.fujita.tomonori@lab.ntt.co.jp>
	<m3y7pi1fhx.fsf@guaranine.beaverton.ibm.com>
	<20061214193615W.fujita.tomonori@lab.ntt.co.jp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1366364393=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20061214193615W.fujita.tomonori@lab.ntt.co.jp> (FUJITA
	Tomonori's message of "Thu, 14 Dec 2006 19:36:15 +0900")
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

--===============1366364393==
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"

--=-=-=
Content-Transfer-Encoding: quoted-printable

FT> include/linux/dm-userspace.h is included by libdevmapper. So does
FT> it need to be released under LGPL, doesn't it?

Actually, I think that include/linux/dm-userspace.h *must* be GPL'd to
be included in the kernel.  Am I wrong?

I imagine that since libdevmapper is LGPL, dm-userspace.h will need to
be replicated in the libdevmapper tree.  Maybe someone with more
experience in this area could chime in.

=2D-=20
Dan Smith
IBM Linux Technology Center
Open Hypervisor Team
email: danms@us.ibm.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQFFmoL9wtEf7b4GJVQRAskTAJ9bEtPGivjjA14ioiG/l4VECK7/QwCfQaAK
GEf2gmwTEqelu5aJ5zV5vhQ=
=QjjT
-----END PGP SIGNATURE-----
--=-=-=--


--===============1366364393==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1366364393==--
