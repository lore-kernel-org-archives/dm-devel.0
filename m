From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] Use refcounting for sysfs devices
Date: Wed, 25 May 2011 14:40:42 +0200
Message-ID: <201105251240.p4PCegPo017758@pentland.suse.de>
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
To: Christophe Varoqui <christophe.varoqui@gmail.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids


As we're caching sysfs devices we need to introduce some sort
of refcounting here. Otherwise the device might be removed from
other threads while we're still accessing it.

References: bnc#642846

Signed-off-by: Hannes Reinecke <hare@suse.de>

diff --git a/libmultipath/sysfs.c b/libmultipath/sysfs.c
index fc64881..ff63a1b 100644
--- a/libmultipath/sysfs.c
+++ b/libmultipath/sysfs.c
@@ -44,6 +44,7 @@ static LIST_HEAD(sysfs_dev_list);
 struct sysfs_dev {
 	struct list_head node;
 	struct sysfs_device dev;
+	int refcount;
 };
 
 int sysfs_init(char *path, size_t len)
@@ -152,6 +153,7 @@ struct sysfs_device *sysfs_device_get(const char *devpath)
 			if (strcmp(sysdev_loop->dev.devpath, devpath_real) == 0) {
 				dbg("found vanished dev in cache '%s'",
 				    sysdev_loop->dev.devpath);
+				sysdev_loop->refcount++;
 				return &sysdev_loop->dev;
 			}
 		}
@@ -167,6 +169,7 @@ struct sysfs_device *sysfs_device_get(const char *devpath)
 		if (strcmp(sysdev_loop->dev.devpath, devpath_real) == 0) {
 			dbg("found dev in cache '%s'", sysdev_loop->dev.devpath);
 			dev = &sysdev_loop->dev;
+			sysdev_loop->refcount++;
 		}
 	}
 
@@ -177,6 +180,7 @@ struct sysfs_device *sysfs_device_get(const char *devpath)
 		if (sysdev == NULL)
 			return NULL;
 		memset(sysdev, 0x00, sizeof(struct sysfs_dev));
+		sysdev->refcount = 1;
 		list_add(&sysdev->node, &sysfs_dev_list);
 		dev = &sysdev->dev;
 	}
@@ -243,6 +247,8 @@ struct sysfs_device *sysfs_device_verify(struct sysfs_device *dev)
 	char path[PATH_SIZE];
 	struct stat statbuf;
 
+	if (!dev->devpath)
+		return NULL;
 	strlcpy(path, sysfs_path, sizeof(path));
 	strlcat(path, dev->devpath, sizeof(path));
 	if (stat(dev->devpath, &statbuf) == 0 &&
@@ -258,15 +264,21 @@ void sysfs_device_put(struct sysfs_device *dev)
 
 	list_for_each_entry(sysdev_loop, &sysfs_dev_list, node) {
 		if (&sysdev_loop->dev == dev) {
-			dbg("removed dev '%s' from cache",
-			    sysdev_loop->dev.devpath);
-			list_del(&sysdev_loop->node);
-			free(sysdev_loop);
+			sysdev_loop->refcount--;
+			if (!sysdev_loop->refcount) {
+				dbg("removed dev '%s' from cache",
+				    sysdev_loop->dev.devpath);
+				list_del(&sysdev_loop->node);
+				free(sysdev_loop);
+			} else {
+				dbg("dev '%s' still in cache, refcount %d",
+				    sysdev_loop->dev.devpath,
+				    sysdev_loop->refcount);
+			}
 			return;
 		}
 	}
-	dbg("dev '%s' not found in cache",
-	    sysdev_loop->dev.devpath);
+	dbg("dev '%s' not found in cache", dev->devpath);
 
 	return;
 }
