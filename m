From: NeilBrown <neilb@suse.com>
Subject: [PATCH] block: trace completion of all bios.
Date: Wed, 22 Mar 2017 13:38:09 +1100
Message-ID: <877f3iave6.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-raid@vger.kernel.org, dm-devel@redhat.com, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Shaohua Li <shli@kernel.org>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


Currently only dm and md/raid5 bios trigger trace_block_bio_complete().
Now that we have bio_chain(), it is not possible, in general, for a
driver to know when the bio is really complete.  Only bio_endio()
knows that.

So move the trace_block_bio_complete() call to bio_endio().

Now trace_block_bio_complete() pairs with trace_block_bio_queue().
Any bio for which a 'queue' event is traced, will subsequently
generate a 'complete' event.

Signed-off-by: NeilBrown <neilb@suse.com>
=2D--
 block/bio.c        | 3 +++
 drivers/md/dm.c    | 1 -
 drivers/md/raid5.c | 8 --------
 3 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 5eec5e08417f..c89d83b3ca32 100644
=2D-- a/block/bio.c
+++ b/block/bio.c
@@ -1838,6 +1838,9 @@ void bio_endio(struct bio *bio)
 		goto again;
 	}
=20
+	if (bio->bi_bdev)
+		trace_block_bio_complete(bdev_get_queue(bio->bi_bdev),
+					 bio, bio->bi_error);
 	if (bio->bi_end_io)
 		bio->bi_end_io(bio);
 }
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index f4ffd1eb8f44..f5f09ace690a 100644
=2D-- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -810,7 +810,6 @@ static void dec_pending(struct dm_io *io, int error)
 			queue_io(md, bio);
 		} else {
 			/* done with normal IO or empty flush */
=2D			trace_block_bio_complete(md->queue, bio, io_error);
 			bio->bi_error =3D io_error;
 			bio_endio(bio);
 		}
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 9a3b7da34137..f684cb566721 100644
=2D-- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -5141,8 +5141,6 @@ static void raid5_align_endio(struct bio *bi)
 	rdev_dec_pending(rdev, conf->mddev);
=20
 	if (!error) {
=2D		trace_block_bio_complete(bdev_get_queue(raid_bi->bi_bdev),
=2D					 raid_bi, 0);
 		bio_endio(raid_bi);
 		if (atomic_dec_and_test(&conf->active_aligned_reads))
 			wake_up(&conf->wait_for_quiescent);
@@ -5727,10 +5725,6 @@ static void raid5_make_request(struct mddev *mddev, =
struct bio * bi)
 		md_write_end(mddev);
 	remaining =3D raid5_dec_bi_active_stripes(bi);
 	if (remaining =3D=3D 0) {
=2D
=2D
=2D		trace_block_bio_complete(bdev_get_queue(bi->bi_bdev),
=2D					 bi, 0);
 		bio_endio(bi);
 	}
 }
@@ -6138,8 +6132,6 @@ static int  retry_aligned_read(struct r5conf *conf, s=
truct bio *raid_bio)
 	}
 	remaining =3D raid5_dec_bi_active_stripes(raid_bio);
 	if (remaining =3D=3D 0) {
=2D		trace_block_bio_complete(bdev_get_queue(raid_bio->bi_bdev),
=2D					 raid_bio, 0);
 		bio_endio(raid_bio);
 	}
 	if (atomic_dec_and_test(&conf->active_aligned_reads))
=2D-=20
2.12.0


--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAljR45EACgkQOeye3VZi
gbkClg/+PD74BFZYRPBU2/TpLJAbilqSi9krSL8XjVoSuIuWor2alJYQiRo97I5F
+gUNBMAn/TaDcKELPcEfLLTV2x7E6EVndz0H8i1CGCK78A9fUudUh/jTl+6YtOJt
kw5EHtIELXuUkot3NwCVCA+9yWKRY07QRpBAolUdyVQ5hH1T3CRv6STbvELOCmDR
HxiiqfAXJcBqfFknxSVOVCFuW7LnadaCqs473/4q+EMrZcKJbTjcBSCd22nv1lA8
meiF4ICisqYLixSLW2nubSraAyd+KroprWXiXX6NmTbXvfIYZf+KH9DTI5g35BdR
Qfac7wGNB+orMHlhk9kKLHudGkwpN+LmZhN7ICprlIzI0Ng7eXvg29SE77EIg02h
3+Ehhembfn/qlg+ymtJjdeqCAadc9h5I5dPpr5p/J9F1q35EkT9tcJarf44GX+C2
UWMc8vzk5Fcz34gE7ux1ST2uNYKDzrlFMC1HJaGMkMBOZ62dsX1n7r7h9TdbrBxS
30Y6onwSL/kswOPMWLBRGH/tveek5rel/eN0WbOGDQUl7kvYFlbT4jeuQatCTPFP
K2QnjOY8A0e6Hh3XVgP5JRYdSNh7rKFw/YIPiW0q88NeuAgkesl2yDw1wRJVRLJw
v7ptMxYqserB6N4u7o0RNdPwZ6ZdV10bNSVK0gHTc+A1XskGtjM=
=LxVC
-----END PGP SIGNATURE-----
--=-=-=--
