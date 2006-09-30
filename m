From: Dan Smith <danms@us.ibm.com>
Subject: Re: Latest dm-userspace kernel code
Date: Sat, 30 Sep 2006 15:29:41 -0700
Message-ID: <m364f5yomi.fsf@guaranine.beaverton.ibm.com>
References: <m3zmciyt59.fsf@guaranine.beaverton.ibm.com>
	<200609301113.k8UBDfWS015780@r-dd.iij4u.or.jp>
	<m3mz8hz76i.fsf@guaranine.beaverton.ibm.com>
	<20061001023502S.fujita.tomonori@lab.ntt.co.jp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1698024615=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20061001023502S.fujita.tomonori@lab.ntt.co.jp> (FUJITA
	Tomonori's message of "Sun, 01 Oct 2006 02:35:02 +0900")
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

--===============1698024615==
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"

--=-=-=
Content-Transfer-Encoding: quoted-printable

FT> I think that it would be better for the kerne module to provide
FT> only generic mechanisms.

I definitely see the value in removing the copy functionality from the
kernel pieces, I just want to make sure that performance will not
suffer.=20

>> In order for this to perform well, we will need to use AIO, right?
FT> I'm not sure about this. Can you elaborate?

Well, assuming that a copy operation (and an fsync() to make sure it
is on-disk) is a non-trivial operation, it would be good to allow the
copy to happen in the background while still being able to service
other requests from the kernel.

In cowd, I need to write metadata when blocks are mapped, and fsync()
them to make sure they are on disk before I allow the IO to complete.
If I do this with a normal write()/fsync() (or open the file O_SYNC),
then cowd is blocked until the write is complete.  This means that
other requests that are in the queue, which may not require a copy,
are also blocked unnecessarily.  I assume that unless copy operations
are performed asynchronously (as they are now by letting the kernel do
it), the problem will get even worse.

=2D-=20
Dan Smith
IBM Linux Technology Center
Open Hypervisor Team
email: danms@us.ibm.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2.2 (GNU/Linux)

iD8DBQFFHu/awtEf7b4GJVQRAq9XAKCGWYKnX3wPCDqb3eT1QWw8wEBcEwCbBXFK
3+YCOIOk390tR4mIfSSfdxQ=
=V+pU
-----END PGP SIGNATURE-----
--=-=-=--


--===============1698024615==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1698024615==--
