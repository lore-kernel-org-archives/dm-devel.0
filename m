From: Guido Guenther <agx@sigxcpu.org>
Subject: Re: [multipath 1/1] cache sysfs_devices
Date: Fri, 20 Jul 2007 23:03:44 +0200
Message-ID: <20070720210343.GA11879@bogon.ms20.nix>
References: <20070720172919.GA2497@bogon.ms20.nix>
	<11849647793576-git-send-email--s>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <11849647793576-git-send-email--s>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@free.fr>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

I give up on git-send-email - it always fools me. Nevertheless this one
fixes the described bug of paths coming back as different block
devices:

Keep a list of sysfs devices for sysfs_device_get() so uev_trigger() can look
up the necessary information for proper path removal in case of a 'remove'
uevent - the sysfs files in the filesystem might be long gone at this point.

This also plugs a memory leak where we'd malloc space for the same sysfs device
over and over again for every processed uevent.

Signed-off-by: Guido Guenther <agx@sigxcpu.org>
---
 libmultipath/sysfs.c |   47 +++++++++++++++++++++++++++++++++++++++--------
 1 files changed, 39 insertions(+), 8 deletions(-)

diff --git a/libmultipath/sysfs.c b/libmultipath/sysfs.c
index 1fb5436..d8c65b2 100644
--- a/libmultipath/sysfs.c
+++ b/libmultipath/sysfs.c
@@ -45,6 +45,13 @@ struct sysfs_attr {
 	char value_local[NAME_SIZE];
 };
 
+/* list of sysfs devices */
+static LIST_HEAD(sysfs_dev_list);
+struct sysfs_dev {
+	struct list_head node;
+	struct sysfs_device dev;
+};
+
 int sysfs_init(char *path, size_t len)
 {
 	if (path) {
@@ -55,6 +62,7 @@ int sysfs_init(char *path, size_t len)
 	dbg("sysfs_path='%s'", sysfs_path);
 
 	INIT_LIST_HEAD(&attr_list);
+	INIT_LIST_HEAD(&sysfs_dev_list);
 	return 0;
 }
 
@@ -63,11 +71,17 @@ void sysfs_cleanup(void)
 	struct sysfs_attr *attr_loop;
 	struct sysfs_attr *attr_temp;
 
+	struct sysfs_dev *sysdev_loop;
+	struct sysfs_dev *sysdev_temp;
+
 	list_for_each_entry_safe(attr_loop, attr_temp, &attr_list, node) {
 		list_del(&attr_loop->node);
 		free(attr_loop);
 	}
 
+	list_for_each_entry_safe(sysdev_loop, sysdev_temp, &sysfs_dev_list, node) {
+		free(sysdev_loop);
+	}
 }
 
 void sysfs_device_set_values(struct sysfs_device *dev, const char *devpath,
@@ -140,7 +154,8 @@ struct sysfs_device *sysfs_device_get(const char *devpath)
 {
 	char path[PATH_SIZE];
 	char devpath_real[PATH_SIZE];
-	struct sysfs_device *dev;
+	struct sysfs_device *dev = NULL;
+	struct sysfs_dev *sysdev_loop, *sysdev;
 	struct stat statbuf;
 	char link_path[PATH_SIZE];
 	char link_target[PATH_SIZE];
@@ -155,7 +170,14 @@ struct sysfs_device *sysfs_device_get(const char *devpath)
 	strlcpy(path, sysfs_path, sizeof(path));
 	strlcat(path, devpath_real, sizeof(path));
 	if (lstat(path, &statbuf) != 0) {
+		/* if stat fails look in the cache */
 		dbg("stat '%s' failed: %s", path, strerror(errno));
+		list_for_each_entry(sysdev_loop, &sysfs_dev_list, node) {
+			if (strcmp(sysdev_loop->dev.devpath, devpath_real) == 0) {
+				dbg("found vanished dev in cache '%s'", sysdev_loop->dev.devpath);
+				return &sysdev_loop->dev;
+			}
+		}
 		return NULL;
 	}
 	if (S_ISLNK(statbuf.st_mode)) {
@@ -164,12 +186,22 @@ struct sysfs_device *sysfs_device_get(const char *devpath)
 
 	}
 
-	/* it is a new device */
-	dbg("new device '%s'", devpath_real);
-	dev = malloc(sizeof(struct sysfs_device));
-	if (dev == NULL)
-		return NULL;
-	memset(dev, 0x00, sizeof(struct sysfs_device));
+	list_for_each_entry(sysdev_loop, &sysfs_dev_list, node) {
+		if (strcmp(sysdev_loop->dev.devpath, devpath_real) == 0) {
+			dbg("found dev in cache '%s'", sysdev_loop->dev.devpath);
+				dev = &sysdev_loop->dev;
+		}
+	}
+	if(!dev) {
+		/* it is a new device */
+		dbg("new device '%s'", devpath_real);
+		sysdev = malloc(sizeof(struct sysfs_dev));
+		if (sysdev == NULL)
+			return NULL;
+		memset(sysdev, 0x00, sizeof(struct sysfs_dev));
+		list_add(&sysdev->node, &sysfs_dev_list);
+		dev = &sysdev->dev;
+	}
 
 	sysfs_device_set_values(dev, devpath_real, NULL, NULL);
 
@@ -226,7 +258,6 @@ struct sysfs_device *sysfs_device_get(const char *devpath)
 		if (pos != NULL)
 			strlcpy(dev->driver, &pos[1], sizeof(dev->driver));
 	}
-
 	return dev;
 }
 
-- 
1.5.2.4
