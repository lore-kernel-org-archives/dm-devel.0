From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH v2] dm: reduce the number of processes per dm
	device
Date: Wed, 21 Oct 2015 16:34:20 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1510211631530.27225@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1510081214130.14961@file01.intranet.prod.int.rdu2.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LRH.2.02.1510081214130.14961@file01.intranet.prod.int.rdu2.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Alasdair G. Kergon" <agk@redhat.com>, Zdenek Kabelac <zkabelac@redhat.com>, Mike Snitzer <msnitzer@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

This is updated patch to reduce the number of processes. When we free 
q->bio_split bioset, we must also avoid the call to blk_queue_split that 
uses it. The call to blk_queue_split is useless because device mapper does 
its own splitting.


From: Mikulas Patocka <mpatocka@redhat.com>

The patch 54efd50bfd873e2dbf784e0b21a8027ba4299a3e ("block: make
generic_make_request handle arbitrarily sized bios") makes it possible for
block devices to process large bios. The patch allocates a new bio set
queue->bio_split for each device, this bio set is used for allocating bios
when the driver needs to split large bios.

Each bio_set allocates a workqueue process, thus the above patch increases
the number of processes allocated per block device.

Device mapper doesn't need the queue->bio_split bio_set, thus we can
deallocate it. This reduces the number of allocated processes per
dm-device from 3 to 2. We remove the call to blk_queue_split, it is not 
needed because device mapper does its own splitting.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

Index: linux-4.3-rc6/drivers/md/dm.c
===================================================================
--- linux-4.3-rc6.orig/drivers/md/dm.c	2015-10-21 19:29:04.000000000 +0200
+++ linux-4.3-rc6/drivers/md/dm.c	2015-10-21 19:29:58.000000000 +0200
@@ -1742,8 +1742,6 @@ static void dm_make_request(struct reque
 
 	map = dm_get_live_table(md, &srcu_idx);
 
-	blk_queue_split(q, &bio, q->bio_split);
-
 	generic_start_io_acct(rw, bio_sectors(bio), &dm_disk(md)->part0);
 
 	/* if we're suspended, we have to queue this io for later */
@@ -2770,6 +2768,12 @@ int dm_setup_md_queue(struct mapped_devi
 	case DM_TYPE_BIO_BASED:
 		dm_init_old_md_queue(md);
 		blk_queue_make_request(md->queue, dm_make_request);
+		/*
+		 * We don't need the bioset, so we free it to save one process
+		 * per device.
+		 */
+		bioset_free(md->queue->bio_split);
+		md->queue->bio_split = NULL;
 		break;
 	}
 
