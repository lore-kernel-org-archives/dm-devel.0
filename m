From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm: make dm_table_alloc_md_mempools static
Date: Thu, 13 Feb 2014 13:43:32 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1402131343110.22991@file01.intranet.prod.int.rdu2.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
Cc: dm-devel@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

Make the function dm_table_alloc_md_mempools static because it is not
called from another module.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-table.c |    2 +-
 drivers/md/dm.h       |    1 -
 2 files changed, 1 insertion(+), 2 deletions(-)

Index: linux-3.14-rc1/drivers/md/dm-table.c
===================================================================
--- linux-3.14-rc1.orig/drivers/md/dm-table.c	2014-02-06 13:37:06.000000000 +0100
+++ linux-3.14-rc1/drivers/md/dm-table.c	2014-02-06 13:37:17.000000000 +0100
@@ -957,7 +957,7 @@ bool dm_table_request_based(struct dm_ta
 	return dm_table_get_type(t) == DM_TYPE_REQUEST_BASED;
 }
 
-int dm_table_alloc_md_mempools(struct dm_table *t)
+static int dm_table_alloc_md_mempools(struct dm_table *t)
 {
 	unsigned type = dm_table_get_type(t);
 	unsigned per_bio_data_size = 0;
Index: linux-3.14-rc1/drivers/md/dm.h
===================================================================
--- linux-3.14-rc1.orig/drivers/md/dm.h	2014-02-06 13:36:53.000000000 +0100
+++ linux-3.14-rc1/drivers/md/dm.h	2014-02-06 13:37:01.000000000 +0100
@@ -73,7 +73,6 @@ unsigned dm_table_get_type(struct dm_tab
 struct target_type *dm_table_get_immutable_target_type(struct dm_table *t);
 bool dm_table_request_based(struct dm_table *t);
 bool dm_table_supports_discards(struct dm_table *t);
-int dm_table_alloc_md_mempools(struct dm_table *t);
 void dm_table_free_md_mempools(struct dm_table *t);
 struct dm_md_mempools *dm_table_get_md_mempools(struct dm_table *t);
 
