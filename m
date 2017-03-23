From: NeilBrown <neilb@suse.com>
Subject: [PATCH v2] block: trace completion of all bios.
Date: Thu, 23 Mar 2017 17:29:02 +1100
Message-ID: <87shm4a4lt.fsf@notabene.neil.brown.name>
References: <877f3iave6.fsf@notabene.neil.brown.name>
	<20170322125149.GA29606@infradead.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============8506014006343438143=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170322125149.GA29606@infradead.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>
Cc: linux-raid@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, dm-devel@redhat.com, Shaohua Li <shli@kernel.org>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

--===============8506014006343438143==
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"

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

There are a few cases where completion tracing is not wanted.
1/ If blk_update_request() has already generated a completion
   trace event at the 'request' level, there is no point generating
   one at the bio level too.  In this case the bi_sector and bi_size
   will have changed, so the bio level event would be wrong

2/ If the bio hasn't actually been queued yet, but is being aborted
   early, then a trace event could be confusing.  Some filesystems
   call bio_endio() and will need to use a different interface to
   avoid tracing

3/ The bio_integrity code interposes itself by replacing bi_end_io,
   then restores it and calls bio_endio() again.  This would produce
   two identical trace events if left like that.

To handle these, we provide bio_endio_notrace().  This patch only adds
uses of this in core code.  Separate patches will be needed to update
the filesystems to avoid tracing.

Signed-off-by: NeilBrown <neilb@suse.com>
=2D--
 block/bio-integrity.c |  4 ++--
 block/bio.c           | 46 ++++++++++++++++++++++++++++++++++++++++++++++
 block/blk-core.c      |  2 +-
 drivers/md/dm.c       |  1 -
 drivers/md/raid5.c    |  8 --------
 include/linux/bio.h   |  1 +
 6 files changed, 50 insertions(+), 12 deletions(-)

diff --git a/block/bio-integrity.c b/block/bio-integrity.c
index 5384713d48bc..28581e2f68fb 100644
=2D-- a/block/bio-integrity.c
+++ b/block/bio-integrity.c
@@ -370,7 +370,7 @@ static void bio_integrity_verify_fn(struct work_struct =
*work)
=20
 	/* Restore original bio completion handler */
 	bio->bi_end_io =3D bip->bip_end_io;
=2D	bio_endio(bio);
+	bio_endio_notrace(bio);
 }
=20
 /**
@@ -397,7 +397,7 @@ void bio_integrity_endio(struct bio *bio)
 	 */
 	if (bio->bi_error) {
 		bio->bi_end_io =3D bip->bip_end_io;
=2D		bio_endio(bio);
+		bio_endio_notrace(bio);
=20
 		return;
 	}
diff --git a/block/bio.c b/block/bio.c
index 5eec5e08417f..c8e5d24abd52 100644
=2D-- a/block/bio.c
+++ b/block/bio.c
@@ -1811,6 +1811,45 @@ static inline bool bio_remaining_done(struct bio *bi=
o)
 }
=20
 /**
+ * bio_endio_notrace - end I/O on a bio without tracing
+ * @bio:	bio
+ *
+ * Description:
+ *   bio_endio_notrace() will end I/O on the whole bio.
+ *   bio_endio_notrace() should only be call if a completion trace
+ *   event is not needed.  This can be the case if a request-level
+ *   completion event has already been generated, if the bio is
+ *   being completed early, before it was even queued.
+ *
+ **/
+void bio_endio_notrace(struct bio *bio)
+{
+again:
+	if (!bio_remaining_done(bio))
+		return;
+
+	/*
+	 * Need to have a real endio function for chained bios, otherwise
+	 * various corner cases will break (like stacking block devices that
+	 * save/restore bi_end_io) - however, we want to avoid unbounded
+	 * recursion and blowing the stack. Tail call optimization would
+	 * handle this, but compiling with frame pointers also disables
+	 * gcc's sibling call optimization.
+	 */
+	if (bio->bi_end_io =3D=3D bio_chain_endio) {
+		bio =3D __bio_chain_endio(bio);
+		goto again;
+	}
+
+	if (bio->bi_bdev)
+		trace_block_bio_complete(bdev_get_queue(bio->bi_bdev),
+					 bio, bio->bi_error);
+	if (bio->bi_end_io)
+		bio->bi_end_io(bio);
+}
+EXPORT_SYMBOL(bio_endio_notrace);
+
+/**
  * bio_endio - end I/O on a bio
  * @bio:	bio
  *
@@ -1818,6 +1857,10 @@ static inline bool bio_remaining_done(struct bio *bi=
o)
  *   bio_endio() will end I/O on the whole bio. bio_endio() is the preferr=
ed
  *   way to end I/O on a bio. No one should call bi_end_io() directly on a
  *   bio unless they own it and thus know that it has an end_io function.
+ *
+ *   bio_endio() can be called several times on a bio that has been chained
+ *   using bio_chain().  The ->bi_end_io() function will only be call the
+ *   time.  At this point the BLK_TA_COMPLETE tracing event will be genera=
ted.
  **/
 void bio_endio(struct bio *bio)
 {
@@ -1838,6 +1881,9 @@ void bio_endio(struct bio *bio)
 		goto again;
 	}
