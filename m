From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: [PATCH 3/3] sysfs representation of stacked devices (md)
Date: Fri, 17 Feb 2006 13:05:18 -0500
Message-ID: <43F6105E.4040005@ce.jp.nec.com>
References: <43F60F31.1030507@ce.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------090309030209000200080906"
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <43F60F31.1030507@ce.jp.nec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Neil Brown <neilb@suse.de>, Alasdair Kergon <agk@redhat.com>, Lars Marowsky-Bree <lmb@suse.de>
Cc: device-mapper development <dm-devel@redhat.com>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

This is a multi-part message in MIME format.
--------------090309030209000200080906
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit

This patch modifies md driver to create symlinks to/from
underlying devices.

-- 
Jun'ichi Nomura, NEC Solutions (America), Inc.

--------------090309030209000200080906
Content-Type: text/x-patch;
	name="stacked-device-representation-in-sysfs-1-md.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="stacked-device-representation-in-sysfs-1-md.patch"

Exporting stacked device relationship to sysfs (md)

Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>

--- linux-2.6.15.orig/include/linux/raid/md_k.h	2006-01-02 22:21:10.000000000 -0500
+++ linux-2.6.15/include/linux/raid/md_k.h	2006-02-16 15:36:22.000000000 -0500
@@ -155,6 +155,7 @@ struct mddev_s
 	struct gendisk			*gendisk;
 
 	struct kobject			kobj;
+	struct kobject			slave_dir;
 
 	/* Superblock information */
 	int				major_version,
md.c linux-2.6.15/drivers/md/md.c
--- linux-2.6.15.orig/drivers/md/md.c	2006-01-02 22:21:10.000000000 -0500
+++ linux-2.6.15/drivers/md/md.c	2006-02-16 17:44:49.000000000 -0500
@@ -182,6 +182,7 @@ static void mddev_put(mddev_t *mddev)
 		return;
 	if (!mddev->raid_disks && list_empty(&mddev->disks)) {
 		list_del(&mddev->all_mddevs);
+		stackdev_clear(&mddev->slave_dir);
 		blk_put_queue(mddev->queue);
 		kobject_unregister(&mddev->kobj);
 	}
@@ -1226,6 +1227,7 @@ static int bind_rdev_to_array(mdk_rdev_t
 	else
 		ko = &rdev->bdev->bd_disk->kobj;
 	sysfs_create_link(&rdev->kobj, ko, "block");
+	stackdev_link(rdev->bdev, &mddev->slave_dir, &mddev->gendisk->kobj);
 	return 0;
 }
 
@@ -1236,6 +1238,8 @@ static void unbind_rdev_from_array(mdk_r
 		MD_BUG();
 		return;
 	}
+	stackdev_unlink(rdev->bdev, &rdev->mddev->slave_dir,
+			&rdev->mddev->gendisk->kobj);
 	list_del_init(&rdev->same_set);
 	printk(KERN_INFO "md: unbind<%s>\n", bdevname(rdev->bdev,b));
 	rdev->mddev = NULL;
@@ -1924,6 +1928,7 @@ static struct kobject *md_probe(dev_t de
 	snprintf(mddev->kobj.name, KOBJ_NAME_LEN, "%s", "md");
 	mddev->kobj.ktype = &md_ktype;
 	kobject_register(&mddev->kobj);
+	stackdev_init(&mddev->slave_dir, &mddev->gendisk->kobj);
 	return NULL;
 }

--------------090309030209000200080906
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------090309030209000200080906--
