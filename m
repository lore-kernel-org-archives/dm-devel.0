From: Dan Smith <danms@us.ibm.com>
Subject: Re: Latest dm-userspace kernel code
Date: Sat, 30 Sep 2006 08:48:53 -0700
Message-ID: <m3mz8hz76i.fsf@guaranine.beaverton.ibm.com>
References: <m3hcyr4sit.fsf@guaranine.beaverton.ibm.com>
	<200609300221.k8U2L7UU001919@r-dd.iij4u.or.jp>
	<m3zmciyt59.fsf@guaranine.beaverton.ibm.com>
	<200609301113.k8UBDfWS015780@r-dd.iij4u.or.jp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0965574424=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <200609301113.k8UBDfWS015780@r-dd.iij4u.or.jp> (FUJITA Tomonori's
	message of "Sat, 30 Sep 2006 20:13:35 +0900")
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

--===============0965574424==
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"

--=-=-=
Content-Transfer-Encoding: quoted-printable

FT> If you add a feature to notify I/O completion of user space (I
FT> think this feature is necessary for other reasons too), user-space
FT> programs can take care about this easily. I prefer the
FT> dm-userspace kernel module to just perform I/Os according to
FT> requests from user space.

I have thought about this approach before, and perhaps it makes sense,
as it will simplify the kernel module and move all of the CoW-like
behavior back out to userspace.

In order for this to perform well, we will need to use AIO, right?

I would be interested to hear feedback from others on this list about
this particular point.

=2D-=20
Dan Smith
IBM Linux Technology Center
Open Hypervisor Team
email: danms@us.ibm.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2.2 (GNU/Linux)

iD8DBQFFHpHlwtEf7b4GJVQRAj4GAJ9e39dxLPRcZHddGoDPKU39dOkkSACbBERw
5LnB0vVhzQpONWiJriqb25o=
=lGDF
-----END PGP SIGNATURE-----
--=-=-=--


--===============0965574424==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0965574424==--
