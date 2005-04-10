From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: Question on dm-mp sense handling
Date: Sun, 10 Apr 2005 21:11:14 +0200
Message-ID: <20050410191114.GL12752@marowsky-bree.de>
References: <20050224020749.GA669@us.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="IJpNTDwzlM2Ie8A6"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20050224020749.GA669@us.ibm.com>
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


--IJpNTDwzlM2Ie8A6
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2005-02-23T18:07:49, Mike Anderson <andmike@us.ibm.com> wrote:

> Is someone still working on the sense buffer handling code for bios
> to be used by dm-mp?

Yes. Jens sent me this patch last week. Woho ;-) It applies against
2.6.5, as this is our main current target for development.

I'll resync our tree against -udm tomorrow and then fix dm-mp in our
kernel up tomorrow and Tuesday to work with it, and then send new
patches up to Alasdair.


Sincerely,
    Lars Marowsky-Br=E9e <lmb@suse.de>

--=20
High Availability & Clustering
SUSE Labs, Research and Development
SUSE LINUX Products GmbH - A Novell Business


--IJpNTDwzlM2Ie8A6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=bio-end_io-sense

From: Jens Axboe <axboe@suse.de>
Subject: Make SCSI sense data available in bio end_io path
Patch-mainline: 2.6.13
References: 62498

Make the sense data available in the bio end_io path on request.


Signed-off-by: Lars Marowsky-Bree <lmb@suse.de>
Signed-off-by: Jens Axboe <axboe@suse.de>

diff -urp -X /home/axboe/cdrom/exclude /opt/kernel/linux-2.6.5/drivers/block/ll_rw_blk.c linux-2.6.5/drivers/block/ll_rw_blk.c
--- /opt/kernel/linux-2.6.5/drivers/block/ll_rw_blk.c	2005-04-01 09:41:07.000000000 +0200
+++ linux-2.6.5/drivers/block/ll_rw_blk.c	2005-04-01 10:11:43.000000000 +0200
@@ -28,6 +28,7 @@
 #include <linux/slab.h>
 #include <linux/swap.h>
 #include <linux/writeback.h>
+#include <linux/cdrom.h>
 
 /*
  * for max sense size
@@ -2989,6 +2990,7 @@ static int __end_that_request_first(stru
 				    int nr_bytes)
 {
 	int total_bytes, bio_nbytes, error, next_idx = 0;
+	struct request_sense *s = NULL;
 	struct bio *bio;
 
 	/*
@@ -2998,6 +3000,12 @@ static int __end_that_request_first(stru
 	if (end_io_error(uptodate))
 		error = !uptodate ? -EIO : uptodate;
 
+	if (req->sense && req->sense_len) {
+		s = req->sense;
+		if (!s->valid)
+			s = NULL;
+	}
+
 	/*
 	 * for a REQ_BLOCK_PC request, we want to carry any eventual
 	 * sense key with us all the way through
@@ -3023,6 +3031,9 @@ static int __end_that_request_first(stru
 	while ((bio = req->bio)) {
 		int nbytes;
 
+		if (s)
+			bio_set_sense(bio, s->sense_key, s->asc, s->ascq);
+
 		if (nr_bytes >= bio->bi_size) {
 			req->bio = bio->bi_next;
 			nbytes = bio->bi_size;
diff -urp -X /home/axboe/cdrom/exclude /opt/kernel/linux-2.6.5/drivers/scsi/scsi_lib.c linux-2.6.5/drivers/scsi/scsi_lib.c
--- /opt/kernel/linux-2.6.5/drivers/scsi/scsi_lib.c	2005-04-01 09:41:06.000000000 +0200
+++ linux-2.6.5/drivers/scsi/scsi_lib.c	2005-04-01 10:51:20.000000000 +0200
@@ -517,9 +517,21 @@ static struct scsi_cmnd *scsi_end_reques
 {
 	request_queue_t *q = cmd->device->request_queue;
 	struct request *req = cmd->request;
+	int sense_override = 0;
 	unsigned long flags;
 
 	/*
+	 * if room for sense wasn't supplied for this request, override with
+	 * what we have stored for the duration of the end_io handling. this
+	 * allows passing of sense to the block layer.
+	 */
+	if (!req->sense && (cmd->sense_buffer[0] & 0x70)) {
+		req->sense = cmd->sense_buffer;
+		req->sense_len = 8 + cmd->sense_buffer[7];
+		sense_override = 1;
+	}
+
+	/*
 	 * If there are blocks left over at the end, set up the command
 	 * to queue the remainder of them.
 	 */
@@ -545,6 +557,9 @@ static struct scsi_cmnd *scsi_end_reques
 		}
 	}
 
+	if (sense_override)
+		req->sense = NULL;
+
 	add_disk_randomness(req->rq_disk);
 
 	spin_lock_irqsave(q->queue_lock, flags);
diff -urp -X /home/axboe/cdrom/exclude /opt/kernel/linux-2.6.5/fs/bio.c linux-2.6.5/fs/bio.c
--- /opt/kernel/linux-2.6.5/fs/bio.c	2005-04-01 09:41:14.000000000 +0200
+++ linux-2.6.5/fs/bio.c	2005-04-01 10:54:16.000000000 +0200
@@ -108,6 +108,7 @@ inline void bio_init(struct bio *bio)
 	bio->bi_bdev = NULL;
 	bio->bi_flags = 1 << BIO_UPTODATE;
 	bio->bi_rw = 0;
+	bio->bi_error = 0;
 	bio->bi_vcnt = 0;
 	bio->bi_idx = 0;
 	bio->bi_phys_segments = 0;
diff -urp -X /home/axboe/cdrom/exclude /opt/kernel/linux-2.6.5/include/linux/bio.h linux-2.6.5/include/linux/bio.h
--- /opt/kernel/linux-2.6.5/include/linux/bio.h	2005-04-01 09:41:08.000000000 +0200
+++ linux-2.6.5/include/linux/bio.h	2005-04-01 10:14:54.000000000 +0200
@@ -66,6 +66,7 @@ struct bio {
 	unsigned long		bi_rw;		/* bottom bits READ/WRITE,
 						 * top bits priority
 						 */
+	unsigned int		bi_error;	/* -Exx or sense */
 
 	unsigned short		bi_vcnt;	/* how many bio_vec's */
 	unsigned short		bi_idx;		/* current index into bvl_vec */
@@ -211,6 +212,23 @@ struct bio {
  */
 #define bio_get(bio)	atomic_inc(&(bio)->bi_cnt)
 
+enum {
+	BIO_ERROR_ERRNO = 1,
+	BIO_ERROR_SENSE,
+};
+
+/*
+ * Extended error reporting. The upper 8 bits are flag values, the bottom
+ * 24 can be used for extended errors (such as sense).
+ */
+static inline void bio_set_sense(struct bio *bio, char key, char asc, char ascq)
+{
+	bio->bi_error = (BIO_ERROR_SENSE << 24) | (key << 16) | (asc << 8) | ascq;
+}
+
+#define bio_errno_valid(bio)	((bio)->bi_error & (BIO_ERROR_ERRNO << 24))
+#define bio_sense_valid(bio)	((bio)->bi_error & (BIO_ERROR_SENSE << 24))
+#define bio_sense_value(bio)	((bio)->bi_error & 0xffffff)
 
 /*
  * A bio_pair is used when we need to split a bio.


--IJpNTDwzlM2Ie8A6
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--IJpNTDwzlM2Ie8A6--
