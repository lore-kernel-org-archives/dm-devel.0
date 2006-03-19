From: Dan Smith <danms@us.ibm.com>
Subject: Re: [PATCH] Fixes for clone_bio and __clone_and_map
	functions in dm.c
Date: Sun, 19 Mar 2006 10:38:37 -0800
Message-ID: <878xr6p9ea.fsf@caffeine.beaverton.ibm.com>
References: <Pine.GSO.4.60.0603191017150.8166@cascade.cs.ubc.ca>
	<5055b5c00603191024q5e8212b7rbb5074182cc31474@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1739099824=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <5055b5c00603191024q5e8212b7rbb5074182cc31474@mail.gmail.com>
	(Abhishek Gupta's message of "Sun, 19 Mar 2006 10:24:00 -0800")
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

--===============1739099824==
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"

--=-=-=
Content-Transfer-Encoding: quoted-printable

AG> I encountered another problem in the final else condition of
AG> __clone_and_map() function where the bio vector is split in to two
AG> parts. This is perhaps based on the assumption that the next
AG> target can completely accomodate the bio vector. However, I have
AG> encountered situations when this assumption can be violated and
AG> have introduced a do-while loop to correct it.

I found this bug last week as it was preventing me from having targets
that have a split_io of 1 sector.  Interestingly, I had planned to
code up a solution very similar to yours next week!

I'll test it tomorrow to see if it solves my problem... Thanks! :)

=2D-=20
Dan Smith
IBM Linux Technology Center
Open Hypervisor Team
email: danms@us.ibm.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2.1 (GNU/Linux)

iD8DBQBEHaUwwtEf7b4GJVQRArf5AJ0VNSX59P2GCgEx8Z1H8JWC4Op4WgCfW/r8
u5qAH4I1LMAGQr4ZX904RvI=
=aTFq
-----END PGP SIGNATURE-----
--=-=-=--


--===============1739099824==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1739099824==--
