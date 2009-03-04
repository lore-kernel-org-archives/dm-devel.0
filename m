From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH] dm-snap-persistent-fix-dtr-cleanup.patch
Date: Wed, 04 Mar 2009 15:33:56 -0600
Message-ID: <1236202436.28664.8.camel@hydrogen.msp.redhat.com>
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

Prerequisites for this patch are:
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
  14) dm-snap-fix-status-output.patch

 brassow

The persistent exception store destructor does not properly
account for all conditions in which it can be called.  If it
is called after 'ctr' but before 'read_metadata' - like if
something else in 'snapshot_ctr' fails - then it will attempt
to free areas of memory that haven't been allocated yet.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-2.6/drivers/md/dm-snap-persistent.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-snap-persistent.c
+++ linux-2.6/drivers/md/dm-snap-persistent.c
@@ -162,9 +162,12 @@ static int alloc_area(struct pstore *ps)
 
 static void free_area(struct pstore *ps)
 {
-	vfree(ps->area);
+	if (ps->area)
+		vfree(ps->area);
 	ps->area = NULL;
-	vfree(ps->zero_area);
+
+	if (ps->zero_area)
+		vfree(ps->zero_area);
 	ps->zero_area = NULL;
 }
 
@@ -481,10 +484,17 @@ static void persistent_dtr(struct dm_exc
 {
 	struct pstore *ps = get_info(store);
 
-	destroy_workqueue(ps->metadata_wq);
-	dm_io_client_destroy(ps->io_client);
-	vfree(ps->callbacks);
+	/* Created in read_header */
+	if (ps->io_client)
+		dm_io_client_destroy(ps->io_client);
 	free_area(ps);
+
+	/* Allocated in persistent_read_metadata */
+	if (ps->callbacks)
+		vfree(ps->callbacks);
+
+	/* Don't need to check these, because they are done in ctr */
+	destroy_workqueue(ps->metadata_wq);
 	kfree(ps);
 }
 
@@ -661,7 +671,7 @@ static int persistent_ctr(struct dm_exce
 	struct pstore *ps;
 
 	/* allocate the pstore */
-	ps = kmalloc(sizeof(*ps), GFP_KERNEL);
+	ps = kzalloc(sizeof(*ps), GFP_KERNEL);
 	if (!ps)
 		return -ENOMEM;
 
