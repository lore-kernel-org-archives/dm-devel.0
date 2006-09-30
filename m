From: Dan Smith <danms@us.ibm.com>
Subject: Re: Thoughts on removing the remap cache
Date: Sat, 30 Sep 2006 08:44:26 -0700
Message-ID: <m3ven5z7dx.fsf@guaranine.beaverton.ibm.com>
References: <m3d59e1hj9.fsf@guaranine.beaverton.ibm.com>
	<200609300246.k8U2khwi004095@r-dd.iij4u.or.jp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1054248701=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <200609300246.k8U2khwi004095@r-dd.iij4u.or.jp> (FUJITA Tomonori's
	message of "Sat, 30 Sep 2006 11:46:38 +0900")
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
Cc: fujita.tomonori@lab.ntt.co.jp
List-Id: dm-devel.ids

--===============1054248701==
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"

--=-=-=
Content-Transfer-Encoding: quoted-printable

FT> I guess that dbench generates relatively large size I/Os than
FT> common workloads, which is more sensitive to latency.

Right, that is what I am thinking.  However, dbench inside a domU does
not perform well either.  Even running dbench inside a domU, the
batches that the userspace daemon sees are only about 10 requests,
compared to several thousand at times when running on bare metal.

FT> Seems that Xen camp is pretty happy with blktap. So dm-userspace
FT> should be ok with domU. Maybe it's time to try ring buffer stuff
FT> again. :)

You think that the ring buffer has the potential to be lower latency
due to fewer memcpy()'s right?

=2D-=20
Dan Smith
IBM Linux Technology Center
Open Hypervisor Team
email: danms@us.ibm.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2.2 (GNU/Linux)

iD8DBQFFHpDcwtEf7b4GJVQRAjESAJ46CPDC3Uv2dudqQBql1D/Onm/B1wCfZPIS
NdqOocvxp40XjRvM9b4JNFw=
=CIbk
-----END PGP SIGNATURE-----
--=-=-=--


--===============1054248701==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1054248701==--
