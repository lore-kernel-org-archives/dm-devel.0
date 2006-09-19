From: Dan Smith <danms@us.ibm.com>
Subject: Re: Latest dm-userspace kernel code
Date: Tue, 19 Sep 2006 06:31:11 -0700
Message-ID: <m3sliokmow.fsf@guaranine.beaverton.ibm.com>
References: <m38xkhmdkv.fsf@guaranine.beaverton.ibm.com>
	<20060919194641P.fujita.tomonori@lab.ntt.co.jp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1967974435=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20060919194641P.fujita.tomonori@lab.ntt.co.jp> (FUJITA
	Tomonori's message of "Tue, 19 Sep 2006 19:46:41 +0900")
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

--===============1967974435==
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"

--=-=-=
Content-Transfer-Encoding: quoted-printable

FT> Have you already started to write the ring buffer interface for
FT> the performance comparison?=20

I have not yet started on the ringbuffer.  I've still got a few issues
I'm working out with my userspace code, as well as some further
changes I want to make to the kernel module (like better separating
the chardev code from the target itself, like you did).

FT> Or would you like me to implement it?

If you want to start on it, that would be great!

=2D-=20
Dan Smith
IBM Linux Technology Center
Open Hypervisor Team
email: danms@us.ibm.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2.2 (GNU/Linux)

iD8DBQFFD/EmwtEf7b4GJVQRAr4aAJ9RYbpjv3t+V9AMTYmcrIvtPzZpEwCffobW
uIwc/yMRL9hj/G/0DOSqRtg=
=nszc
-----END PGP SIGNATURE-----
--=-=-=--


--===============1967974435==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1967974435==--
