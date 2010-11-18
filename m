From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 3 of 9] md fix null pointer deref
Date: Thu, 18 Nov 2010 17:42:40 -0600
Message-ID: <201011182342.oAINgeE5010601@hydrogen.msp.redhat.com>
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Patch name: md-fix-null-pointer-deref.patch

Fix NULL pointer dereference.

When the module parameter 'start_dirty_degraded' is set, the
RAID is not in sync, and a drive needs to be rebuilt, there
will be BUG() called when finished because 'sysfs_notify_dirent'
is called with a NULL argument.  (rdev->sysfs_state is not
always set.)

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-2.6/drivers/md/md.c
===================================================================
--- linux-2.6.orig/drivers/md/md.c
+++ linux-2.6/drivers/md/md.c
@@ -7227,6 +7227,8 @@ static int __init md_init(void)
 	raid_table_header = register_sysctl_table(raid_root_table);
 
 	md_geninit();
+	if (start_dirty_degraded)
+		printk(KERN_INFO "md: start_dirty_degraded set\n");
 	return 0;
 }
 
Index: linux-2.6/drivers/md/raid5.c
===================================================================
--- linux-2.6.orig/drivers/md/raid5.c
+++ linux-2.6/drivers/md/raid5.c
@@ -5339,7 +5339,7 @@ static int raid5_spare_active(mddev_t *m
 		    && !test_bit(Faulty, &tmp->rdev->flags)
 		    && !test_and_set_bit(In_sync, &tmp->rdev->flags)) {
 			count++;
-			sysfs_notify_dirent(tmp->rdev->sysfs_state);
+			sysfs_notify_dirent_safe(tmp->rdev->sysfs_state);
 		}
 	}
 	spin_lock_irqsave(&conf->device_lock, flags);
