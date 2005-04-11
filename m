From: Lars Marowsky-Bree <lmb@suse.de>
Subject: [PATCH] Use SCSI sense data in dm-mpath bio-end_io if
	available
Date: Mon, 11 Apr 2005 14:38:00 +0200
Message-ID: <20050411123800.GL12752@marowsky-bree.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0964758115=="
Return-path: <dm-devel-bounces@redhat.com>
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


--===============0964758115==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="k3qmt+ucFURmlhDS"
Content-Disposition: inline


--k3qmt+ucFURmlhDS
Content-Type: multipart/mixed; boundary="VMt1DrMGOVs3KQwf"
Content-Disposition: inline


--VMt1DrMGOVs3KQwf
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Good morning Alasdair & list,

the attached two patches enable SCSI sense data to be available in the
bio-end_io path and use it in dm-mpath's hwhandler as well as dm-emc.c.

Please test and let us know the results.


Sincerely,
    Lars Marowsky-Br=E9e <lmb@suse.de>

--=20
High Availability & Clustering
SUSE Labs, Research and Development
SUSE LINUX Products GmbH - A Novell Business


--VMt1DrMGOVs3KQwf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=bio-end_io-sense
Content-Transfer-Encoding: quoted-printable

=46rom: Jens Axboe <axboe@suse.de>
Subject: Make SCSI sense data available in bio end_io path
Patch-mainline: 2.6.13
References: 62498

Make the sense data available in the bio end_io path on request.


Signed-off-by: Lars Marowsky-Bree <lmb@suse.de>
Signed-off-by: Jens Axboe <axboe@suse.de>

diff -urp -X /home/axboe/cdrom/exclude /opt/kernel/linux-2.6.5/drivers/bloc=
k/ll_rw_blk.c linux-2.6.5/drivers/block/ll_rw_blk.c
--- /opt/kernel/linux-2.6.5/drivers/block/ll_rw_blk.c	2005-04-01 09:41:07.0=
00000000 +0200
+++ linux-2.6.5/drivers/block/ll_rw_blk.c	2005-04-01 10:11:43.000000000 +02=
00
@@ -28,6 +28,7 @@
 #include <linux/slab.h>
 #include <linux/swap.h>
 #include <linux/writeback.h>
+#include <linux/cdrom.h>
=20
 /*
  * for max sense size
@@ -2989,6 +2990,7 @@ static int __end_that_request_first(stru
 				    int nr_bytes)
 {
 	int total_bytes, bio_nbytes, error, next_idx =3D 0;
+	struct request_sense *s =3D NULL;
 	struct bio *bio;
=20
 	/*
@@ -2998,6 +3000,12 @@ static int __end_that_request_first(stru
 	if (end_io_error(uptodate))
 		error =3D !uptodate ? -EIO : uptodate;
=20
+	if (req->sense && req->sense_len) {
+		s =3D req->sense;
+		if (!s->valid)
+			s =3D NULL;
+	}
+
 	/*
 	 * for a REQ_BLOCK_PC request, we want to carry any eventual
 	 * sense key with us all the way through
@@ -3023,6 +3031,9 @@ static int __end_that_request_first(stru
 	while ((bio =3D req->bio)) {
 		int nbytes;
=20
+		if (s)
+			bio_set_sense(bio, s->sense_key, s->asc, s->ascq);
+
 		if (nr_bytes >=3D bio->bi_size) {
 			req->bio =3D bio->bi_next;
 			nbytes =3D bio->bi_size;
diff -urp -X /home/axboe/cdrom/exclude /opt/kernel/linux-2.6.5/drivers/scsi=
/scsi_lib.c linux-2.6.5/drivers/scsi/scsi_lib.c
--- /opt/kernel/linux-2.6.5/drivers/scsi/scsi_lib.c	2005-04-01 09:41:06.000=
000000 +0200
+++ linux-2.6.5/drivers/scsi/scsi_lib.c	2005-04-01 10:51:20.000000000 +0200
@@ -517,9 +517,21 @@ static struct scsi_cmnd *scsi_end_reques
 {
 	request_queue_t *q =3D cmd->device->request_queue;
 	struct request *req =3D cmd->request;
+	int sense_override =3D 0;
 	unsigned long flags;
=20
 	/*
+	 * if room for sense wasn't supplied for this request, override with
+	 * what we have stored for the duration of the end_io handling. this
+	 * allows passing of sense to the block layer.
+	 */
+	if (!req->sense && (cmd->sense_buffer[0] & 0x70)) {
+		req->sense =3D cmd->sense_buffer;
+		req->sense_len =3D 8 + cmd->sense_buffer[7];
+		sense_override =3D 1;
+	}
+
+	/*
 	 * If there are blocks left over at the end, set up the command
 	 * to queue the remainder of them.
 	 */
