From: Dan Smith <danms@us.ibm.com>
Subject: Re: dm-userspace memory consumption in remap cache
Date: Fri, 25 Aug 2006 12:40:47 -0700
Message-ID: <m3lkpcbo3k.fsf@guaranine.beaverton.ibm.com>
References: <44EF3DC5.2040403@cs.cmu.edu>
	<m3zmdsbqrs.fsf@guaranine.beaverton.ibm.com>
	<44EF505D.8040806@cs.cmu.edu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0124046350=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <44EF505D.8040806@cs.cmu.edu> (Benjamin Gilbert's message of
	"Fri, 25 Aug 2006 15:32:45 -0400")
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Gilbert <bgilbert@cs.cmu.edu>
Cc: Niraj Tolia <ntolia@gmail.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

--===============0124046350==
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"

--=-=-=
Content-Transfer-Encoding: quoted-printable

BG> In fact, when the dmu device is unmapped, destroy_dmu_device()
BG> moves all of the dmu_maps to the end of the MRU list but does not
BG> free them, so that memory stays around.  If a new device is
BG> created, its dmu_maps will still be obtained from kmem_cache_alloc
BG> even though there are unused dmu_maps.

Ah, yet another good point :)

BG> Come to think of it, that would be very interesting data in its
BG> own right.

I agree.

BG> ...I'm probably missing an obvious reason that that won't work.

I'm not sure why it wouldn't work.  I think it's likely to result in a
lot of polling, but it could definitely be useful in certain
situations.

=2D-=20
Dan Smith
IBM Linux Technology Center
Open Hypervisor Team
email: danms@us.ibm.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2.2 (GNU/Linux)

iD8DBQFE71JEwtEf7b4GJVQRAp1vAJ9pydVrZWnkUSUp+K0vCf3mEOtMqACfeH8z
2DfpCjZJ0AEYduS6pTGYQqc=
=+edA
-----END PGP SIGNATURE-----
--=-=-=--


--===============0124046350==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0124046350==--
