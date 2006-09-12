From: Dan Smith <danms@us.ibm.com>
Subject: Re: dm-userspace (no in-kernel cache version)
Date: Mon, 11 Sep 2006 17:39:25 -0700
Message-ID: <m3zmd5rk8y.fsf@guaranine.beaverton.ibm.com>
References: <20060912080748X.fujita.tomonori@lab.ntt.co.jp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2132186114=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20060912080748X.fujita.tomonori@lab.ntt.co.jp> (FUJITA
	Tomonori's message of "Tue, 12 Sep 2006 08:07:48 +0900")
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

--===============2132186114==
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"

--=-=-=
Content-Transfer-Encoding: quoted-printable

FT> As explained, this removes rmap (in-kernel cache) and use mmaped
FT> buffer instead of read/write system calls for user/kernel
FT> communication.

Ok, I'll start looking over your changes tomorrow and will make an
attempt at an apples-to-apples comparison with the map cache
approach.=20

Can you post your userspace code here too?

I look forward to the results... Thanks for posting!

=2D-=20
Dan Smith
IBM Linux Technology Center
Open Hypervisor Team
email: danms@us.ibm.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2.2 (GNU/Linux)

iD8DBQFFBgHEwtEf7b4GJVQRAjSUAJ0Y9dH0xoPMAbELYiqkMJFYX0UB7wCfe8o3
xzOzSm9nUMh9K6IWbip1HLw=
=630+
-----END PGP SIGNATURE-----
--=-=-=--


--===============2132186114==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============2132186114==--
