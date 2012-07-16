From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm-mirror: set discard_zeroes_data_unsupported
Date: Mon, 16 Jul 2012 19:58:59 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1207161958340.20892@file.rdu.redhat.com>
References: <Pine.LNX.4.64.1207161956430.20892@file.rdu.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.1207161956430.20892@file.rdu.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Alasdair G. Kergon" <agk@redhat.com>
Cc: Mike Snitzer <msnitzer@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

dm-mirror: set discard_zeroes_data_unsupported

We can't guarantee that REQ_DISCARD on dm-mirror zeroes the data even if
the underlying disks support zero on discard.

For example, if the mirror is in the process of resynchronizing, it may
happen that kcopyd reads a piece of data, then discard is sent on the
same area and then kcopyd writes the piece of data to another leg.
Consequently, the data is not zeroed.

So this patch sets ti->discard_zeroes_data_unsupported.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@kernel.org

---
 drivers/md/dm-raid1.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-3.5-rc6-fast/drivers/md/dm-raid1.c
===================================================================
--- linux-3.5-rc6-fast.orig/drivers/md/dm-raid1.c	2012-07-17 00:45:34.000000000 +0200
+++ linux-3.5-rc6-fast/drivers/md/dm-raid1.c	2012-07-17 00:45:39.000000000 +0200
@@ -1091,6 +1091,7 @@ static int mirror_ctr(struct dm_target *
 
 	ti->num_flush_requests = 1;
 	ti->num_discard_requests = 1;
+	ti->discard_zeroes_data_unsupported = 1;
 
 	ms->kmirrord_wq = alloc_workqueue("kmirrord",
 					  WQ_NON_REENTRANT | WQ_MEM_RECLAIM, 0);
