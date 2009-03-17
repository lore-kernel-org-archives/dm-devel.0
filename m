From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 18 of 29] dm-snap-possible-code-optimization.patch
Date: Tue, 17 Mar 2009 09:05:11 -0500
Message-ID: <200903171405.n2HE5BFK017469@hydrogen.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
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
List-Id: dm-devel.ids

Minor code clean-up.  The reason I broke this out into a separate
patch is so people can check if I'm not missing anything...  I
don't see a reason to check 's->valid' separately anymore.

RFC-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-2.6/drivers/md/dm-snap.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-snap.c
+++ linux-2.6/drivers/md/dm-snap.c
@@ -741,20 +741,14 @@ static void pending_complete(struct dm_s
 	struct bio *snapshot_bios = NULL;
 	int error = 0;
 
+	down_write(&s->lock);
 	if (!success) {
 		/* Read/write error - snapshot is unusable */
-		down_write(&s->lock);
 		__invalidate_snapshot(s, -EIO);
 		error = 1;
 		goto out;
 	}
 
-	down_write(&s->lock);
-	if (!s->valid) {
-		error = 1;
-		goto out;
-	}
-
 	/*
 	 * Check for conflicting reads. This is extremely improbable,
 	 * so msleep(1) is sufficient and there is no need for a wait queue.
