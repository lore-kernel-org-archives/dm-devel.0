From: akpm@osdl.org
Subject: [patch 07/24] dm: suspend: fix error path
Date: Wed, 08 Nov 2006 17:44:43 -0800
Message-ID: <200611090144.kA91ihNU000697@shell0.pdx.osdl.net>
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
To: torvalds@osdl.org
Cc: akpm@osdl.org, dm-devel@redhat.com, agk@redhat.com
List-Id: dm-devel.ids

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
 1 file changed, 3 insertions(+), 1 deletion(-)

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
