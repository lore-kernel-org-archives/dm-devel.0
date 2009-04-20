From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6/17] bottom-layer barrier support
Date: Mon, 20 Apr 2009 03:56:25 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0904200355520.6097@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.0904200355330.6097@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0904200355330.6097@hs20-bc2-1.build.redhat.com>
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
Cc: Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

dm-remove-test-for-zero-size.patch

Remove test for !bi_size. Zero-data flush barriers will be passed down
this path.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm.c |    5 -----
 1 file changed, 5 deletions(-)

Index: linux-2.6.30-rc1-devel/drivers/md/dm.c
===================================================================
--- linux-2.6.30-rc1-devel.orig/drivers/md/dm.c	2009-04-10 06:33:23.000000000 +0200
+++ linux-2.6.30-rc1-devel/drivers/md/dm.c	2009-04-10 06:33:28.000000000 +0200
@@ -647,11 +647,6 @@ static void __map_bio(struct dm_target *
 	sector_t sector;
 	struct mapped_device *md;
 
-	/*
-	 * Sanity checks.
-	 */
-	BUG_ON(!clone->bi_size);
-
 	clone->bi_end_io = clone_endio;
 	clone->bi_private = tio;
 
