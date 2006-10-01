From: Dan Smith <danms@us.ibm.com>
Subject: Re: Latest dm-userspace kernel code
Date: Sun, 01 Oct 2006 10:12:09 -0700
Message-ID: <m31wpsyn86.fsf@guaranine.beaverton.ibm.com>
References: <m3mz8hz76i.fsf@guaranine.beaverton.ibm.com>
	<20061001023502S.fujita.tomonori@lab.ntt.co.jp>
	<m364f5yomi.fsf@guaranine.beaverton.ibm.com>
	<200610010351.k913pOSL020042@r-dd.iij4u.or.jp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1403137190=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <200610010351.k913pOSL020042@r-dd.iij4u.or.jp> (FUJITA Tomonori's
	message of "Sun, 01 Oct 2006 12:51:24 +0900")
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

--===============1403137190==
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"

--=-=-=
Content-Transfer-Encoding: quoted-printable

FT> I'm talking about removing dmu_request->deps (dependent request
FT> feature). Seems that you are talking about DMU_FLAG_COPY_FIRST
FT> feature (it's ok for me).

Ah, I see.  Sorry for the confusion :)

FT> My point is that the dependent request feature can be done in user
FT> space easily. If a user-space program gets a request trying to
FT> perform I/Os in the same block that an outgoing request with
FT> DMU_FLAG_COPY_FIRST are performing I/Os too, it waits for the I/O
FT> completion and then submit the new request to kernel space.

Yes, I think this is a good idea.  I will put it on my list of things
to do next week.

FT> I think that AIO is essential for the metadata issue even with
FT> DMU_FLAG_COPY_FIRST and dependent request features, though the
FT> DMU_FLAG_COPY_FIRST feature is important for writing a newly
FT> allocated cow block.

Yes, I fully intend to use AIO for metadata flushing eventually.

=2D-=20
Dan Smith
IBM Linux Technology Center
Open Hypervisor Team
email: danms@us.ibm.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2.2 (GNU/Linux)

iD8DBQFFH/brwtEf7b4GJVQRAtHzAJsEn03QdKH46EcEpQ84OE8uDUAEcACbBq6y
mmtCg7JPjzzzvZU7ejbVO88=
=0oJ8
-----END PGP SIGNATURE-----
--=-=-=--


--===============1403137190==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1403137190==--
