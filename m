From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 12/17] bottom-layer barrier support
Date: Mon, 20 Apr 2009 04:01:11 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0904200400500.6097@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.0904200357240.6097@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904200358000.6097@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904200358300.6097@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904200359520.6097@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904200400160.6097@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0904200400160.6097@hs20-bc2-1.build.redhat.com>
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

dm-delay-flush.patch

Flush supoprt for dm-delay target.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-delay.c |    3 +++
 1 file changed, 3 insertions(+)

Index: linux-2.6.30-rc1-devel/drivers/md/dm-delay.c
===================================================================
--- linux-2.6.30-rc1-devel.orig/drivers/md/dm-delay.c	2009-04-10 06:28:25.000000000 +0200
+++ linux-2.6.30-rc1-devel/drivers/md/dm-delay.c	2009-04-10 06:33:45.000000000 +0200
@@ -198,6 +198,7 @@ out:
 	mutex_init(&dc->timer_lock);
 	atomic_set(&dc->may_delay, 1);
 
+	ti->num_flush_requests = 1;
 	ti->private = dc;
 	return 0;
 
@@ -281,6 +282,8 @@ static int delay_map(struct dm_target *t
 		bio->bi_bdev = dc->dev_write->bdev;
 		bio->bi_sector = dc->start_write +
 				 (bio->bi_sector - ti->begin);
+		if (!bio_sectors(bio))
+			bio->bi_sector = 0;
 
 		return delay_bio(dc, dc->write_delay, bio);
 	}
