From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 9/17] bottom-layer barrier support
Date: Mon, 20 Apr 2009 03:59:45 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0904200358300.6097@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.0904200357240.6097@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904200358000.6097@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0904200358000.6097@hs20-bc2-1.build.redhat.com>
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

dm-linear-flush.patch

Flush support for the linear target.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-linear.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: linux-2.6.30-rc1-devel/drivers/md/dm-linear.c
===================================================================
--- linux-2.6.30-rc1-devel.orig/drivers/md/dm-linear.c	2009-04-10 06:32:54.000000000 +0200
+++ linux-2.6.30-rc1-devel/drivers/md/dm-linear.c	2009-04-10 06:33:36.000000000 +0200
@@ -53,6 +53,7 @@ static int linear_ctr(struct dm_target *
 		goto bad;
 	}
 
+	ti->num_flush_requests = 1;
 	ti->private = lc;
 	return 0;
 
@@ -81,7 +82,8 @@ static void linear_map_bio(struct dm_tar
 	struct linear_c *lc = ti->private;
 
 	bio->bi_bdev = lc->dev->bdev;
-	bio->bi_sector = linear_map_sector(ti, bio->bi_sector);
+	if (bio_sectors(bio))
+		bio->bi_sector = linear_map_sector(ti, bio->bi_sector);
 }
 
 static int linear_map(struct dm_target *ti, struct bio *bio,