=20
+	if (bio->bi_bdev)
+		trace_block_bio_complete(bdev_get_queue(bio->bi_bdev),
+					 bio, bio->bi_error);
 	if (bio->bi_end_io)
 		bio->bi_end_io(bio);
 }
diff --git a/block/blk-core.c b/block/blk-core.c
index 0eeb99ef654f..b6c76580a796 100644
=2D-- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -142,7 +142,7 @@ static void req_bio_endio(struct request *rq, struct bi=
o *bio,
=20
 	/* don't actually finish bio if it's part of flush sequence */
 	if (bio->bi_iter.bi_size =3D=3D 0 && !(rq->rq_flags & RQF_FLUSH_SEQ))
=2D		bio_endio(bio);
+		bio_endio_notrace(bio);
 }
=20
 void blk_dump_rq_flags(struct request *rq, char *msg)
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
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 8e521194f6fc..e0552bee227b 100644
=2D-- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -418,6 +418,7 @@ static inline struct bio *bio_clone_kmalloc(struct bio =
*bio, gfp_t gfp_mask)
 extern blk_qc_t submit_bio(struct bio *);
=20
 extern void bio_endio(struct bio *);
+extern void bio_endio_notrace(struct bio *);
=20
 static inline void bio_io_error(struct bio *bio)
 {
=2D-=20
2.12.0


--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAljTay4ACgkQOeye3VZi
gbnEqBAAtYZEDLU2yESN4HkBMCZ7RaNlVv9RCZO3iLQlJSLXq0yNm7966ObtLGJW
KbBjLbCkR8BGNza3dZwiRSqCCZMtEO2Amh0Xij7yWQZTHDBX3SejYasBF/VS9nbd
Azv/Zm7sh6ZNtpeI85IZ852mo27rS8ZR2PDlLlr8eIkDo8eoUbvfBqJs9aHLWQd1
lZs86x8YeazotysBLCw8W/MN7l5Uk+9N0fBttF3tVVRnOoOL8b6BE6JRkveTQf2N
OaMvTQ/vd4aI3jUmQ9T7o3i06IfHJsucKUIJyNAkBEbOV+9gpq3E0tKFHR0rjSws
/BEYVVrScdj3xZLjWJO5yAPw+2mPVJkrwexazPja3C3Koe7gjZY/lDKQwiZKvjVX
V5oCTw961euyZAUaRdBtoiJKOdU7TXTEFNSYtKGZmIAPljdqhCQqpJlaWiR6xFxC
zZ3l2X8xAGJ2ZgoQ0jRF1szHyrjqkFKjD6jfy2xHcoOuiWxIWtr7Na309yXfIuVk
BpqhrPdPZihKLnO+89dz1/vCdi5ef7e5snxXF477pvMw11Powv5hcO19frOTmhf3
QPW4Sl7K5nyE9M5WVgpmH9JcVG+Fr++lHRcs7dikOoK62nOJIFBQ1CXYFmSBOQcx
xx/Yif4CW+hxU5w4t7YUgm0mSrTqEgH065xYumdmA2qT/7Pt0RE=
=rz07
-----END PGP SIGNATURE-----
--=-=-=--


--===============8506014006343438143==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============8506014006343438143==--
