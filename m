From: NeilBrown <neilb@suse.com>
Subject: [PATCH 2/5] blk: remove bio_set arg from blk_queue_split()
Date: Fri, 10 Mar 2017 15:34:38 +1100
Message-ID: <877f3xhhr5.fsf@notabene.neil.brown.name>
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


blk_queue_split() is always called with the last arg being q->bio_split,
where 'q' is the first arg.

Also blk_queue_split() sometimes uses the passed-in 'bs' and sometimes uses
q->bio_split.

This is inconsistent and unnecessary.  Remove the last arg and always use
q->bio_split inside blk_queue_split()

Signed-off-by: NeilBrown <neilb@suse.com>
=2D--
 block/blk-core.c              |    2 +-
 block/blk-merge.c             |    7 +++----
 block/blk-mq.c                |    4 ++--
 drivers/block/drbd/drbd_req.c |    2 +-
 drivers/block/pktcdvd.c       |    2 +-
 drivers/block/ps3vram.c       |    2 +-
 drivers/block/rsxx/dev.c      |    2 +-
 drivers/block/umem.c          |    2 +-
 drivers/block/zram/zram_drv.c |    2 +-
 drivers/lightnvm/rrpc.c       |    2 +-
 drivers/md/md.c               |    2 +-
 drivers/s390/block/dcssblk.c  |    2 +-
 drivers/s390/block/xpram.c    |    2 +-
 include/linux/blkdev.h        |    3 +--
 14 files changed, 17 insertions(+), 19 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index bd2cb4ba674e..375006c94c15 100644
=2D-- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1637,7 +1637,7 @@ static blk_qc_t blk_queue_bio(struct request_queue *q=
, struct bio *bio)
 	 */
 	blk_queue_bounce(q, &bio);
