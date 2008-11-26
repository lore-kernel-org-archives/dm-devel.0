From: Takahiro Yasui <tyasui@redhat.com>
Subject: [RFC][PATCH 2/4] dm-log: unify rw_header to
	read/write_header
Date: Tue, 25 Nov 2008 19:01:39 -0500
Message-ID: <492C91E3.5020700@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
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
To: dm-devel@redhat.com
Cc: Alasdair G Kergon <agk@redhat.com>, Masami Hiramatsu <mhiramat@redhat.com>
List-Id: dm-devel.ids

rw_header function updates three members of io_req data every time
when I/O is processed. bi_rw and notify.fn are never modified once
they get initialized, and also they can be set in advance.
This patch removes unnecessary update operations.


Signed-off-by: Takahiro Yasui <tyasui@redhat.com>
---
 drivers/md/dm-log.c |   23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

Index: linux-2.6.28-rc4/drivers/md/dm-log.c
===================================================================
--- linux-2.6.28-rc4.orig/drivers/md/dm-log.c
+++ linux-2.6.28-rc4/drivers/md/dm-log.c
@@ -323,20 +323,13 @@ static void header_from_disk(struct log_
 	core->nr_regions = le64_to_cpu(disk->nr_regions);
 }
 
-static int rw_header(struct log_c *lc, int rw)
-{
-	lc->io_req.bi_rw = rw;
-	lc->io_req.mem.ptr.vma = lc->disk_header;
-	lc->io_req.notify.fn = NULL;
-
-	return dm_io(&lc->io_req, 1, &lc->header_location, NULL);
-}
-
 static int read_header(struct log_c *log)
 {
 	int r;
 
-	r = rw_header(log, READ);
+	log->io_req.bi_rw = READ;
+
+	r = dm_io(&log->io_req, 1, &log->header_location, NULL);
 	if (r)
 		return r;
 
@@ -364,8 +357,8 @@ static int read_header(struct log_c *log
 
 static inline int write_header(struct log_c *log)
 {
-	header_to_disk(&log->header, log->disk_header);
-	return rw_header(log, WRITE);
+	log->io_req.bi_rw = WRITE;
+	return dm_io(&log->io_req, 1, &log->header_location, NULL);
 }
 
 /*----------------------------------------------------------------
@@ -454,7 +447,10 @@ static int create_log_context(struct dm_
 		buf_size = dm_round_up((LOG_OFFSET << SECTOR_SHIFT) +
 				       bitset_size, ti->limits.hardsect_size);
 		lc->header_location.count = buf_size >> SECTOR_SHIFT;
+
 		lc->io_req.mem.type = DM_IO_VMA;
+		lc->io_req.mem.ptr.vma = lc->disk_header;
+		lc->io_req.notify.fn = NULL;
 		lc->io_req.client = dm_io_client_create(dm_div_up(buf_size,
 								   PAGE_SIZE));
 		if (IS_ERR(lc->io_req.client)) {
@@ -636,6 +632,9 @@ static int disk_resume(struct dm_dirty_l
 	/* set the correct number of regions in the header */
 	lc->header.nr_regions = lc->region_count;
 
+	/* update disk headers */
+	header_to_disk(&lc->header, lc->disk_header);
+
 	/* write the new header */
 	r = write_header(lc);
 	if (r) {
