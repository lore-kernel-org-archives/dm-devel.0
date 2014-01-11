From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 1/7] dm-bufio: return success or failure on
	prefetch
Date: Sat, 11 Jan 2014 12:29:12 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1401111228220.4018@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1401111222400.4018@file01.intranet.prod.int.rdu2.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LRH.2.02.1401111222400.4018@file01.intranet.prod.int.rdu2.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Alasdair G. Kergon" <agk@redhat.com>, Mike Snitzer <msnitzer@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

This patch makes dm_bufio_prefetch return 1 on success and 0 on failure.
A prefetch failure may happen in case of temporary memory shortage.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-bufio.c |    8 ++++++--
 drivers/md/dm-bufio.h |    4 ++--
 2 files changed, 8 insertions(+), 4 deletions(-)

Index: linux-3.13-rc7/drivers/md/dm-bufio.c
===================================================================
--- linux-3.13-rc7.orig/drivers/md/dm-bufio.c	2014-01-09 16:11:31.000000000 +0100
+++ linux-3.13-rc7/drivers/md/dm-bufio.c	2014-01-09 16:16:43.000000000 +0100
@@ -1068,10 +1068,11 @@ void *dm_bufio_new(struct dm_bufio_clien
 }
 EXPORT_SYMBOL_GPL(dm_bufio_new);
 
-void dm_bufio_prefetch(struct dm_bufio_client *c,
+int dm_bufio_prefetch(struct dm_bufio_client *c,
 		       sector_t block, unsigned n_blocks)
 {
 	struct blk_plug plug;
+	int success = 1;
 
 	LIST_HEAD(write_list);
 
@@ -1104,13 +1105,16 @@ void dm_bufio_prefetch(struct dm_bufio_c
 			if (!n_blocks)
 				goto flush_plug;
 			dm_bufio_lock(c);
-		}
+		} else
+			success = 0;
 	}
 
 	dm_bufio_unlock(c);
 
 flush_plug:
 	blk_finish_plug(&plug);
+
+	return success;
 }
 EXPORT_SYMBOL_GPL(dm_bufio_prefetch);
 
Index: linux-3.13-rc7/drivers/md/dm-bufio.h
===================================================================
--- linux-3.13-rc7.orig/drivers/md/dm-bufio.h	2014-01-09 16:15:47.000000000 +0100
+++ linux-3.13-rc7/drivers/md/dm-bufio.h	2014-01-09 16:15:55.000000000 +0100
@@ -67,8 +67,8 @@ void *dm_bufio_new(struct dm_bufio_clien
  * The function starts to read the blocks and returns without waiting for
  * I/O to finish.
  */
-void dm_bufio_prefetch(struct dm_bufio_client *c,
-		       sector_t block, unsigned n_blocks);
+int dm_bufio_prefetch(struct dm_bufio_client *c,
+		      sector_t block, unsigned n_blocks);
 
 /*
  * Release a reference obtained with dm_bufio_{read,get,new}. The data