=20
=2D	blk_queue_split(q, &bio, q->bio_split);
+	blk_queue_split(q, &bio);
=20
 	if (bio_integrity_enabled(bio) && bio_integrity_prep(bio)) {
 		bio->bi_error =3D -EIO;
diff --git a/block/blk-merge.c b/block/blk-merge.c
index 2afa262425d1..ce8838aff7f7 100644
=2D-- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -188,8 +188,7 @@ static struct bio *blk_bio_segment_split(struct request=
_queue *q,
 	return do_split ? new : NULL;
 }
=20
=2Dvoid blk_queue_split(struct request_queue *q, struct bio **bio,
=2D		     struct bio_set *bs)
+void blk_queue_split(struct request_queue *q, struct bio **bio)
 {
 	struct bio *split, *res;
 	unsigned nsegs;
@@ -197,14 +196,14 @@ void blk_queue_split(struct request_queue *q, struct =
bio **bio,
 	switch (bio_op(*bio)) {
 	case REQ_OP_DISCARD:
 	case REQ_OP_SECURE_ERASE:
=2D		split =3D blk_bio_discard_split(q, *bio, bs, &nsegs);
+		split =3D blk_bio_discard_split(q, *bio, q->bio_split, &nsegs);
 		break;
 	case REQ_OP_WRITE_ZEROES:
 		split =3D NULL;
 		nsegs =3D (*bio)->bi_phys_segments;
 		break;
 	case REQ_OP_WRITE_SAME:
=2D		split =3D blk_bio_write_same_split(q, *bio, bs, &nsegs);
+		split =3D blk_bio_write_same_split(q, *bio, q->bio_split, &nsegs);
 		break;
 	default:
 		split =3D blk_bio_segment_split(q, *bio, q->bio_split, &nsegs);
diff --git a/block/blk-mq.c b/block/blk-mq.c
index b2fd175e84d7..ef7b289e873c 100644
=2D-- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1502,7 +1502,7 @@ static blk_qc_t blk_mq_make_request(struct request_qu=
eue *q, struct bio *bio)
 		return BLK_QC_T_NONE;
 	}
=20
=2D	blk_queue_split(q, &bio, q->bio_split);
+	blk_queue_split(q, &bio);
=20
 	if (!is_flush_fua && !blk_queue_nomerges(q) &&
 	    blk_attempt_plug_merge(q, bio, &request_count, &same_queue_rq))
@@ -1624,7 +1624,7 @@ static blk_qc_t blk_sq_make_request(struct request_qu=
eue *q, struct bio *bio)
 		return BLK_QC_T_NONE;
 	}
=20
=2D	blk_queue_split(q, &bio, q->bio_split);
+	blk_queue_split(q, &bio);
=20
 	if (!is_flush_fua && !blk_queue_nomerges(q)) {
 		if (blk_attempt_plug_merge(q, bio, &request_count, NULL))
diff --git a/drivers/block/drbd/drbd_req.c b/drivers/block/drbd/drbd_req.c
index 652114ae1a8a..f6ed6f7f5ab2 100644
=2D-- a/drivers/block/drbd/drbd_req.c
+++ b/drivers/block/drbd/drbd_req.c
@@ -1554,7 +1554,7 @@ blk_qc_t drbd_make_request(struct request_queue *q, s=
truct bio *bio)
 	struct drbd_device *device =3D (struct drbd_device *) q->queuedata;
 	unsigned long start_jif;
=20
=2D	blk_queue_split(q, &bio, q->bio_split);
+	blk_queue_split(q, &bio);
=20
 	start_jif =3D jiffies;
=20
diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
index 66d846ba85a9..98394d034c29 100644
=2D-- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -2414,7 +2414,7 @@ static blk_qc_t pkt_make_request(struct request_queue=
 *q, struct bio *bio)
=20
 	blk_queue_bounce(q, &bio);
=20
=2D	blk_queue_split(q, &bio, q->bio_split);
+	blk_queue_split(q, &bio);
=20
 	pd =3D q->queuedata;
 	if (!pd) {
diff --git a/drivers/block/ps3vram.c b/drivers/block/ps3vram.c
index 456b4fe21559..48072c0c1010 100644
=2D-- a/drivers/block/ps3vram.c
+++ b/drivers/block/ps3vram.c
@@ -606,7 +606,7 @@ static blk_qc_t ps3vram_make_request(struct request_que=
ue *q, struct bio *bio)
=20
 	dev_dbg(&dev->core, "%s\n", __func__);
=20
=2D	blk_queue_split(q, &bio, q->bio_split);
+	blk_queue_split(q, &bio);
=20
 	spin_lock_irq(&priv->lock);
 	busy =3D !bio_list_empty(&priv->list);
diff --git a/drivers/block/rsxx/dev.c b/drivers/block/rsxx/dev.c
index f81d70b39d10..8c8024f616ae 100644
=2D-- a/drivers/block/rsxx/dev.c
+++ b/drivers/block/rsxx/dev.c
@@ -151,7 +151,7 @@ static blk_qc_t rsxx_make_request(struct request_queue =
*q, struct bio *bio)
 	struct rsxx_bio_meta *bio_meta;
 	int st =3D -EINVAL;
=20
=2D	blk_queue_split(q, &bio, q->bio_split);
+	blk_queue_split(q, &bio);
=20
 	might_sleep();
=20
diff --git a/drivers/block/umem.c b/drivers/block/umem.c
index c141cc3be22b..c8d8a2f16f8e 100644
=2D-- a/drivers/block/umem.c
+++ b/drivers/block/umem.c
@@ -529,7 +529,7 @@ static blk_qc_t mm_make_request(struct request_queue *q=
, struct bio *bio)
 		 (unsigned long long)bio->bi_iter.bi_sector,
 		 bio->bi_iter.bi_size);
=20
=2D	blk_queue_split(q, &bio, q->bio_split);
+	blk_queue_split(q, &bio);
=20
 	spin_lock_irq(&card->lock);
 	*card->biotail =3D bio;
diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index e27d89a36c34..973dac2a9a99 100644
=2D-- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -880,7 +880,7 @@ static blk_qc_t zram_make_request(struct request_queue =
*queue, struct bio *bio)
 {
 	struct zram *zram =3D queue->queuedata;
=20
=2D	blk_queue_split(queue, &bio, queue->bio_split);
+	blk_queue_split(queue, &bio);
=20
 	if (!valid_io_request(zram, bio->bi_iter.bi_sector,
 					bio->bi_iter.bi_size)) {
diff --git a/drivers/lightnvm/rrpc.c b/drivers/lightnvm/rrpc.c
index e00b1d7b976f..701fa2fafbb2 100644
=2D-- a/drivers/lightnvm/rrpc.c
+++ b/drivers/lightnvm/rrpc.c
@@ -999,7 +999,7 @@ static blk_qc_t rrpc_make_rq(struct request_queue *q, s=
truct bio *bio)
 	struct nvm_rq *rqd;
 	int err;
=20
=2D	blk_queue_split(q, &bio, q->bio_split);
+	blk_queue_split(q, &bio);
=20
 	if (bio_op(bio) =3D=3D REQ_OP_DISCARD) {
 		rrpc_discard(rrpc, bio);
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 548d1b8014f8..d7d2bb51a58d 100644
=2D-- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -253,7 +253,7 @@ static blk_qc_t md_make_request(struct request_queue *q=
, struct bio *bio)
 	unsigned int sectors;
 	int cpu;
=20
=2D	blk_queue_split(q, &bio, q->bio_split);
+	blk_queue_split(q, &bio);
=20
 	if (mddev =3D=3D NULL || mddev->pers =3D=3D NULL) {
 		bio_io_error(bio);
diff --git a/drivers/s390/block/dcssblk.c b/drivers/s390/block/dcssblk.c
index 415d10a67b7a..10ece6f3c7eb 100644
=2D-- a/drivers/s390/block/dcssblk.c
+++ b/drivers/s390/block/dcssblk.c
@@ -829,7 +829,7 @@ dcssblk_make_request(struct request_queue *q, struct bi=
o *bio)
 	unsigned long source_addr;
 	unsigned long bytes_done;
=20
=2D	blk_queue_split(q, &bio, q->bio_split);
+	blk_queue_split(q, &bio);
=20
 	bytes_done =3D 0;
 	dev_info =3D bio->bi_bdev->bd_disk->private_data;
diff --git a/drivers/s390/block/xpram.c b/drivers/s390/block/xpram.c
index b9d7e755c8a3..a48f0d40c1d2 100644
=2D-- a/drivers/s390/block/xpram.c
+++ b/drivers/s390/block/xpram.c
@@ -190,7 +190,7 @@ static blk_qc_t xpram_make_request(struct request_queue=
 *q, struct bio *bio)
 	unsigned long page_addr;
 	unsigned long bytes;
=20
=2D	blk_queue_split(q, &bio, q->bio_split);
+	blk_queue_split(q, &bio);
=20
 	if ((bio->bi_iter.bi_sector & 7) !=3D 0 ||
 	    (bio->bi_iter.bi_size & 4095) !=3D 0)
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 796016e63c1d..63008a246403 100644
=2D-- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -934,8 +934,7 @@ extern int blk_insert_cloned_request(struct request_que=
ue *q,
 				     struct request *rq);
 extern int blk_rq_append_bio(struct request *rq, struct bio *bio);
 extern void blk_delay_queue(struct request_queue *, unsigned long);
=2Dextern void blk_queue_split(struct request_queue *, struct bio **,
=2D			    struct bio_set *);
+extern void blk_queue_split(struct request_queue *, struct bio **);
 extern void blk_recount_segments(struct request_queue *, struct bio *);
 extern int scsi_verify_blk_ioctl(struct block_device *, unsigned int);
 extern int scsi_cmd_blk_ioctl(struct block_device *, fmode_t,



--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAljCLN4ACgkQOeye3VZi
gbmUUw//Zk5pR5F2HuKxvC0vGF1Z8HL30tAnIfrAZe7Zlx1NknAIIUGz+KXGLVsH
CjU464jJumuSgWcfzzRbuNVMKhF9sj7pncyd3cOUK5pxGEB8jkHgxdtpRQkl0d1r
9jM2D2Tzaxt5ICIiKs6o4edG7YvUiDrpgc803JSVrnCLPzshEoktAJ/SUlsn6EIC
rUPFXM1NUNIwoU6W42t+1ZTH4+LcAhXn2efl9hPDFJRindAvbiFhGuW8HP5HDbb9
LMGKn6A4l7Wf90/iRf09xSSbw7Hpez05msGniHqzsPBu9U8xx7K1i3YbN66TBcx9
u4cUxf9J0OOO7IvgYjNsfuD5czC038rV00OHerIqx2dNhumYin+CqxS0crF9p+AN
InrVAPdsvcmZjLdPDpZGdNnPIZ90JzqC4bfbC1L5sxR9oMrxD0Dhs8lfDxwvAj4v
buhl1IGOMpjUwKARZWqdmcLC14pQGvoSrTlieSsguPaqpsCy1hh446oXnYhHVTGC
gpuGQBkkaYW+Ox/VaQ0O/BzJizbslGpCd8pAWXQ7Auiaj+VvRFoLLAV+nOjeiMHd
m6lHB2Kahzxtw7cCGEvXvF+zeDlC+BwA7imsfo7rfNmaBZcSjvcUlIbMsnwrDsVU
Dp4qHDPxrAIGoc1qdxaiFaPjGRgnTufSEwbc2+boJl1fsBSYXJI=
=NrWB
-----END PGP SIGNATURE-----
--=-=-=--
