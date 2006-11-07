From: Alasdair G Kergon <agk@redhat.com>
Subject: [PATCH 2.6.19 2/5] dm: suspend: fix error path
Date: Tue, 7 Nov 2006 18:30:46 +0000
Message-ID: <20061107183046.GD6993@agk.surrey.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Andrew Morton <akpm@osdl.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

If the device is already suspended, just return the error and skip the
code that would incorrectly wipe md->suspended_bdev.

(This isn't currently a problem because existing code avoids
calling this function if the device is already suspended.)

Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com

Index: linux-2.6.19-rc4/drivers/md/dm.c
===================================================================
--- linux-2.6.19-rc4.orig/drivers/md/dm.c	2006-11-07 17:06:27.000000000 +0000
+++ linux-2.6.19-rc4/drivers/md/dm.c	2006-11-07 17:07:57.000000000 +0000
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
