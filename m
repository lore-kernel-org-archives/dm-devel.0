From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 2 of 2] DM Snapshot: check if chunk size not
	specified
Date: Wed, 23 Sep 2009 09:31:10 -0500
Message-ID: <200909231431.n8NEVAcS024650@hydrogen.msp.redhat.com>
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

Patch name: dm-snapshot-check-if-chunk-size-not-specified.patch

If we are creating snapshot with memory-stored exception store, fail if
the user didn't specify chunk size. Zero chunk size would probably crash
a lot of places in the rest of snapshot code.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Reviewed-by: Jonathan Brassow <jbrassow@redhat.com>
Reviewed-by: Mike Snitzer <snitzer@redhat.com>

Index: linux-2.6/drivers/md/dm-snap.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-snap.c
+++ linux-2.6/drivers/md/dm-snap.c
@@ -668,6 +668,11 @@ static int snapshot_ctr(struct dm_target
 	bio_list_init(&s->queued_bios);
 	INIT_WORK(&s->queued_bios_work, flush_queued_bios);
 
+	if (!s->store->chunk_size) {
+		ti->error = "Chunk size not set";
+		goto bad_load_and_register;
+	}
+
 	/* Add snapshot to the list of snapshots for this origin */
 	/* Exceptions aren't triggered till snapshot_resume() is called */
 	if (register_snapshot(s)) {
