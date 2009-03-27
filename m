From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 11/14] barriers
Date: Fri, 27 Mar 2009 02:09:01 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0903270207570.17063@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.0902231422190.23293@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0902231422190.23293@hs20-bc2-1.build.redhat.com>
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

Set queue ordered mode.

It doesn't really matter what we set here because we don't ever put
any requests on the queue.

We just need to set something other than QUEUE_ORDERED_NONE so that
__generic_make_request passes barrier requests to us.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6.29-rc8-devel/drivers/md/dm.c
===================================================================
--- linux-2.6.29-rc8-devel.orig/drivers/md/dm.c	2009-03-27 04:52:42.000000000 +0100
+++ linux-2.6.29-rc8-devel/drivers/md/dm.c	2009-03-27 04:54:30.000000000 +0100
@@ -1106,6 +1106,7 @@ static struct mapped_device *alloc_dev(i
 	md->queue->backing_dev_info.congested_fn = dm_any_congested;
 	md->queue->backing_dev_info.congested_data = md;
 	blk_queue_make_request(md->queue, dm_request);
+	blk_queue_ordered(md->queue, QUEUE_ORDERED_DRAIN, NULL);
 	blk_queue_bounce_limit(md->queue, BLK_BOUNCE_ANY);
 	md->queue->unplug_fn = dm_unplug_all;
 	blk_queue_merge_bvec(md->queue, dm_merge_bvec);