@@ -545,6 +557,9 @@ static struct scsi_cmnd *scsi_end_reques
 		}
 	}
=20
+	if (sense_override)
+		req->sense =3D NULL;
+
 	add_disk_randomness(req->rq_disk);
=20
 	spin_lock_irqsave(q->queue_lock, flags);
diff -urp -X /home/axboe/cdrom/exclude /opt/kernel/linux-2.6.5/fs/bio.c lin=
ux-2.6.5/fs/bio.c
--- /opt/kernel/linux-2.6.5/fs/bio.c	2005-04-01 09:41:14.000000000 +0200
+++ linux-2.6.5/fs/bio.c	2005-04-01 10:54:16.000000000 +0200
@@ -108,6 +108,7 @@ inline void bio_init(struct bio *bio)
 	bio->bi_bdev =3D NULL;
 	bio->bi_flags =3D 1 << BIO_UPTODATE;
 	bio->bi_rw =3D 0;
+	bio->bi_error =3D 0;
 	bio->bi_vcnt =3D 0;
 	bio->bi_idx =3D 0;
 	bio->bi_phys_segments =3D 0;
diff -urp -X /home/axboe/cdrom/exclude /opt/kernel/linux-2.6.5/include/linu=
x/bio.h linux-2.6.5/include/linux/bio.h
--- /opt/kernel/linux-2.6.5/include/linux/bio.h	2005-04-01 09:41:08.0000000=
00 +0200
+++ linux-2.6.5/include/linux/bio.h	2005-04-01 10:14:54.000000000 +0200
@@ -66,6 +66,7 @@ struct bio {
 	unsigned long		bi_rw;		/* bottom bits READ/WRITE,
 						 * top bits priority
 						 */
+	unsigned int		bi_error;	/* -Exx or sense */
=20
 	unsigned short		bi_vcnt;	/* how many bio_vec's */
 	unsigned short		bi_idx;		/* current index into bvl_vec */
@@ -211,6 +212,23 @@ struct bio {
  */
 #define bio_get(bio)	atomic_inc(&(bio)->bi_cnt)
=20
+enum {
+	BIO_ERROR_ERRNO =3D 1,
+	BIO_ERROR_SENSE,
+};
+
+/*
+ * Extended error reporting. The upper 8 bits are flag values, the bottom
+ * 24 can be used for extended errors (such as sense).
+ */
+static inline void bio_set_sense(struct bio *bio, char key, char asc, char=
 ascq)
+{
+	bio->bi_error =3D (BIO_ERROR_SENSE << 24) | (key << 16) | (asc << 8) | as=
cq;
+}
+
+#define bio_errno_valid(bio)	((bio)->bi_error & (BIO_ERROR_ERRNO << 24))
+#define bio_sense_valid(bio)	((bio)->bi_error & (BIO_ERROR_SENSE << 24))
+#define bio_sense_value(bio)	((bio)->bi_error & 0xffffff)
=20
 /*
  * A bio_pair is used when we need to split a bio.


--VMt1DrMGOVs3KQwf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=dm-mp-bio-end_io-sense
Content-Transfer-Encoding: quoted-printable

=46rom: Lars Marowsky-Bree <lmb@suse.de>
Subject: Use SCSI sense data in dm-mpath bio end_io path
Patch-mainline: 2.6.13
Suse-bugzilla: 62498

Use the sense data in the dm-mpath hardware handlers.

Signed-off-by: Jens Axboe <axboe@suse.de>

Index: linux-2.6.5/drivers/md/dm-emc.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.5.orig/drivers/md/dm-emc.c	2005-04-11 13:59:37.825222738 +0200
+++ linux-2.6.5/drivers/md/dm-emc.c	2005-04-11 14:14:04.772636876 +0200
@@ -290,12 +290,10 @@ static void emc_dtr(struct hw_handler *h
=20
 static unsigned emc_err(struct hw_handler *hwh, struct bio *bio)
 {
-	/* FIXME: Patch from axboe still missing */
-#if 0
 	int sense;
=20
-	if (bio->bi_error & BIO_SENSE) {
-		sense =3D bio->bi_error & 0xffffff; /* sense key / asc / ascq */
+	if (bio_sense_valid(bio)) {
+		sense =3D bio_sense_value(bio); /* sense key / asc / ascq */
=20
 		if (sense =3D=3D 0x020403) {
 			/* LUN Not Ready - Manual Intervention Required
@@ -306,21 +304,20 @@ static unsigned emc_err(struct hw_handle
 			 * progress, we should set FAIL_PATH too.
 			 * This indicates we might have to do a SCSI
 			 * inquiry in the end_io path. Ugh. */
-			return MP_BYPASS_PG | MP_RETRY_IO;
+			return MP_BYPASS_PG;
 		} else if (sense =3D=3D 0x052501) {
 			/* An array based copy is in progress. Do not
 			 * fail the path, do not bypass to another PG,
 			 * do not retry. Fail the IO immediately.
 			 * (Actually this is the same conclusion as in
 			 * the default handler, but lets make sure.) */
-			return 0;
+			return MP_ERROR_IO;
 		} else if (sense =3D=3D 0x062900) {
 			/* Unit Attention Code. This is the first IO=20
 			 * to the new path, so just retry. */
-			return MP_RETRY_IO;
+			return 0;
 		}
 	}
-#endif
=20
 	/* Try default handler */
 	return dm_scsi_err_handler(hwh, bio);
Index: linux-2.6.5/drivers/md/dm-hw-handler.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.5.orig/drivers/md/dm-hw-handler.c	2005-04-11 13:59:37.8052257=
04 +0200
+++ linux-2.6.5/drivers/md/dm-hw-handler.c	2005-04-11 14:14:49.225050588 +0=
200
@@ -153,13 +153,12 @@ unsigned dm_scsi_err_handler(struct hw_h
 {
 	int sense_key, asc, ascq;
=20
-#if 0
-	if (bio->bi_error & BIO_SENSE) {
+	if (bio_sense_valid(bio)) {
 		/* FIXME: This is just an initial guess. */
 		/* key / asc / ascq */
-		sense_key =3D (bio->bi_error >> 16) & 0xff;
-		asc =3D (bio->bi_error >> 8) & 0xff;
-		ascq =3D bio->bi_error & 0xff;
+		sense_key =3D (bio_sense_value(bio) >> 16) & 0xff;
+		asc =3D (bio_sense_value(bio) >> 8) & 0xff;
+		ascq =3D bio_sense_value(bio) & 0xff;
=20
 		switch (sense_key) {
 			/* This block as a whole comes from the device.
@@ -204,7 +203,6 @@ unsigned dm_scsi_err_handler(struct hw_h
 			return 0;
 		}
 	}
-#endif
=20
 	/* We got no idea how to decode the other kinds of errors ->
 	 * assume generic error condition. */

--VMt1DrMGOVs3KQwf--

--k3qmt+ucFURmlhDS
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFCWm+oudf3XQV4S2cRAkTkAJ9lpVRw0I7sLpElRHaGIoLnfi+7AACfWxqh
7phg+6ZHk2I3DHXfAdHG4NU=
=wLeL
-----END PGP SIGNATURE-----

--k3qmt+ucFURmlhDS--


--===============0964758115==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0964758115==--
