From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 7/8] raid1 barriers
Date: Mon, 27 Apr 2009 07:51:23 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0904270751070.18227@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.0904270701250.12459@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904270743540.18227@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904270744220.18227@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904270745190.18227@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904270745510.18227@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904270746210.18227@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904270749300.18227@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904270749570.18227@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904270750430.18227@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0904270750430.18227@hs20-bc2-1.build.redhat.com>
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

Call the flush callback from the log.

If flush failed, we need to mark the whole log as dirty. Also, set variable
flush_failed, which prevents any bits ever being marked as free.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-log.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

Index: linux-2.6.30-rc2-devel/drivers/md/dm-log.c
===================================================================
--- linux-2.6.30-rc2-devel.orig/drivers/md/dm-log.c	2009-04-27 12:48:34.000000000 +0200
+++ linux-2.6.30-rc2-devel/drivers/md/dm-log.c	2009-04-27 12:49:00.000000000 +0200
@@ -679,6 +679,20 @@ static int disk_flush(struct dm_dirty_lo
 	if (!lc->touched_cleaned && !lc->touched_dirtied)
 		return 0;
 
+	if (lc->touched_cleaned && flush) {
+		if (flush(cookie)) {
+			/*
+			 * At this point it is impossible to determine which
+			 * regions are clean and which are dirty. So mark all
+			 * of them dirty.
+			 */
+			int i;
+			lc->flush_failed = 1;
+			for (i = 0; i < lc->region_count; i++)
+				log_clear_bit(lc, lc->clean_bits, i);
+		}
+	}
+
 	r = rw_header(lc, WRITE);
 	if (r)
 		fail_log_device(lc);
