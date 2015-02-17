From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm: fix a race condition in dm_get_md
Date: Tue, 17 Feb 2015 14:30:53 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1502171429470.13128@file01.intranet.prod.int.rdu2.redhat.com>
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
To: Mike Snitzer <msnitzer@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

The function dm_get_md finds a device mapper device with a given dev_t,
increases the reference count and returns the pointer.

dm_get_md calls dm_find_md, dm_find_md takes _minor_lock, finds the
device, tests that the device doesn't have DMF_DELETING or DMF_FREEING
flag, drops _minor_lock and returns pointer to the device. dm_get_md then
calls dm_get. dm_get calls BUG if the device has the DMF_FREEING flag,
otherwise it increments the reference count.

There is a possible race condition - after dm_find_md exits and before
dm_get is called, there are no locks held, so the device may disappear or
DMF_FREEING flag may be set, which results in BUG.

To fix this bug, we need to call dm_get while we hold _minor_lock. This
patch renames dm_find_md to dm_get_md and changes it so that it calls
dm_get while holding the lock.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@kernel.org

---
 drivers/md/dm.c |   21 +++++++--------------
 1 file changed, 7 insertions(+), 14 deletions(-)

Index: linux-2.6/drivers/md/dm.c
===================================================================
--- linux-2.6.orig/drivers/md/dm.c	2015-02-17 18:55:59.602514876 +0100
+++ linux-2.6/drivers/md/dm.c	2015-02-17 18:56:12.000724026 +0100
@@ -2571,7 +2571,7 @@ int dm_setup_md_queue(struct mapped_devi
 	return 0;
 }
 
-static struct mapped_device *dm_find_md(dev_t dev)
+struct mapped_device *dm_get_md(dev_t dev)
 {
 	struct mapped_device *md;
 	unsigned minor = MINOR(dev);
@@ -2582,12 +2582,15 @@ static struct mapped_device *dm_find_md(
 	spin_lock(&_minor_lock);
 
 	md = idr_find(&_minor_idr, minor);
-	if (md && (md == MINOR_ALLOCED ||
+	if (md) {
+		if ((md == MINOR_ALLOCED ||
 		   (MINOR(disk_devt(dm_disk(md))) != minor) ||
 		   dm_deleting_md(md) ||
 		   test_bit(DMF_FREEING, &md->flags))) {
-		md = NULL;
-		goto out;
+			md = NULL;
+			goto out;
+		}
+		dm_get(md);
 	}
 
 out:
@@ -2595,16 +2598,6 @@ out:
 
 	return md;
 }
-
-struct mapped_device *dm_get_md(dev_t dev)
-{
-	struct mapped_device *md = dm_find_md(dev);
-
-	if (md)
-		dm_get(md);
-
-	return md;
-}
 EXPORT_SYMBOL_GPL(dm_get_md);
 
 void *dm_get_mdptr(struct mapped_device *md)
