From: Dan Smith <danms@us.ibm.com>
Subject: Re: dm-userspace (no in-kernel cache version)
Date: Wed, 13 Sep 2006 06:39:25 -0700
Message-ID: <m3d59zq41e.fsf@guaranine.beaverton.ibm.com>
References: <m3lkoopxf9.fsf@guaranine.beaverton.ibm.com>
	<200609130201.k8D21V3e014353@r-dd.iij4u.or.jp>
	<m3hczcpeyd.fsf@guaranine.beaverton.ibm.com>
	<20060913140454U.fujita.tomonori@lab.ntt.co.jp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1360436064=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20060913140454U.fujita.tomonori@lab.ntt.co.jp> (FUJITA
	Tomonori's message of "Wed, 13 Sep 2006 14:04:54 +0900")
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

--===============1360436064==
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"

--=-=-=
Content-Transfer-Encoding: quoted-printable

FT> I'm not sure how this works. Have you explained the details of
FT> this feature in the earlier thread?

For example, in our CoW case:

A write is made to a previously unremapped block.  We queue that block
and let userspace make a mapping.  Then, we allow the write to happen,
but intercept the completion (endio) and notify userspace that it has
completed.  Then, userspace flushes its metadata to disk and notifies
the kernel to allow the endio to complete.  Without this, a crash
could result in an inconsistent CoW device.  (Note this only needs to
happen on the _initial_ write to a block)

FT> I see. I don't think that you need to implement it now (simple
FT> code is always better for mainline inclusion), however, it would
FT> be nice to have dmu_event structure for this.

Well, it's crucial for our CoW work, so unless Alasdair would prefer
me to leave it out in the initial upstream push, I would like to
include it.  It was already implemented and working in my original
version.

=2D-=20
Dan Smith
IBM Linux Technology Center
Open Hypervisor Team
email: danms@us.ibm.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2.2 (GNU/Linux)

iD8DBQFFCAoSwtEf7b4GJVQRAj+FAJ4tWJbwPQcllrZQ9IKfTwV7hI1lUgCePAyJ
89Ba5XiiDB7uqSrvvVRMS+Q=
=qDqQ
-----END PGP SIGNATURE-----
--=-=-=--


--===============1360436064==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1360436064==--
