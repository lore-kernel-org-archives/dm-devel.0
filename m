From: Dan Smith <danms@us.ibm.com>
Subject: Re: [PATCH] Latest dm-userspace, with memory reclaim
Date: Sun, 10 Sep 2006 19:49:28 -0700
Message-ID: <m3irjvt8w7.fsf@guaranine.beaverton.ibm.com>
References: <m3veob7a9d.fsf@guaranine.beaverton.ibm.com>
	<200609101334.k8ADYeHM012649@r-dd.iij4u.or.jp>
	<m3mz97tzgf.fsf@guaranine.beaverton.ibm.com>
	<200609102354.k8ANsPoC018868@r-dd.iij4u.or.jp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1384917513=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <200609102354.k8ANsPoC018868@r-dd.iij4u.or.jp> (FUJITA Tomonori's
	message of "Mon, 11 Sep 2006 08:54:24 +0900")
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

--===============1384917513==
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"

--=-=-=
Content-Transfer-Encoding: quoted-printable

FT> Yeah, I think that there is no performance difference under real
FT> workloads (not synthetic benchmark workloads).

So dbench is too synthetic?  Performance with guest domains has been
quite good in my experience.

FT> Right, I should have said that the major advantage of ring buffer
FT> is communication without system calls.

That's definitely possible, but if the remap cache reduces the amount
of communication with userspace, then you also save the context switch
to map the data each time.  I know that blktap does not seem to suffer
much of a performance hit here, so it may be lost in the noise of a
domain switch.  What about native performance?  I intend for
dm-userspace to be useful outside the realm of Xen :)

FT> I've not tried the origianl dm-userspace.=20

Then why do you claim that performance suffers because of the use of
syscalls?=20

FT> You have all the equipment, so can you do a performance
FT> comparison?=20

Yes, I can.

FT> I guess that the results of Xen blktap and blkback drivers have
FT> told us the expected performance differences.

Is it not possible that blktap performs well for Xen because I/O
latency is hidden by domain switches?  I would think that on a single
processor vanilla linux system that switching to userspace for every
single map would not be ideal.

=2D-=20
Dan Smith
IBM Linux Technology Center
Open Hypervisor Team
email: danms@us.ibm.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2.2 (GNU/Linux)

iD8DBQFFBM6+wtEf7b4GJVQRAjsHAJ4gk74uy7lVO+DgD9KQ5w8RER3v9wCaAqG8
iac989K0gXfF6FcPUQk5gH4=
=Xl8A
-----END PGP SIGNATURE-----
--=-=-=--


--===============1384917513==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1384917513==--
