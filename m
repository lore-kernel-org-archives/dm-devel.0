From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH]: dm-snap-fix-status-output.patch
Date: Wed, 04 Mar 2009 15:30:45 -0600
Message-ID: <1236202245.28664.5.camel@hydrogen.msp.redhat.com>
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

This patch goes over the first round of exception store API patches.
Prerequisites are:
  1) dm-exception-store-introduce-registry.patch
  2) dm-exception-store-move-dm_target-pointer.patch
  3) dm-exception-store-move-chunk_fields.patch
  4) dm-exception-store-move-cow-pointer.patch
  5) dm-snapshot-remove-dm_snap-header-use.patch
  6) dm-snapshot-remove-dm_snap-header.patch
  7) dm-snapshot-use-DMEMIT-macro-for-status.patch
  8) dm-snapshot-move-ctr-parsing-to-exception-store.patch
  9) dm-snapshot-move-status-to-exception-store.patch
  10) dm-exception-store-generalize-table-args.patch
  11) dm-snapshot-new-ctr-table-format.patch
  12) dm-snapshot-cleanup.patch
  13) dm-snap-minor-fix.patch

 brassow

Failure to take into account what has already been put into
the status buffer via 'DMEMIT' will result in the exception
store status printing over what snapshot_status put into
the buffer.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-2.6/drivers/md/dm-snap.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-snap.c
+++ linux-2.6/drivers/md/dm-snap.c
@@ -1193,7 +1193,7 @@ static void snapshot_resume(struct dm_ta
 static int snapshot_status(struct dm_target *ti, status_type_t type,
 			   char *result, unsigned int maxlen)
 {
-	int sz = 0;
+	unsigned int sz = 0;
 	struct dm_snapshot *snap = ti->private;
 
 	switch (type) {
@@ -1221,8 +1221,9 @@ static int snapshot_status(struct dm_tar
 		 * to make private copies if the output is to
 		 * make sense.
 		 */
-		DMEMIT("%s", snap->origin->name);
-		snap->store->type->status(snap->store, type, result, maxlen);
+		DMEMIT("%s ", snap->origin->name);
+		snap->store->type->status(snap->store, type,
+					  result+sz, maxlen-sz);
 		break;
 	}
 
