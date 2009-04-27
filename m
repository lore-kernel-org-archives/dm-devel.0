From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6/8] raid1 barriers
Date: Mon, 27 Apr 2009 07:51:01 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0904270750430.18227@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.0904270701250.12459@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904270743540.18227@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904270744220.18227@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904270745190.18227@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904270745510.18227@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904270746210.18227@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904270749300.18227@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904270749570.18227@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0904270749570.18227@hs20-bc2-1.build.redhat.com>
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

Introduce "flush failed" variable. When flush before clearing a bit in the log
fails, we don't know anything about which which regions are in-sync and which
not.

So we'll set all regions as not-in-sync, set the variable "flush_failed" that
will prevent setting the in-sync bit in the future.

A target reload is the only way how to get out of this situation.

The variable will be set in further patches.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

Index: linux-2.6.30-rc2-devel/drivers/md/dm-log.c
===================================================================
--- linux-2.6.30-rc2-devel.orig/drivers/md/dm-log.c	2009-04-24 11:17:50.000000000 +0200
+++ linux-2.6.30-rc2-devel/drivers/md/dm-log.c	2009-04-27 08:51:08.000000000 +0200
@@ -210,6 +210,7 @@ struct log_c {
 	struct dm_target *ti;
 	int touched_dirtied;
 	int touched_cleaned;
+	int flush_failed;
 	uint32_t region_size;
 	unsigned int region_count;
 	region_t sync_count;
@@ -393,6 +394,7 @@ static int create_log_context(struct dm_
 	lc->ti = ti;
 	lc->touched_dirtied = 0;
 	lc->touched_cleaned = 0;
+	lc->flush_failed = 0;
 	lc->region_size = region_size;
 	lc->region_count = region_count;
 	lc->sync = sync;
@@ -703,7 +719,8 @@ static void core_mark_region(struct dm_d
 static void core_clear_region(struct dm_dirty_log *log, region_t region)
 {
 	struct log_c *lc = (struct log_c *) log->context;
-	log_set_bit(lc, lc->clean_bits, region);
+	if (likely(!lc->flush_failed))
+		log_set_bit(lc, lc->clean_bits, region);
 }
 
 static int core_get_resync_work(struct dm_dirty_log *log, region_t *region)
