From: akpm@osdl.org
Subject: + dm-suspend-fix-error-path.patch added to -mm tree
Date: Tue, 07 Nov 2006 12:29:15 -0800
Message-ID: <200611072029.kA7KTFvS015218@shell0.pdx.osdl.net>
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
To: mm-commits@vger.kernel.org
Cc: dm-devel@redhat.com, agk@redhat.com
List-Id: dm-devel.ids


The patch titled
     dm: suspend: fix error path
has been added to the -mm tree.  Its filename is
     dm-suspend-fix-error-path.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: dm: suspend: fix error path
From: Alasdair G Kergon <agk@redhat.com>

If the device is already suspended, just return the error and skip the code
that would incorrectly wipe md->suspended_bdev.

(This isn't currently a problem because existing code avoids calling this
function if the device is already suspended.)

Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Cc: <dm-devel@redhat.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/md/dm.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/md/dm.c~dm-suspend-fix-error-path drivers/md/dm.c
--- a/drivers/md/dm.c~dm-suspend-fix-error-path
+++ a/drivers/md/dm.c
@@ -1285,7 +1285,7 @@ int dm_suspend(struct mapped_device *md,
 	down(&md->suspend_lock);
 
 	if (dm_suspended(md))
-		goto out;
+		goto out_unlock;
 
 	map = dm_get_table(md);
 
@@ -1361,6 +1361,8 @@ out:
 	}
 
 	dm_table_put(map);
+
+out_unlock:
 	up(&md->suspend_lock);
 	return r;
 }
_

Patches currently in -mm which might be from agk@redhat.com are

dm-fix-find_device-race.patch
dm-suspend-fix-error-path.patch
dm-multipath-fix-rr_add_path-order.patch
dm-raid1-fix-waiting-for-io-on-suspend.patch
dm-raid1-fix-waiting-for-io-on-suspend-fix.patch
fs-freeze_bdev-with-semaphore-not-mutex.patch
struct-path-rename-dms-struct-path.patch
md-dm-reduce-stack-usage-with-stacked-block-devices.patch
