From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] dm-table.c: Always increase refcount in
	dm_get_device()
Date: Thu,  1 Feb 2018 16:06:57 +0100
Message-ID: <20180201150657.74411-1-hare@suse.de>
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
To: snitzer@suse.de
Cc: dm-devel@redhat.com, Elena Reshetova <elena.reshetova@intel.com>, Hannes Reinecke <hare@suse.com>
List-Id: dm-devel.ids

dm_get_device() is paired with dm_put_device(), and needs to
always increase the refcount. Otherwise the device will be released
and we get a nice use-after-free kernel oops.

Fixes: 2a0b4682e09d ("dm: convert dm_dev_internal.count from atomic_t to refcount_t)
Cc: Elena Reshetova <elena.reshetova@intel.com>
Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/md/dm-table.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 88130b5d95f9..1f5d6922a1fc 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -450,14 +450,15 @@ int dm_get_device(struct dm_target *ti, const char *path, fmode_t mode,
 			kfree(dd);
 			return r;
 		}
-
 		refcount_set(&dd->count, 1);
 		list_add(&dd->list, &t->devices);
 
-	} else if (dd->dm_dev->mode != (mode | dd->dm_dev->mode)) {
-		r = upgrade_mode(dd, mode, t->md);
-		if (r)
-			return r;
+	} else {
+		if (dd->dm_dev->mode != (mode | dd->dm_dev->mode)) {
+			r = upgrade_mode(dd, mode, t->md);
+			if (r)
+				return r;
+		}
 		refcount_inc(&dd->count);
 	}
 
-- 
2.12.3
