From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] Remove devices from sysfs cache
Date: Wed, 25 Jul 2007 12:59:39 +0200
Message-ID: <46A72D1B.1040408@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------040209060108080309060307"
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
To: christophe varoqui <christophe.varoqui@free.fr>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

This is a multi-part message in MIME format.
--------------040209060108080309060307
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Christophe,

whenever a device is finally removed from a multipath map we should also =
remove it from the sysfs cache. Otherwise we'll hogging up memory with mu=
ltipathd. And we might rely on wrong information as the device in the sys=
fs cache might in fact be a different device if the system decided to ass=
ign the same number to a different device or if some values have changed.

Please apply.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)

--------------040209060108080309060307
Content-Type: text/plain; name="multipath-tools-remove-sysfs-device-from-cache"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="multipath-tools-remove-sysfs-device-from-cache"

multipathd: remove sysfs devices from cache

Whenever a device is really removed from any multipath map we should
also remove it from the cache. Otherwise we'll induce a memory leak.

Signed-off-by: Hannes Reinecke <hare@suse.de>

diff --git a/libmultipath/sysfs.c b/libmultipath/sysfs.c
index d8c65b2..b9621ac 100644
--- a/libmultipath/sysfs.c
+++ b/libmultipath/sysfs.c
@@ -342,6 +342,25 @@ struct sysfs_device *sysfs_device_get_parent_with_subsystem(struct sysfs_device
 	return NULL;
 }
 
+void sysfs_device_put(struct sysfs_device *dev)
+{
+	struct sysfs_dev *sysdev_loop;
+
+	list_for_each_entry(sysdev_loop, &sysfs_dev_list, node) {
+		if (&sysdev_loop->dev == dev) {
+			dbg("removed dev '%s' from cache",
+			    sysdev_loop->dev.devpath);
+			list_del(&sysdev_loop->node);
+			free(sysdev_loop);
+			return;
+		}
+	}
+	dbg("dev '%s' not found in cache",
+	    sysdev_loop->dev.devpath);
+
+	return;
+}
+
 char *sysfs_attr_get_value(const char *devpath, const char *attr_name)
 {
 	char path_full[PATH_SIZE];
diff --git a/libmultipath/sysfs.h b/libmultipath/sysfs.h
index 6d83489..e7fa3e7 100644
--- a/libmultipath/sysfs.h
+++ b/libmultipath/sysfs.h
@@ -18,6 +18,7 @@ void sysfs_device_set_values(struct sysfs_device *dev, const char *devpath,
 struct sysfs_device *sysfs_device_get(const char *devpath);
 struct sysfs_device *sysfs_device_get_parent(struct sysfs_device *dev);
 struct sysfs_device *sysfs_device_get_parent_with_subsystem(struct sysfs_device *dev, const char *subsystem);
+void sysfs_device_put(struct sysfs_device *dev);
 char *sysfs_attr_get_value(const char *devpath, const char *attr_name);
 int sysfs_resolve_link(char *path, size_t size);
 
diff --git a/multipathd/main.c b/multipathd/main.c
index b1620b5..da5fd8f 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -442,8 +442,14 @@ out:
 static int
 uev_remove_path (struct sysfs_device * dev, struct vectors * vecs)
 {
+	int retval;
+
 	condlog(2, "%s: remove path (uevent)", dev->kernel);
-	return ev_remove_path(dev->kernel, vecs);
+	retval = ev_remove_path(dev->kernel, vecs);
+	if (!retval)
+		sysfs_device_put(dev);
+
+	return retval;
 }
 
 int

--------------040209060108080309060307
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------040209060108080309060307--
