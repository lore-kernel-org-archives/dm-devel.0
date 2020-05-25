From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 02/16] drbd: use bio_{start,end}_io_acct
Date: Mon, 25 May 2020 13:30:00 +0200
Message-ID: <20200525113014.345997-3-hch@lst.de>
References: <20200525113014.345997-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
In-Reply-To: <20200525113014.345997-1-hch@lst.de>
Sender: linux-bcache-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>, dm-devel@redhat.com, linux-block@vger.kernel.org, drbd-dev@lists.linbit.com, linux-bcache@vger.kernel.org, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

Switch drbd to use the nicer bio accounting helpers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/block/drbd/drbd_req.c | 27 ++++-----------------------
 1 file changed, 4 insertions(+), 23 deletions(-)

diff --git a/drivers/block/drbd/drbd_req.c b/drivers/block/drbd/drbd_req.c
index 840c3aef3c5c9..c80a2f1c3c2a7 100644
--- a/drivers/block/drbd/drbd_req.c
+++ b/drivers/block/drbd/drbd_req.c
@@ -21,24 +21,6 @@
 
 static bool drbd_may_do_local_read(struct drbd_device *device, sector_t sector, int size);
 
-/* Update disk stats at start of I/O request */
-static void _drbd_start_io_acct(struct drbd_device *device, struct drbd_request *req)
-{
-	struct request_queue *q = device->rq_queue;
-
-	generic_start_io_acct(q, bio_op(req->master_bio),
-				req->i.size >> 9, &device->vdisk->part0);
-}
-
-/* Update disk stats when completing request upwards */
-static void _drbd_end_io_acct(struct drbd_device *device, struct drbd_request *req)
-{
-	struct request_queue *q = device->rq_queue;
-
-	generic_end_io_acct(q, bio_op(req->master_bio),
-			    &device->vdisk->part0, req->start_jif);
-}
-
 static struct drbd_request *drbd_req_new(struct drbd_device *device, struct bio *bio_src)
 {
 	struct drbd_request *req;
@@ -263,7 +245,7 @@ void drbd_req_complete(struct drbd_request *req, struct bio_and_error *m)
 		start_new_tl_epoch(first_peer_device(device)->connection);
 
 	/* Update disk stats */
-	_drbd_end_io_acct(device, req);
+	bio_end_io_acct(req->master_bio, req->start_jif);
 
 	/* If READ failed,
 	 * have it be pushed back to the retry work queue,
@@ -1222,16 +1204,15 @@ drbd_request_prepare(struct drbd_device *device, struct bio *bio, unsigned long
 		bio_endio(bio);
 		return ERR_PTR(-ENOMEM);
 	}
-	req->start_jif = start_jif;
+
+	/* Update disk stats */
+	req->start_jif = bio_start_io_acct(req->master_bio);
 
 	if (!get_ldev(device)) {
 		bio_put(req->private_bio);
 		req->private_bio = NULL;
 	}
 
-	/* Update disk stats */
-	_drbd_start_io_acct(device, req);
-
 	/* process discards always from our submitter thread */
 	if (bio_op(bio) == REQ_OP_WRITE_ZEROES ||
 	    bio_op(bio) == REQ_OP_DISCARD)
-- 
2.26.2
