From: Alasdair G Kergon <agk@redhat.com>
Subject: [PATCH 11/11] dm: raid1: reset sync_search on resume
Date: Wed, 22 Nov 2006 19:05:22 +0000
Message-ID: <20061122190522.GB6993@agk.surrey.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Andrew Morton <akpm@osdl.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

From: Jonathan E Brassow <jbrassow@redhat.com>

Reset sync_search on resume.
The effect is to retry syncing all out-of-sync regions when a mirror is resumed,
including ones that previously failed.

Signed-off-by: Jonathan E Brassow <jbrassow@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com

Index: linux-2.6.19-rc6/drivers/md/dm-log.c
===================================================================
--- linux-2.6.19-rc6.orig/drivers/md/dm-log.c	2006-11-22 17:27:01.000000000 +0000
+++ linux-2.6.19-rc6/drivers/md/dm-log.c	2006-11-22 17:27:02.000000000 +0000
@@ -466,6 +466,7 @@ static int disk_resume(struct dirty_log 
 	/* copy clean across to sync */
 	memcpy(lc->sync_bits, lc->clean_bits, size);
 	lc->sync_count = count_bits32(lc->clean_bits, lc->bitset_uint32_count);
+	lc->sync_search = 0;
 
 	/* set the correct number of regions in the header */
 	lc->header.nr_regions = lc->region_count;
@@ -480,6 +481,13 @@ static uint32_t core_get_region_size(str
 	return lc->region_size;
 }
 
+static int core_resume(struct dirty_log *log)
+{
+	struct log_c *lc = (struct log_c *) log->context;
+	lc->sync_search = 0;
+	return 0;
+}
+
 static int core_is_clean(struct dirty_log *log, region_t region)
 {
 	struct log_c *lc = (struct log_c *) log->context;
@@ -621,6 +629,7 @@ static struct dirty_log_type _core_type 
 	.module = THIS_MODULE,
 	.ctr = core_ctr,
 	.dtr = core_dtr,
+	.resume = core_resume,
 	.get_region_size = core_get_region_size,
 	.is_clean = core_is_clean,
 	.in_sync = core_in_sync,
