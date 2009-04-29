From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 2/2] dm-bdev-keep-bdev-always-referenced.patch
Date: Wed, 29 Apr 2009 02:26:09 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0904290223490.9079@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.0904281211590.22533@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904281214120.22533@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0904281214120.22533@hs20-bc2-1.build.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair G Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi

This is the second version of the patch, I removed those two bogus 
comments and added more explanations to the description.

Mikulas

---

Always keep the reference to structure block_device.

Reference to block_device is obtained with function bdget_disk (and is released
with bdput.

bdget_disk was called while the device was being suspended, in dm_suspend() ---
however at this point, there could be another devices already suspended.

bdget_disk can wait for IO and allocate memory and this could result in waiting
for already suspended device, resulting in deadlock.

It caused bug https://bugzilla.redhat.com/show_bug.cgi?id=179786

This patch changes the code so that it gets the reference to struct block_device
when struct mapped_device is allocated and initialized in (alloc_dev) and drops
the reference when it is destroyed in free_dev. Thus, there is no call to
bdget_disk, while any device is suspended.

This patch removes the comment "/* bdget() can stall if the pending I/Os are
not flushed */". This comment and a relevant condition was likely some
attempt to make a workaround (not a correct fix) for the deadlock referenced
above. After this patch, bdget is called only on device-creation path, without
any suspension, where the code can allocate memory or wait for any I/O.

It also removes the comment "/* don't bdput right now, we don't want the bdev
to go away while it is locked. */". With this patch, bdev is held all the time.

The call unlockfs() is called unconditionally (previously it was called only
if bdev was held), unlockfs() checks at its beginning whether the filesystem
is frozen, if it isn't, it does nothing. So there is no adverse effect from
calling unlockfs() superflously.

This patch allows to change the device size in noflushsuspend, before it was
not allowed because bdev was not held. But there is no adverse effect of this.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm.c |   41 +++++++++--------------------------------
 1 file changed, 9 insertions(+), 32 deletions(-)

Index: linux-2.6.30-rc2-devel/drivers/md/dm.c
===================================================================
--- linux-2.6.30-rc2-devel.orig/drivers/md/dm.c	2009-04-29 08:01:16.000000000 +0200
+++ linux-2.6.30-rc2-devel/drivers/md/dm.c	2009-04-29 08:05:51.000000000 +0200
@@ -1183,6 +1183,10 @@ static struct mapped_device *alloc_dev(i
 	if (!md->wq)
 		goto bad_thread;
 
+	md->bdev = bdget_disk(md->disk, 0);
+	if (!md->bdev)
+		goto bad_bdev;
+
 	/* Populate the mapping, nobody knows we exist yet */
 	spin_lock(&_minor_lock);
 	old_md = idr_replace(&_minor_idr, md, minor);
@@ -1192,6 +1196,8 @@ static struct mapped_device *alloc_dev(i
 
 	return md;
 
+bad_bdev:
+	destroy_workqueue(md->wq);
 bad_thread:
 	put_disk(md->disk);
 bad_disk:
@@ -1217,10 +1223,8 @@ static void free_dev(struct mapped_devic
 {
 	int minor = MINOR(disk_devt(md->disk));
 
-	if (md->bdev) {
-		unlock_fs(md);
-		bdput(md->bdev);
-	}
+	unlock_fs(md);
+	bdput(md->bdev);
 	destroy_workqueue(md->wq);
 	mempool_destroy(md->tio_pool);
 	mempool_destroy(md->io_pool);
@@ -1280,8 +1284,7 @@ static int __bind(struct mapped_device *
 	if (size != get_capacity(md->disk))
 		memset(&md->geometry, 0, sizeof(md->geometry));
 
-	if (md->bdev)
-		__set_size(md, size);
+	__set_size(md, size);
 
 	if (!size) {
 		dm_table_destroy(t);
@@ -1523,11 +1526,6 @@ int dm_swap_table(struct mapped_device *
 	if (!dm_suspended(md))
 		goto out;
 
-	/* without bdev, the device size cannot be changed */
-	if (!md->bdev)
-		if (get_capacity(md->disk) != dm_table_get_size(table))
-			goto out;
-
 	__unbind(md);
 	r = __bind(md, table);
 
@@ -1555,9 +1553,6 @@ static int lock_fs(struct mapped_device 
 
 	set_bit(DMF_FROZEN, &md->flags);
 
-	/* don't bdput right now, we don't want the bdev
-	 * to go away while it is locked.
-	 */
 	return 0;
 }
 
@@ -1604,15 +1599,7 @@ int dm_suspend(struct mapped_device *md,
 	/* This does not get reverted if there's an error later. */
 	dm_table_presuspend_targets(map);
 
-	/* bdget() can stall if the pending I/Os are not flushed */
 	if (!noflush) {
-		md->bdev = bdget_disk(md->disk, 0);
-		if (!md->bdev) {
-			DMWARN("bdget failed in dm_suspend");
-			r = -ENOMEM;
-			goto out;
-		}
-
 		/*
 		 * Flush I/O to the device. noflush supersedes do_lockfs,
 		 * because lock_fs() needs to flush I/Os.
@@ -1678,11 +1665,6 @@ int dm_suspend(struct mapped_device *md,
 	set_bit(DMF_SUSPENDED, &md->flags);
 
 out:
-	if (r && md->bdev) {
-		bdput(md->bdev);
-		md->bdev = NULL;
-	}
-
 	dm_table_put(map);
 
 out_unlock:
@@ -1711,11 +1693,6 @@ int dm_resume(struct mapped_device *md)
 
 	unlock_fs(md);
 
-	if (md->bdev) {
-		bdput(md->bdev);
-		md->bdev = NULL;
-	}
-
 	clear_bit(DMF_SUSPENDED, &md->flags);
 
 	dm_table_unplug_all(map);
