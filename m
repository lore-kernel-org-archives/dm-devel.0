From: NeilBrown <neilb@suse.com>
Subject: [PATCH 3/5] blk: make the bioset rescue_workqueue optional.
Date: Fri, 10 Mar 2017 15:35:40 +1100
Message-ID: <874lz1hhpf.fsf@notabene.neil.brown.name>
References: <87h93blz6g.fsf@notabene.neil.brown.name> <71562c2c-97f4-9a0a-32ec-30e0702ca575@profitbricks.com> <87lgsjj9w8.fsf@notabene.neil.brown.name> <a674456d-fb93-437e-c50e-195e7a035ba4@kernel.dk> <87r328j00i.fsf@notabene.neil.brown.name> <87d1dphhuy.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <87d1dphhuy.fsf@notabene.neil.brown.name>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, Jack Wang <jinpu.wang@profitbricks.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Lars Ellenberg <lars.ellenberg@linbit.com>, Kent Overstreet <kent.overstreet@gmail.com>, Pavel Machek <pavel@ucw.cz>, Mike Snitzer <snitzer@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>, linux-raid@vger.kernel.org, device-mapper development <dm-devel@redhat.com>, linux-block@vger.kernel.org
List-Id: dm-devel.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


This patch converts bioset_create() and bioset_create_nobvec()
to not create a workqueue so alloctions will never trigger
punt_bios_to_rescuer().
It also introduces bioset_create_rescued() and bioset_create_nobvec_rescued=
()
which preserve the old behaviour.

*All* callers of bioset_create() and bioset_create_nobvec() are
converted to the _rescued() version, so that not change in behaviour
is experienced.

It is hoped that most, if not all, bioset can end up being the
non-rescued version.

Signed-off-by: NeilBrown <neilb@suse.com>
=2D--
 block/bio.c                         |   30 +++++++++++++++++++++++++-----
 block/blk-core.c                    |    2 +-
 drivers/block/drbd/drbd_main.c      |    2 +-
 drivers/md/bcache/super.c           |    4 ++--
 drivers/md/dm-crypt.c               |    2 +-
 drivers/md/dm-io.c                  |    2 +-
 drivers/md/dm.c                     |    5 +++--
 drivers/md/md.c                     |    2 +-
 drivers/md/raid5-cache.c            |    2 +-
 drivers/target/target_core_iblock.c |    2 +-
 fs/block_dev.c                      |    2 +-
 fs/btrfs/extent_io.c                |    4 ++--
 fs/xfs/xfs_super.c                  |    2 +-
 include/linux/bio.h                 |    2 ++
 14 files changed, 43 insertions(+), 20 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 84ae39f06f81..06587f1119f5 100644
=2D-- a/block/bio.c
+++ b/block/bio.c
@@ -362,6 +362,8 @@ static void punt_bios_to_rescuer(struct bio_set *bs)
 	struct bio_list punt, nopunt;
 	struct bio *bio;
=20
+	if (!WARN_ON_ONCE(!bs->rescue_workqueue))
+		return;
 	/*
 	 * In order to guarantee forward progress we must punt only bios that
 	 * were allocated from this bio_set; otherwise, if there was a bio on
@@ -471,7 +473,8 @@ struct bio *bio_alloc_bioset(gfp_t gfp_mask, int nr_iov=
ecs, struct bio_set *bs)
=20
 		if (current->bio_list &&
 		    (!bio_list_empty(&current->bio_list[0]) ||
=2D		     !bio_list_empty(&current->bio_list[1])))
+		     !bio_list_empty(&current->bio_list[1])) &&
+		    bs->rescue_workqueue)
 			gfp_mask &=3D ~__GFP_DIRECT_RECLAIM;
=20
 		p =3D mempool_alloc(bs->bio_pool, gfp_mask);
@@ -1940,7 +1943,8 @@ EXPORT_SYMBOL(bioset_free);
=20
 static struct bio_set *__bioset_create(unsigned int pool_size,
 				       unsigned int front_pad,
=2D				       bool create_bvec_pool)
+				       bool create_bvec_pool,
+				       bool create_rescue_workqueue)
 {
 	unsigned int back_pad =3D BIO_INLINE_VECS * sizeof(struct bio_vec);
 	struct bio_set *bs;
@@ -1971,6 +1975,9 @@ static struct bio_set *__bioset_create(unsigned int p=
ool_size,
 			goto bad;
 	}
=20
+	if (!create_rescue_workqueue)
+		return bs;
+
 	bs->rescue_workqueue =3D alloc_workqueue("bioset", WQ_MEM_RECLAIM, 0);
 	if (!bs->rescue_workqueue)
 		goto bad;
@@ -1996,10 +2003,16 @@ static struct bio_set *__bioset_create(unsigned int=
 pool_size,
  */
 struct bio_set *bioset_create(unsigned int pool_size, unsigned int front_p=
ad)
 {
=2D	return __bioset_create(pool_size, front_pad, true);
+	return __bioset_create(pool_size, front_pad, true, false);
 }
 EXPORT_SYMBOL(bioset_create);
