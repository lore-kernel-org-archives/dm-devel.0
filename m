From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm-writecache: report start_sector
Date: Wed, 25 Jul 2018 02:34:06 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1807250233320.334@file01.intranet.prod.int.rdu2.redhat.com>
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
To: Mike Snitzer <msnitzer@redhat.com>, David Teigland <teigland@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

BTW. we also need this patch to report the starting sectors in the 
table arguments.

Report the starting sector in the status line.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-writecache.c |    4 ++++
 1 file changed, 4 insertions(+)

Index: linux-2.6/drivers/md/dm-writecache.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-writecache.c	2018-07-25 01:57:35.000000000 +0200
+++ linux-2.6/drivers/md/dm-writecache.c	2018-07-25 02:00:11.000000000 +0200
@@ -2244,6 +2244,8 @@ static void writecache_status(struct dm_
 		DMEMIT("%c %s %s %u ", WC_MODE_PMEM(wc) ? 'p' : 's',
 				wc->dev->name, wc->ssd_dev->name, wc->block_size);
 		extra_args = 0;
+		if (wc->start_sector)
+			extra_args += 2;
 		if (wc->high_wm_percent_set)
 			extra_args += 2;
 		if (wc->low_wm_percent_set)
@@ -2258,6 +2260,8 @@ static void writecache_status(struct dm_
 			extra_args++;
 
 		DMEMIT("%u", extra_args);
+		if (wc->start_sector)
+			DMEMIT(" start_sector %llu", (unsigned long long)wc->start_sector);
 		if (wc->high_wm_percent_set) {
 			x = (uint64_t)wc->freelist_high_watermark * 100;
 			x += wc->n_blocks / 2;
