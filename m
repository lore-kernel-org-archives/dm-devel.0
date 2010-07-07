From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] optimize one of the cache flushes
Date: Wed, 7 Jul 2010 18:22:24 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1007071819070.6578@hs20-bc2-1.build.redhat.com>
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
To: Mike Snitzer <msnitzer@redhat.com>, Alasdair G Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi

This patch removes the second cache flush if discard isn't supported. 
The first flush is hard to bypass, so it's not worth doing it.

Mikulas

---

Don't do the second flush if the request isn't supported.

If the request fails with -EOPNOTSUPP, don't perform the second flush.
This can happen with discard+barrier requests. If the device doesn't support
discard, there would be two useless SYNCHRONIZE CACHE commands.

The first dm_flush cannot be so easily optimized out, so we leave it there.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

Index: linux-2.6.35-rc3-fast/drivers/md/dm.c
===================================================================
--- linux-2.6.35-rc3-fast.orig/drivers/md/dm.c	2010-07-08 00:11:05.000000000 +0200
+++ linux-2.6.35-rc3-fast/drivers/md/dm.c	2010-07-08 00:12:02.000000000 +0200
@@ -2365,7 +2365,12 @@ static void process_barrier(struct mappe
 
 	if (!bio_empty_barrier(bio)) {
 		__split_and_process_bio(md, bio);
-		dm_flush(md);
+		/*
+		 * If the request isn't supported, don't waste time with
+		 * the second flush.
+		 */
+		if (md->barrier_error != -EOPNOTSUPP)
+			dm_flush(md);
 	}
 
 	if (md->barrier_error != DM_ENDIO_REQUEUE)
