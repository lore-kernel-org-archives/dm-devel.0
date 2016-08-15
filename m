From: Ram Pai <linuxram@us.ibm.com>
Subject: [RFC PATCH 13/16] DM: macros to set and get the state of the request.
Date: Mon, 15 Aug 2016 10:36:50 -0700
Message-ID: <1471282613-31006-14-git-send-email-linuxram@us.ibm.com>
References: <1471282613-31006-1-git-send-email-linuxram@us.ibm.com>
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <1471282613-31006-1-git-send-email-linuxram@us.ibm.com>
Sender: linux-doc-owner@vger.kernel.org
To: LKML <linux-kernel@vger.kernel.org>, linux-raid@vger.kernel.org, dm-devel@redhat.com, linux-doc@vger.kernel.org
Cc: shli@kernel.org, agk@redhat.com, snitzer@redhat.com, corbet@lwn.net, Ram Pai <linuxram@us.ibm.com>
List-Id: dm-devel.ids

Consolidate code to set and get the state of a request.

Signed-off-by: Ram Pai <linuxram@us.ibm.com>
---
 drivers/md/dm-inplace-compress.c |   31 +++++++++++++++++--------------
 1 files changed, 17 insertions(+), 14 deletions(-)

diff --git a/drivers/md/dm-inplace-compress.c b/drivers/md/dm-inplace-compress.c
index b1c3e5f..55a515b 100644
--- a/drivers/md/dm-inplace-compress.c
+++ b/drivers/md/dm-inplace-compress.c
@@ -44,6 +44,9 @@ static struct kernel_param_ops dm_icomp_compressor_param_ops = {
 module_param_cb(compress_algorithm, &dm_icomp_compressor_param_ops,
 		&dm_icomp_compressor_kparam, 0644);
 
+#define SET_REQ_STAGE(req, value) (req->stage = value)
+#define GET_REQ_STAGE(req) req->stage
+
 static int dm_icomp_get_compressor(const char *s)
 {
 	int r, val_len;
@@ -835,15 +838,15 @@ static void dm_icomp_put_req(struct dm_icomp_req *req)
 	if (atomic_dec_return(&req->io_pending))
 		return;
 
-	if (req->stage == STAGE_INIT) /* waiting for locking */
+	if (GET_REQ_STAGE(req) == STAGE_INIT) /* waiting for locking */
 		return;
 
-	if (req->stage == STAGE_READ_DECOMP ||
-	    req->stage == STAGE_WRITE_COMP ||
+	if (GET_REQ_STAGE(req) == STAGE_READ_DECOMP ||
+	    GET_REQ_STAGE(req) == STAGE_WRITE_COMP ||
 	    req->result)
-		req->stage = STAGE_DONE;
+		SET_REQ_STAGE(req, STAGE_DONE);
 
-	if (req->stage != STAGE_DONE) {
+	if (GET_REQ_STAGE(req) != STAGE_DONE) {
 		dm_icomp_queue_req(req->info, req);
 		return;
 	}
@@ -1153,7 +1156,7 @@ static void dm_icomp_handle_read_decomp(struct dm_icomp_req *req)
 	off_t bio_off = 0;
 	int ret;
 
-	req->stage = STAGE_READ_DECOMP;
+	SET_REQ_STAGE(req, STAGE_READ_DECOMP);
 
 	if (req->result)
 		return;
@@ -1250,7 +1253,7 @@ static void dm_icomp_handle_read_read_existing(struct dm_icomp_req *req)
 	u64 block_index, first_block_index;
 	u16 logical_sectors, data_sectors;
 
-	req->stage = STAGE_READ_EXISTING;
+	SET_REQ_STAGE(req, STAGE_READ_EXISTING);
 
 	block_index = dm_icomp_sector_to_block(req->bio->bi_iter.bi_sector);
 again:
@@ -1279,14 +1282,14 @@ static void dm_icomp_handle_read_request(struct dm_icomp_req *req)
 {
 	dm_icomp_get_req(req);
 
-	if (req->stage == STAGE_INIT) {
+	if (GET_REQ_STAGE(req) == STAGE_INIT) {
 		if (!dm_icomp_lock_req_range(req)) {
 			dm_icomp_put_req(req);
 			return;
 		}
 
 		dm_icomp_handle_read_read_existing(req);
-	} else if (req->stage == STAGE_READ_EXISTING)
+	} else if (GET_REQ_STAGE(req) == STAGE_READ_EXISTING)
 		dm_icomp_handle_read_decomp(req);
 
 	dm_icomp_put_req(req);
@@ -1411,7 +1414,7 @@ static void dm_icomp_handle_write_comp(struct dm_icomp_req *req)
 	int ret;
 	bool handle_bio = true;
 
-	req->stage = STAGE_WRITE_COMP;
+	SET_REQ_STAGE(req, STAGE_WRITE_COMP);
 
 	if (req->result)
 		return;
@@ -1486,7 +1489,7 @@ static void dm_icomp_handle_write_read_existing(struct dm_icomp_req *req)
 	u64 block_index, first_block_index;
 	u16 logical_sectors, data_sectors;
 
-	req->stage = STAGE_READ_EXISTING;
+	SET_REQ_STAGE(req, STAGE_READ_EXISTING);
 
 	block_index = dm_icomp_sector_to_block(req->bio->bi_iter.bi_sector);
 	dm_icomp_get_extent(req->info, block_index, &first_block_index,
@@ -1524,14 +1527,14 @@ static void dm_icomp_handle_write_request(struct dm_icomp_req *req)
 {
 	dm_icomp_get_req(req);
 
-	if (req->stage == STAGE_INIT) {
+	if (GET_REQ_STAGE(req) == STAGE_INIT) {
 		if (!dm_icomp_lock_req_range(req)) {
 			dm_icomp_put_req(req);
 			return;
 		}
 
 		dm_icomp_handle_write_read_existing(req);
-	} else if (req->stage == STAGE_READ_EXISTING)
+	} else if (GET_REQ_STAGE(req) == STAGE_READ_EXISTING)
 		dm_icomp_handle_write_comp(req);
 
 	dm_icomp_put_req(req);
@@ -1611,7 +1614,7 @@ static int dm_icomp_map(struct dm_target *ti, struct bio *bio)
 	atomic_set(&req->io_pending, 0);
 	INIT_LIST_HEAD(&req->all_io);
 	req->result = 0;
-	req->stage = STAGE_INIT;
+	SET_REQ_STAGE(req, STAGE_INIT);
 	req->locked_locks = 0;
 
 	req->cpu = raw_smp_processor_id();
-- 
1.7.1

