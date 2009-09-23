From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 1 of 2] DM Exception Store (persistent): minor
	code cleanup
Date: Wed, 23 Sep 2009 09:31:00 -0500
Message-ID: <200909231431.n8NEV0cq024577@hydrogen.msp.redhat.com>
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
Cc: mpatocka@redhat.com, snitzer@redhat.com, agk@redhat.com
List-Id: dm-devel.ids

Patch name: dm-exstore-persistent-minor-code-cleanup.patch

Minor code touch-up.  We don't need the 'else'.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>
Reviewed-by: Mikulas Patocka <mpatocka@redhat.com>
Reviewed-by: Mike Snitzer <snitzer@redhat.com>

Index: linux-2.6/drivers/md/dm-snap-persistent.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-snap-persistent.c
+++ linux-2.6/drivers/md/dm-snap-persistent.c
@@ -552,35 +552,31 @@ static int persistent_read_metadata(stru
 		ps->current_area = 0;
 		zero_memory_area(ps);
 		r = zero_disk_area(ps, 0);
-		if (r) {
-			DMWARN("zero_disk_area(0) failed");
-			return r;
-		}
-	} else {
-		/*
-		 * Sanity checks.
-		 */
-		if (ps->version != SNAPSHOT_DISK_VERSION) {
-			DMWARN("unable to handle snapshot disk version %d",
-			       ps->version);
-			return -EINVAL;
-		}
-
-		/*
-		 * Metadata are valid, but snapshot is invalidated
-		 */
-		if (!ps->valid)
-			return 1;
-
-		/*
-		 * Read the metadata.
-		 */
-		r = read_exceptions(ps, callback, callback_context);
 		if (r)
-			return r;
+			DMWARN("zero_disk_area(0) failed");
+		return r;
+	}
+	/*
+	 * Sanity checks.
+	 */
+	if (ps->version != SNAPSHOT_DISK_VERSION) {
+		DMWARN("unable to handle snapshot disk version %d",
+		       ps->version);
+		return -EINVAL;
 	}
 
-	return 0;
+	/*
+	 * Metadata are valid, but snapshot is invalidated
+	 */
+	if (!ps->valid)
+		return 1;
+
+	/*
+	 * Read the metadata.
+	 */
+	r = read_exceptions(ps, callback, callback_context);
+
+	return r;
 }
 
 static int persistent_prepare_exception(struct dm_exception_store *store,
