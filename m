From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 16/17] bottom-layer barrier support
Date: Mon, 20 Apr 2009 04:03:22 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0904200403070.6097@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.0904200357240.6097@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904200358000.6097@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904200358300.6097@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904200359520.6097@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904200400160.6097@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904200400500.6097@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904200401280.6097@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904200402010.6097@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904200402400.6097@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0904200402400.6097@hs20-bc2-1.build.redhat.com>
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

dm-dmio-retry-barriers.patch

If -EOPNOTSUPP was returned and the request was a barrier request, retry it
without barrier.

Retry all regions (if there was just one region returning -EOPNOTSUPP), for
now, barriers are submitted only for 1-region requests, so it doesn't matter.

In the future, this can be fine-grained to retry only -EOPNOTSUPPed regions.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-io.c |    6 ++++++
 1 file changed, 6 insertions(+)

Index: linux-2.6.29-rc1-devel/drivers/md/dm-io.c
===================================================================
--- linux-2.6.29-rc1-devel.orig/drivers/md/dm-io.c	2009-01-22 21:09:28.000000000 +0100
+++ linux-2.6.29-rc1-devel/drivers/md/dm-io.c	2009-01-22 21:09:37.000000000 +0100
@@ -364,6 +364,7 @@ static int sync_io(struct dm_io_client *
 		return -EIO;
 	}
 
+retry:
 	io.error_bits = 0;
 	io.eopnotsupp_bits = 0;
 	atomic_set(&io.count, 1); /* see dispatch_io() */
@@ -382,6 +383,11 @@ static int sync_io(struct dm_io_client *
 	}
 	set_current_state(TASK_RUNNING);
 
+	if (io.eopnotsupp_bits && (rw & (1 << BIO_RW_BARRIER))) {
+		rw &= ~(1 << BIO_RW_BARRIER);
+		goto retry;
+	}
+
 	if (error_bits)
 		*error_bits = io.error_bits;
 
