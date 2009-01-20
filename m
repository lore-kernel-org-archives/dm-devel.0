From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 8 of 12]:
	dm-snapshot-use-DMEMIT-macro-for-status.patch
Date: Tue, 20 Jan 2009 14:05:30 -0600
Message-ID: <1232481930.19993.37.camel@hydrogen.msp.redhat.com>
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

 brassow

Use DMEMIT in place of snprintf.  This makes it easier later when
other modules are helping to populate our status output.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-2.6.28/drivers/md/dm-snap.c
===================================================================
--- linux-2.6.28.orig/drivers/md/dm-snap.c	2009-01-08 20:00:37.000000000 +0000
+++ linux-2.6.28/drivers/md/dm-snap.c	2009-01-08 20:32:18.000000000 +0000
@@ -1205,24 +1205,25 @@ static void snapshot_resume(struct dm_ta
 static int snapshot_status(struct dm_target *ti, status_type_t type,
 			   char *result, unsigned int maxlen)
 {
+	int sz = 0;
 	struct dm_snapshot *snap = ti->private;
 
 	switch (type) {
 	case STATUSTYPE_INFO:
 		if (!snap->valid)
-			snprintf(result, maxlen, "Invalid");
+			DMEMIT("Invalid");
 		else {
 			if (snap->store->type->fraction_full) {
 				sector_t numerator, denominator;
 				snap->store->type->fraction_full(snap->store,
 								 &numerator,
 								 &denominator);
-				snprintf(result, maxlen, "%llu/%llu",
-					(unsigned long long)numerator,
-					(unsigned long long)denominator);
+				DMEMIT("%llu/%llu",
+				       (unsigned long long)numerator,
+				       (unsigned long long)denominator);
 			}
 			else
-				snprintf(result, maxlen, "Unknown");
+				DMEMIT("Unknown");
 		}
 		break;
 
@@ -1232,10 +1233,10 @@ static int snapshot_status(struct dm_tar
 		 * to make private copies if the output is to
 		 * make sense.
 		 */
-		snprintf(result, maxlen, "%s %s %s %llu",
-			 snap->origin->name, snap->store->cow->name,
-			 snap->store->type->name,
-			 (unsigned long long)snap->store->chunk_size);
+		DMEMIT("%s", snap->origin->name);
+		DMEMIT(" %s %s %llu", snap->store->cow->name,
+		       snap->store->type->name,
+		       (unsigned long long)snap->store->chunk_size);
 		break;
 	}
 
