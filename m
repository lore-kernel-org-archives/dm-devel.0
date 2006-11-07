From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [Patch 2 of 14] Device Mapper Mirror
Date: Tue, 07 Nov 2006 10:00:04 -0600
Message-ID: <1162915205.17899.38.camel@hydrogen.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
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
Cc: heinzm@redhat.com, agk@redhat.com
List-Id: dm-devel.ids

 brassow

Reset sync_search on resume.  The effect of this patch is to check
over the log bitmap when a mirror is resumed - providing a "second
chance" at resync'ing regions which may have failed to resync in
the original pass due to an I/O error.
Index: linux-2.6.18.1/drivers/md/dm-log.c
===================================================================
--- linux-2.6.18.1.orig/drivers/md/dm-log.c	2006-10-25 11:36:14.000000000 -0500
+++ linux-2.6.18.1/drivers/md/dm-log.c	2006-10-25 11:36:17.000000000 -0500
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
