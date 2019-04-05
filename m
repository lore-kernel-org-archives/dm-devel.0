From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm-integrity: fix deadlock with overlapping I/O
Date: Fri, 5 Apr 2019 15:26:39 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1904051519570.13259@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <msnitzer@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi

I've found quite a serious bug in dm-integrity - it will deadlock when 
processing overlapping bios.

Please send this patch to Linus.

Mikulas



From: Mikulas Patocka <mpatocka@redhat.com>

dm-integrity could deadlock with overlapping I/O, the bug was introduced
by a patch 724376a04d1a ("dm integrity: implement fair range locks").
Apparently, few users use overlapping I/O, so the bug went undetected for
so long.

In order to fix the bug, we fix the typos in the function ranges_overlap
and we remove a flawed ranges_overlap check in remove_range_unlocked. This
condition could leave unprocessed bios hanging on wait_list forever.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org	# v4.19+
Fixes: 724376a04d1a ("dm integrity: implement fair range locks")

---
 drivers/md/dm-integrity.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

Index: linux-2.6/drivers/md/dm-integrity.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-integrity.c	2019-04-05 19:48:13.000000000 +0200
+++ linux-2.6/drivers/md/dm-integrity.c	2019-04-05 20:04:22.000000000 +0200
@@ -878,7 +878,7 @@ static void copy_from_journal(struct dm_
 static bool ranges_overlap(struct dm_integrity_range *range1, struct dm_integrity_range *range2)
 {
 	return range1->logical_sector < range2->logical_sector + range2->n_sectors &&
-	       range2->logical_sector + range2->n_sectors > range2->logical_sector;
+	       range1->logical_sector + range1->n_sectors > range2->logical_sector;
 }
 
 static bool add_new_range(struct dm_integrity_c *ic, struct dm_integrity_range *new_range, bool check_waiting)
@@ -924,8 +924,6 @@ static void remove_range_unlocked(struct
 		struct dm_integrity_range *last_range =
 			list_first_entry(&ic->wait_list, struct dm_integrity_range, wait_entry);
 		struct task_struct *last_range_task;
-		if (!ranges_overlap(range, last_range))
-			break;
 		last_range_task = last_range->task;
 		list_del(&last_range->wait_entry);
 		if (!add_new_range(ic, last_range, false)) {