=20
+struct bio_set *bioset_create_rescued(unsigned int pool_size, unsigned int=
 front_pad)
+{
+	return __bioset_create(pool_size, front_pad, true, true);
+}
+EXPORT_SYMBOL(bioset_create_rescued);
+
 /**
  * bioset_create_nobvec  - Create a bio_set without bio_vec mempool
  * @pool_size:	Number of bio to cache in the mempool
@@ -2011,10 +2024,17 @@ EXPORT_SYMBOL(bioset_create);
  */
 struct bio_set *bioset_create_nobvec(unsigned int pool_size, unsigned int =
front_pad)
 {
=2D	return __bioset_create(pool_size, front_pad, false);
+	return __bioset_create(pool_size, front_pad, false, false);
 }
 EXPORT_SYMBOL(bioset_create_nobvec);
=20
+struct bio_set *bioset_create_nobvec_rescued(unsigned int pool_size,
+					     unsigned int front_pad)
+{
+	return __bioset_create(pool_size, front_pad, false, true);
+}
+EXPORT_SYMBOL(bioset_create_nobvec_rescued);
+
 #ifdef CONFIG_BLK_CGROUP
=20
 /**
@@ -2129,7 +2149,7 @@ static int __init init_bio(void)
 	bio_integrity_init();
 	biovec_init_slabs();
=20
=2D	fs_bio_set =3D bioset_create(BIO_POOL_SIZE, 0);
+	fs_bio_set =3D bioset_create_rescued(BIO_POOL_SIZE, 0);
 	if (!fs_bio_set)
 		panic("bio: can't allocate bios\n");
=20
diff --git a/block/blk-core.c b/block/blk-core.c
index 375006c94c15..c3992d17dc2c 100644
=2D-- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -714,7 +714,7 @@ struct request_queue *blk_alloc_queue_node(gfp_t gfp_ma=
sk, int node_id)
 	if (q->id < 0)
 		goto fail_q;
=20
=2D	q->bio_split =3D bioset_create(BIO_POOL_SIZE, 0);
+	q->bio_split =3D bioset_create_rescued(BIO_POOL_SIZE, 0);
 	if (!q->bio_split)
 		goto fail_id;
=20
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 92c60cbd04ee..2c69c2ab0fff 100644
=2D-- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -2166,7 +2166,7 @@ static int drbd_create_mempools(void)
 		goto Enomem;
=20
 	/* mempools */
=2D	drbd_md_io_bio_set =3D bioset_create(DRBD_MIN_POOL_PAGES, 0);
+	drbd_md_io_bio_set =3D bioset_create_rescued(DRBD_MIN_POOL_PAGES, 0);
 	if (drbd_md_io_bio_set =3D=3D NULL)
 		goto Enomem;
=20
diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 85e3f21c2514..6cb30792f0ed 100644
=2D-- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -786,7 +786,7 @@ static int bcache_device_init(struct bcache_device *d, =
unsigned block_size,
=20
 	minor *=3D BCACHE_MINORS;
=20
=2D	if (!(d->bio_split =3D bioset_create(4, offsetof(struct bbio, bio))) ||
+	if (!(d->bio_split =3D bioset_create_rescued(4, offsetof(struct bbio, bio=
))) ||
 	    !(d->disk =3D alloc_disk(BCACHE_MINORS))) {
 		ida_simple_remove(&bcache_minor, minor);
 		return -ENOMEM;
@@ -1520,7 +1520,7 @@ struct cache_set *bch_cache_set_alloc(struct cache_sb=
 *sb)
 				sizeof(struct bbio) + sizeof(struct bio_vec) *
 				bucket_pages(c))) ||
 	    !(c->fill_iter =3D mempool_create_kmalloc_pool(1, iter_size)) ||
=2D	    !(c->bio_split =3D bioset_create(4, offsetof(struct bbio, bio))) ||
+	    !(c->bio_split =3D bioset_create_rescued(4, offsetof(struct bbio, bio=
))) ||
 	    !(c->uuids =3D alloc_bucket_pages(GFP_KERNEL, c)) ||
 	    !(c->moving_gc_wq =3D alloc_workqueue("bcache_gc",
 						WQ_MEM_RECLAIM, 0)) ||
diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 389a3637ffcc..91a2d637d44f 100644
=2D-- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -1936,7 +1936,7 @@ static int crypt_ctr(struct dm_target *ti, unsigned i=
nt argc, char **argv)
 		goto bad;
 	}
