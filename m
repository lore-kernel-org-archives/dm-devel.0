From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 4/8] raid1 barriers
Date: Mon, 27 Apr 2009 07:49:50 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0904270749300.18227@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.0904270701250.12459@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904270743540.18227@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904270744220.18227@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904270745190.18227@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904270745510.18227@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904270746210.18227@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0904270746210.18227@hs20-bc2-1.build.redhat.com>
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
Cc: Heinz Mauelshagen <heinzm@redhat.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Introduce flush_header and use it to flush the log device.

Note that we don't have to flush if all the regions transition
from "dirty" to "clean" state.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-log.c |   22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

Index: linux-2.6.30-rc2-devel/drivers/md/dm-log.c
===================================================================
--- linux-2.6.30-rc2-devel.orig/drivers/md/dm-log.c	2009-04-24 11:06:19.000000000 +0200
+++ linux-2.6.30-rc2-devel/drivers/md/dm-log.c	2009-04-24 11:07:46.000000000 +0200
@@ -288,6 +288,18 @@ static int rw_header(struct log_c *lc, i
 	return dm_io(&lc->io_req, 1, &lc->header_location, NULL);
 }
 
+static int flush_header(struct log_c *lc)
+{
+	struct dm_io_region null_location = {
+		.bdev = lc->header_location.bdev,
+		.sector = 0,
+		.count = 0,
+	};
+	lc->io_req.bi_rw = WRITE_BARRIER;
+
+	return dm_io(&lc->io_req, 1, &null_location, NULL);
+}
+
 static int read_header(struct log_c *log)
 {
 	int r;
@@ -614,6 +626,8 @@ static int disk_resume(struct dm_dirty_l
 
 	/* write the new header */
 	r = rw_header(lc, WRITE);
+	if (!r)
+		r = flush_header(lc);
 	if (r) {
 		DMWARN("%s: Failed to write header on dirty region log device",
 		       lc->log_dev->name);
@@ -667,7 +681,13 @@ static int disk_flush(struct dm_dirty_lo
 	if (r)
 		fail_log_device(lc);
 	else {
-		lc->touched_dirtied = 0;
+		if (lc->touched_dirtied) {
+			r = flush_header(lc);
+			if (r)
+				fail_log_device(lc);
+			else
+				lc->touched_dirtied = 0;
+		}
 		lc->touched_cleaned = 0;
 	}
 
