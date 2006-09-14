From: Dan Smith <danms@us.ibm.com>
Subject: Re: dm-userspace (no in-kernel cache version)
Date: Thu, 14 Sep 2006 08:59:15 -0700
Message-ID: <m3y7smmobw.fsf@guaranine.beaverton.ibm.com>
References: <20060912080748X.fujita.tomonori@lab.ntt.co.jp>
	<m3lkoopxf9.fsf@guaranine.beaverton.ibm.com>
	<20060915004807D.fujita.tomonori@lab.ntt.co.jp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0209309121=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20060915004807D.fujita.tomonori@lab.ntt.co.jp> (FUJITA
	Tomonori's message of "Fri, 15 Sep 2006 00:48:07 +0900")
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

--===============0209309121==
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"

--=-=-=
Content-Transfer-Encoding: quoted-printable

FT> Have you tried SCHED_FIFO?

Not yet, but that is a good suggestion.

FT> By the way, can you upload or post the latest kernel and
FT> user-space code?

Right now I am working on a version that still uses read()/write(),
but that does not use a remap cache (in a way very similar to what you
posted).  When I get it close to stable, I'll post it here for
comments.

After reviewing the ringbuffer code more, I'm not sure that it really
buys you any additional performance (other than 1/3 less syscalls).
The amount of memory that is copied around seems to be about the
same.  Either way, I'll revisit this after I get my current version
stable again.

=2D-=20
Dan Smith
IBM Linux Technology Center
Open Hypervisor Team
email: danms@us.ibm.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2.2 (GNU/Linux)

iD8DBQFFCXxTwtEf7b4GJVQRAnDwAJ9NXEHQY7exlISVXtwADXXWMqV7wgCfUbNg
VtEAtLjaeUrOFcBrHKO81SY=
=Xi5b
-----END PGP SIGNATURE-----
--=-=-=--


--===============0209309121==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0209309121==--
