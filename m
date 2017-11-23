From: NeilBrown <neilb@suse.com>
Subject: [PATCH] dm: use cloned bio as head, not remainder, in __split_and_process_bio()
Date: Fri, 24 Nov 2017 09:52:16 +1100
Message-ID: <878tewzjz3.fsf@notabene.neil.brown.name>
References: <149776047907.23258.8058071140236879834.stgit@noble> <20170618184143.GA10920@kernel.dk> <87poe13rmm.fsf@notabene.neil.brown.name> <CAMM=eLf9Vu-z1ZEsGtRoSkhpaaQXAdr8TsUYUCSmAjqrqo=W-w@mail.gmail.com> <87a7zg31vx.fsf@notabene.neil.brown.name> <20171121013533.GA14520@redhat.com> <20171121121049.GA17014@redhat.com> <20171121124311.GA17243@redhat.com> <20171121194709.GA18903@redhat.com> <alpine.LRH.2.02.1711211613000.10766@file01.intranet.prod.int.rdu2.redhat.com> <20171121225119.GA19630@redhat.com> <alpine.LRH.2.02.1711212009040.28456@file01.intranet.prod.int.rdu2.redhat.com> <87bmjv0xos.fsf@notabene.neil.brown.name> <alpine.LRH.2.02.1711221250090.21196@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.02.1711221250090.21196@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Mike Snitzer <snitzer@redhat.com>, Jens Axboe <axboe@kernel.dk>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-block@vger.kernel.org, device-mapper development <dm-devel@redhat.com>, Zdenek Kabelac <zkabelac@redhat.com>
List-Id: dm-devel.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


When we use bio_clone_bioset() to split off the front part of a bio
and chain the two together and submit the remainder to
generic_make_request(), it is important that the newly allocated
bio is used as the head to be processed immediately, and the original
bio gets "bio_advance()"d and sent to generic_make_request() as the
remainder.

If the newly allocated bio is used as the remainder, and if it then
needs to be split again, then the next bio_clone_bioset() call will
be made while holding a reference a bio (result of the first clone)
from the same bioset.  This can potentially exhaust the bioset mempool
and result in a memory allocation deadlock.

So the result of the bio_clone_bioset() must be attached to the new
dm_io struct, and the original must be resubmitted.  The current code
is backwards.

Note that there is no race caused by reassigning cio.io->bio after already
calling __map_bio().  This bio will only be dereferenced again after
dec_pending() has found io->io_count to be zero, and this cannot happen
before the dec_pending() call at the end of __split_and_process_bio().

Reported-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: NeilBrown <neilb@suse.com>
=2D--

Hi,
 I think this should resolve the problem Mikulas noticed that the
 bios form a deep chain instead of a wide tree.

Thanks,
NeilBrown

 drivers/md/dm.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 99ec215f7dcb..2e0e10a1c030 100644
=2D-- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1482,12 +1482,19 @@ static void __split_and_process_bio(struct mapped_d=
evice *md,
 				 * Remainder must be passed to generic_make_request()
 				 * so that it gets handled *after* bios already submitted
 				 * have been completely processed.
+				 * We take a clone of the original to store in
+				 * ci.io->bio to be used by end_io_acct() and
+				 * for dec_pending to use for completion handling.
+				 * As this path is not used for REQ_OP_ZONE_REPORT,
+				 * the usage of io->bio in dm_remap_zone_report()
+				 * won't be affected by this reassignment.
 				 */
 				struct bio *b =3D bio_clone_bioset(bio, GFP_NOIO,
 								 md->queue->bio_split);
=2D				bio_advance(b, (bio_sectors(b) - ci.sector_count) << 9);
+				ci.io->bio =3D b;
+				bio_advance(bio, (bio_sectors(bio) - ci.sector_count) << 9);
 				bio_chain(b, bio);
=2D				generic_make_request(b);
+				generic_make_request(bio);
 				break;
 			}
 		}
=2D-=20
2.14.0.rc0.dirty


--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAloXUSEACgkQOeye3VZi
gbnB6Q/8DjyvCH8cNZIxE2acp43X7QW3kf+K/EMsKfpr79+gfLIcORJlP8GtsHe6
n8kIQEKUMXGbTH6zrEcZ27GaZ9X4EA/vDxQ5R56mgTobCBcGZUP/cVfDgp0pfndi
5CwWve2S7s2a0/Emym7oxWnJhC/84aMC/7HWBV1BOty1hO4UtnD9VHdFFTkLnXuO
66qrdbV85QLTi80W/MvMXdtykXz6Z2n7FegvL3/v9GK2YEd0Q7+FjxhPxnLl10Iw
NzJRQ0TYcoTeRxMUeYzjpA602tp5PX5wfbSamdsv1YXWia9eVGxO38UmWQll8CPo
CT/vG39bFS1cip5bJ9BCvYP3ZE6UIaceLQ6G50dROlLSqeL2UATp4BA9UqArZPVd
rdddQaiLQTnTnibcF4O/aovEJugtSaNkbynsIGvPsSFLEvK8qbicaezm0bycvU3d
nR99TYG7yL/lo5Vs9FRv3eRMf5g4BLwINoyp0PilAq6cP5TwB/sQXMrVsY3arPyA
Td+rOVwpdXCQ7hiA8cC9uSSxID6g9IeXCbOIhvYHofad9z1SvmKryllGvTBC892d
n6+GocfYyWAv4qoJ/04tnEU4k0T2fb/eu7w1pSA1OSd9Rqm/L2ysy7S5L8wElLGk
h7Hg+Uflt0GL6NycJ+6D6H5yZwdv9BdQcSgXp5Yq3Mw3l3yIu/I=
=+nQ0
-----END PGP SIGNATURE-----
--=-=-=--
