From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 8 of 17]
	dm-snap-persistent-minor-code-cleanup.patch
Date: Fri, 20 Feb 2009 17:21:46 -0600
Message-ID: <1235172106.24593.35.camel@hydrogen.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
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

Minor code clean-up.  Streamlines code and makes next patch easier
to review.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-2.6/drivers/md/dm-snap-persistent.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-snap-persistent.c
+++ linux-2.6/drivers/md/dm-snap-persistent.c
@@ -526,35 +526,31 @@ static int persistent_read_metadata(stru
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
