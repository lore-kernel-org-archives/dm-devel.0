From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 7/7] drivers: use block_device name vsprintf
	helper
Date: Tue, 31 Mar 2015 20:01:21 +0400
Message-ID: <1427817681-4494-8-git-send-email-dmonakhov@openvz.org>
References: <1427817681-4494-1-git-send-email-dmonakhov@openvz.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1427817681-4494-1-git-send-email-dmonakhov@openvz.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, axboe@kernel.dk, dm-devel@redhat.com, Dmitry Monakhov <dmonakhov@openvz.org>, viro@zeniv.linux.org.uk
List-Id: dm-devel.ids


Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 drivers/block/drbd/drbd_req.c       |    6 ++----
 drivers/block/pktcdvd.c             |   14 ++++----------
 drivers/scsi/wd7000.c               |    6 +-----
 drivers/target/target_core_iblock.c |    4 +---
 4 files changed, 8 insertions(+), 22 deletions(-)

diff --git a/drivers/block/drbd/drbd_req.c b/drivers/block/drbd/drbd_req.c
index 34f2f0b..1c268ba 100644
--- a/drivers/block/drbd/drbd_req.c
+++ b/drivers/block/drbd/drbd_req.c
@@ -536,16 +536,14 @@ static void mod_rq_state(struct drbd_request *req, struct bio_and_error *m,
 
 static void drbd_report_io_error(struct drbd_device *device, struct drbd_request *req)
 {
-        char b[BDEVNAME_SIZE];
-
 	if (!__ratelimit(&drbd_ratelimit_state))
 		return;
 
-	drbd_warn(device, "local %s IO error sector %llu+%u on %s\n",
+	drbd_warn(device, "local %s IO error sector %llu+%u on %pg\n",
 			(req->rq_state & RQ_WRITE) ? "WRITE" : "READ",
 			(unsigned long long)req->i.sector,
 			req->i.size >> 9,
-			bdevname(device->ldev->backing_bdev, b));
+			device->ldev->backing_bdev);
 }
 
 /* Helper for HANDED_OVER_TO_NETWORK.
diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
index 09e628d..024beca 100644
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -2443,13 +2443,11 @@ static void pkt_make_request_write(struct request_queue *q, struct bio *bio)
 static void pkt_make_request(struct request_queue *q, struct bio *bio)
 {
 	struct pktcdvd_device *pd;
-	char b[BDEVNAME_SIZE];
 	struct bio *split;
 
 	pd = q->queuedata;
 	if (!pd) {
-		pr_err("%s incorrect request queue\n",
-		       bdevname(bio->bi_bdev, b));
+		pr_err("%pg incorrect request queue\n", bio->bi_bdev);
 		goto end_io;
 	}
 
@@ -2538,11 +2536,9 @@ static int pkt_seq_show(struct seq_file *m, void *p)
 {
 	struct pktcdvd_device *pd = m->private;
 	char *msg;
-	char bdev_buf[BDEVNAME_SIZE];
 	int states[PACKET_NUM_STATES];
 
-	seq_printf(m, "Writer %s mapped to %s:\n", pd->name,
-		   bdevname(pd->bdev, bdev_buf));
+	seq_printf(m, "Writer %s mapped to %pg:\n", pd->name, pd->bdev);
 
 	seq_printf(m, "\nSettings:\n");
 	seq_printf(m, "\tpacket size:\t\t%dkB\n", pd->settings.size / 2);
@@ -2612,7 +2608,6 @@ static int pkt_new_dev(struct pktcdvd_device *pd, dev_t dev)
 {
 	int i;
 	int ret = 0;
-	char b[BDEVNAME_SIZE];
 	struct block_device *bdev;
 
 	if (pd->pkt_dev == dev) {
@@ -2624,8 +2619,7 @@ static int pkt_new_dev(struct pktcdvd_device *pd, dev_t dev)
 		if (!pd2)
 			continue;
 		if (pd2->bdev->bd_dev == dev) {
-			pkt_err(pd, "%s already setup\n",
-				bdevname(pd2->bdev, b));
+			pkt_err(pd, "%pg already setup\n", pd2->bdev);
 			return -EBUSY;
 		}
 		if (pd2->pkt_dev == dev) {
@@ -2658,7 +2652,7 @@ static int pkt_new_dev(struct pktcdvd_device *pd, dev_t dev)
 	}
 
 	proc_create_data(pd->name, 0, pkt_proc, &pkt_proc_fops, pd);
-	pkt_dbg(1, pd, "writer mapped to %s\n", bdevname(bdev, b));
+	pkt_dbg(1, pd, "writer mapped to %pg\n", bdev);
 	return 0;
 
 out_mem:
diff --git a/drivers/scsi/wd7000.c b/drivers/scsi/wd7000.c
index 0c0f17b..eb01bf3 100644
--- a/drivers/scsi/wd7000.c
+++ b/drivers/scsi/wd7000.c
@@ -1589,11 +1589,7 @@ static int wd7000_host_reset(struct scsi_cmnd *SCpnt)
 static int wd7000_biosparam(struct scsi_device *sdev,
 		struct block_device *bdev, sector_t capacity, int *ip)
 {
-	char b[BDEVNAME_SIZE];
-
-	dprintk("wd7000_biosparam: dev=%s, size=%d, ",
-		bdevname(bdev, b), capacity);
-	(void)b;	/* unused var warning? */
+	dprintk("wd7000_biosparam: dev=%pg, size=%d, ", bdev, capacity);
 
 	/*
 	 * try default translation
diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index d4a4b0f..da4d157 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -602,12 +602,10 @@ static ssize_t iblock_show_configfs_dev_params(struct se_device *dev, char *b)
 {
 	struct iblock_dev *ib_dev = IBLOCK_DEV(dev);
 	struct block_device *bd = ib_dev->ibd_bd;
-	char buf[BDEVNAME_SIZE];
 	ssize_t bl = 0;
 
 	if (bd)
-		bl += sprintf(b + bl, "iBlock device: %s",
-				bdevname(bd, buf));
+		bl += sprintf(b + bl, "iBlock device: %pg", bd);
 	if (ib_dev->ibd_flags & IBDF_HAS_UDEV_PATH)
 		bl += sprintf(b + bl, "  UDEV PATH: %s",
 				ib_dev->ibd_udev_path);
-- 
1.7.1