=20
=2D	cc->bs =3D bioset_create(MIN_IOS, 0);
+	cc->bs =3D bioset_create_rescued(MIN_IOS, 0);
 	if (!cc->bs) {
 		ti->error =3D "Cannot allocate crypt bioset";
 		goto bad;
diff --git a/drivers/md/dm-io.c b/drivers/md/dm-io.c
index 03940bf36f6c..fe1241c196b1 100644
=2D-- a/drivers/md/dm-io.c
+++ b/drivers/md/dm-io.c
@@ -58,7 +58,7 @@ struct dm_io_client *dm_io_client_create(void)
 	if (!client->pool)
 		goto bad;
=20
=2D	client->bios =3D bioset_create(min_ios, 0);
+	client->bios =3D bioset_create_rescued(min_ios, 0);
 	if (!client->bios)
 		goto bad;
=20
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index dfb75979e455..41b1f033841f 100644
=2D-- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1002,7 +1002,8 @@ static void flush_current_bio_list(struct blk_plug_cb=
 *cb, bool from_schedule)
=20
 		while ((bio =3D bio_list_pop(&list))) {
 			struct bio_set *bs =3D bio->bi_pool;
=2D			if (unlikely(!bs) || bs =3D=3D fs_bio_set) {
+			if (unlikely(!bs) || bs =3D=3D fs_bio_set ||
+			    !bs->rescue_workqueue) {
 				bio_list_add(&current->bio_list[i], bio);
 				continue;
 			}
@@ -2577,7 +2578,7 @@ struct dm_md_mempools *dm_alloc_md_mempools(struct ma=
pped_device *md, unsigned t
 		BUG();
 	}
=20
=2D	pools->bs =3D bioset_create_nobvec(pool_size, front_pad);
+	pools->bs =3D bioset_create_nobvec_rescued(pool_size, front_pad);
 	if (!pools->bs)
 		goto out;
=20
diff --git a/drivers/md/md.c b/drivers/md/md.c
index d7d2bb51a58d..e5f08a195837 100644
=2D-- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5220,7 +5220,7 @@ int md_run(struct mddev *mddev)
 	}
=20
 	if (mddev->bio_set =3D=3D NULL) {
=2D		mddev->bio_set =3D bioset_create(BIO_POOL_SIZE, 0);
+		mddev->bio_set =3D bioset_create_rescued(BIO_POOL_SIZE, 0);
 		if (!mddev->bio_set)
 			return -ENOMEM;
 	}
diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 3f307be01b10..c95c6c046395 100644
=2D-- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -2831,7 +2831,7 @@ int r5l_init_log(struct r5conf *conf, struct md_rdev =
*rdev)
 	if (!log->io_pool)
 		goto io_pool;
=20
=2D	log->bs =3D bioset_create(R5L_POOL_SIZE, 0);
+	log->bs =3D bioset_create_rescued(R5L_POOL_SIZE, 0);
 	if (!log->bs)
 		goto io_bs;
=20
diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_co=
re_iblock.c
index d316ed537d59..5bf3392195c6 100644
=2D-- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -93,7 +93,7 @@ static int iblock_configure_device(struct se_device *dev)
 		return -EINVAL;
 	}
=20
=2D	ib_dev->ibd_bio_set =3D bioset_create(IBLOCK_BIO_POOL_SIZE, 0);
+	ib_dev->ibd_bio_set =3D bioset_create_rescued(IBLOCK_BIO_POOL_SIZE, 0);
 	if (!ib_dev->ibd_bio_set) {
 		pr_err("IBLOCK: Unable to create bioset\n");
 		goto out;
diff --git a/fs/block_dev.c b/fs/block_dev.c
index 2eca00ec4370..c0ca5f0d0369 100644
=2D-- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -436,7 +436,7 @@ blkdev_direct_IO(struct kiocb *iocb, struct iov_iter *i=
ter)
=20
 static __init int blkdev_init(void)
 {
=2D	blkdev_dio_pool =3D bioset_create(4, offsetof(struct blkdev_dio, bio));
+	blkdev_dio_pool =3D bioset_create_rescued(4, offsetof(struct blkdev_dio, =
bio));
 	if (!blkdev_dio_pool)
 		return -ENOMEM;
 	return 0;
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 28e81922a21c..34aa8893790a 100644
=2D-- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -173,8 +173,8 @@ int __init extent_io_init(void)
 	if (!extent_buffer_cache)
 		goto free_state_cache;
=20
=2D	btrfs_bioset =3D bioset_create(BIO_POOL_SIZE,
=2D				     offsetof(struct btrfs_io_bio, bio));
+	btrfs_bioset =3D bioset_create_rescued(BIO_POOL_SIZE,
+					     offsetof(struct btrfs_io_bio, bio));
 	if (!btrfs_bioset)
 		goto free_buffer_cache;
=20
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 890862f2447c..f4c4d6f41d91 100644
=2D-- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1756,7 +1756,7 @@ MODULE_ALIAS_FS("xfs");
 STATIC int __init
 xfs_init_zones(void)
 {
=2D	xfs_ioend_bioset =3D bioset_create(4 * MAX_BUF_PER_PAGE,
+	xfs_ioend_bioset =3D bioset_create_rescued(4 * MAX_BUF_PER_PAGE,
 			offsetof(struct xfs_ioend, io_inline_bio));
 	if (!xfs_ioend_bioset)
 		goto out;
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 8e521194f6fc..05730603fcf1 100644
=2D-- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -379,7 +379,9 @@ static inline struct bio *bio_next_split(struct bio *bi=
o, int sectors,
 }
=20
 extern struct bio_set *bioset_create(unsigned int, unsigned int);
+extern struct bio_set *bioset_create_rescued(unsigned int, unsigned int);
 extern struct bio_set *bioset_create_nobvec(unsigned int, unsigned int);
+extern struct bio_set *bioset_create_nobvec_rescued(unsigned int, unsigned=
 int);
 extern void bioset_free(struct bio_set *);
 extern mempool_t *biovec_create_pool(int pool_entries);
=20



--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAljCLRwACgkQOeye3VZi
gbkzpg/8DealO8yno+eLhYztF3dbooW7bu66vOqJ5MGwm4Yeof+vaCCGw7FqY9ii
kgKyjpVROdxRgeT5VqDy4AbaC4JJkaKVVswoYCC7hC6Hm3OqNse4uiAd+730Ov5c
eDXbEnPJWgRu0nnR+ZIcf2tC657i1zDRjWJwm8MRRu4sA4E7JUj0+1vCm85SrXDF
iEIZExnto4aB61En2vKjsMV4srm2Pzf3aBHOPhMaJzgVQb5HRKtMse6pdmj1KMVN
zNs3u/aID1GBqbZS3XEixAR5zQgkgUW+au2lBB9MZ29k/LqWizkCmyuHfV1sd++o
+7g7B6Nnp0gPJUmNN6+tBn0Wf+memT6qyN2jx9Vrs20vbYUUmb0VMMWAIZ2pJ/KS
W+jtrt30H0k/8LDsqUiOS6mEqQr8s/ezUoWmZSxlXfuGgqXfdyk7SlCBTYFsO0A9
k5netDwyY8prVxUASqO1ef626iCMmPOiW9zQLGzSsanWHzBmzMxu2shQ1i1bvfW1
He+c4Q+57IwQtHej4ZeX+QEFt8wmBMO4AxKwb+Z+DaMGhfvG/iOsucVDwQ6dLIcc
8cLkMngcPD3pymL6fVhX696Am4E1VppJxDc06BfKpEi3makF77lnos9gEF7jDMoW
mlXXc6OJCXonSNNZD5r8TPtakUg14XnobKQf7fxEIjLtut3bszQ=
=wssu
-----END PGP SIGNATURE-----
--=-=-=--
