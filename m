From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 12/16] Remove all references to hand-craftes
	sysfs code
Date: Mon, 30 Apr 2012 12:26:04 +0200
Message-ID: <1335781568-13299-14-git-send-email-hare@suse.de>
References: <1335781568-13299-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1335781568-13299-1-git-send-email-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: dm-devel@redhat.com, Kay Sievers <kay.sievers@vrfy.org>
List-Id: dm-devel.ids

We've now converted everything to libudev, so we can get rid
of all the variables etc.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmpathpersist/mpath_persist.c |    5 -
 libmultipath/config.c           |    9 +--
 libmultipath/config.h           |    3 -
 libmultipath/dict.c             |   23 +-----
 libmultipath/structs_vec.c      |    1 -
 libmultipath/sysfs.c            |  183 ++++++++++-----------------------------
 libmultipath/sysfs.h            |   21 +----
 multipath/main.c                |    4 -
 multipath/multipath.conf.5      |    4 -
 multipathd/main.c               |    4 -
 10 files changed, 50 insertions(+), 207 deletions(-)

diff --git a/libmpathpersist/mpath_persist.c b/libmpathpersist/mpath_persist.c
index 302dd3f..d99c0da 100644
--- a/libmpathpersist/mpath_persist.c
+++ b/libmpathpersist/mpath_persist.c
@@ -19,7 +19,6 @@
 #include <dmparser.h>
 #include <ctype.h>
 #include <propsel.h>
-#include <sysfs.h>
 
 #include "mpathpr.h"
 #include "mpath_pr_ioctl.h"
@@ -40,10 +39,6 @@ mpath_lib_init (void)
 		return 1;
 	}
 
-	if (sysfs_init(conf->sysfs_dir, FILE_NAME_SIZE)){
-		condlog(0, "Failed. mpathpersist needs sysfs mounted");
-		exit(1);
-	}
 	return 0;
 }
 
diff --git a/libmultipath/config.c b/libmultipath/config.c
index 2263e19..0f17f03 100644
--- a/libmultipath/config.c
+++ b/libmultipath/config.c
@@ -431,9 +431,6 @@ free_config (struct config * conf)
 	if (conf->udev)
 		udev_unref(conf->udev);
 
-	if (conf->udev_dir)
-		FREE(conf->udev_dir);
-
 	if (conf->multipath_dir)
 		FREE(conf->multipath_dir);
 
@@ -597,14 +594,10 @@ load_config (char * file)
 		if (!conf->mptable)
 			goto out;
 	}
-	if (conf->udev_dir == NULL)
-		conf->udev_dir = set_default(DEFAULT_UDEVDIR);
-
 	if (conf->bindings_file == NULL)
 		conf->bindings_file = set_default(DEFAULT_BINDINGS_FILE);
 
-	if (!conf->udev_dir || !conf->multipath_dir ||
-	    !conf->bindings_file)
+	if (!conf->multipath_dir || !conf->bindings_file)
 		goto out;
 
 	return 0;
diff --git a/libmultipath/config.h b/libmultipath/config.h
index 590dde2..bcca7bd 100644
--- a/libmultipath/config.h
+++ b/libmultipath/config.h
@@ -77,7 +77,6 @@ struct config {
 	int dry_run;
 	int list;
 	int pgpolicy_flag;
-	int with_sysfs;
 	int pgpolicy;
 	enum devtypes dev_type;
 	int minio;
@@ -110,8 +109,6 @@ struct config {
 
 	char * dev;
 	struct udev * udev;
-	char * sysfs_dir;
-	char * udev_dir;
 	char * multipath_dir;
 	char * selector;
 	char * uid_attribute;
diff --git a/libmultipath/dict.c b/libmultipath/dict.c
index c51e005..7300b7e 100644
--- a/libmultipath/dict.c
+++ b/libmultipath/dict.c
@@ -112,17 +112,6 @@ reassign_maps_handler(vector strvec)
 }
 
 static int
-udev_dir_handler(vector strvec)
-{
-	conf->udev_dir = set_value(strvec);
-
-	if (!conf->udev_dir)
-		return 1;
-
-	return 0;
-}
-
-static int
 multipath_dir_handler(vector strvec)
 {
 	conf->multipath_dir = set_value(strvec);
@@ -2237,18 +2226,9 @@ snprint_reassign_maps (char * buff, int len, void * data)
 }
 
 static int
-snprint_def_udev_dir (char * buff, int len, void * data)
-{
-	if (!conf->udev_dir)
-		return 0;
-
-	return snprintf(buff, len, "\"%s\"", conf->udev_dir);
-}
-
-static int
 snprint_def_multipath_dir (char * buff, int len, void * data)
 {
-	if (!conf->udev_dir)
+	if (!conf->multipath_dir)
 		return 0;
 
 	return snprintf(buff, len, "\"%s\"", conf->multipath_dir);
@@ -2547,7 +2527,6 @@ init_keywords(void)
 	install_keyword("polling_interval", &polling_interval_handler, &snprint_def_polling_interval);
 	install_keyword("max_polling_interval", &max_polling_interval_handler, &snprint_def_max_polling_interval);
 	install_keyword("reassign_maps", &reassign_maps_handler, &snprint_reassign_maps);
-	install_keyword("udev_dir", &udev_dir_handler, &snprint_def_udev_dir);
 	install_keyword("multipath_dir", &multipath_dir_handler, &snprint_def_multipath_dir);
 	install_keyword("path_selector", &def_selector_handler, &snprint_def_selector);
 	install_keyword("path_grouping_policy", &def_pgpolicy_handler, &snprint_def_path_grouping_policy);
diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index e1fb4b1..6e70d63 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -13,7 +13,6 @@
 #include "dmparser.h"
 #include "config.h"
 #include "propsel.h"
-#include "sysfs.h"
 #include "discovery.h"
 #include "prio.h"
 
diff --git a/libmultipath/sysfs.c b/libmultipath/sysfs.c
index 5cd365a..c9dc280 100644
--- a/libmultipath/sysfs.c
+++ b/libmultipath/sysfs.c
@@ -27,6 +27,7 @@
 #include <sys/stat.h>
 #include <string.h>
 #include <dirent.h>
+#include <libudev.h>
 
 #include "checkers.h"
 #include "vector.h"
@@ -37,171 +38,77 @@
 #include "debug.h"
 #include "devmapper.h"
 
-char sysfs_path[PATH_SIZE];
-
-int sysfs_init(char *path, size_t len)
-{
-	if (path) {
-		strlcpy(sysfs_path, path, len);
-		remove_trailing_chars(sysfs_path, '/');
-	} else
-		strlcpy(sysfs_path, "/sys", sizeof(sysfs_path));
-	dbg("sysfs_path='%s'", sysfs_path);
-
-	return 0;
-}
-
-int sysfs_resolve_link(char *devpath, size_t size)
-{
-	char link_path[PATH_SIZE];
-	char link_target[PATH_SIZE];
-	int len;
-	int i;
-	int back;
-
-	strlcpy(link_path, sysfs_path, sizeof(link_path));
-	strlcat(link_path, devpath, sizeof(link_path));
-	len = readlink(link_path, link_target, sizeof(link_target));
-	if (len <= 0)
-		return -1;
-	link_target[len] = '\0';
-	dbg("path link '%s' points to '%s'", devpath, link_target);
-
-	for (back = 0; strncmp(&link_target[back * 3], "../", 3) == 0; back++)
-		;
-	dbg("base '%s', tail '%s', back %i", devpath, &link_target[back * 3], back);
-	for (i = 0; i <= back; i++) {
-		char *pos = strrchr(devpath, '/');
-
-		if (pos == NULL)
-			return -1;
-		pos[0] = '\0';
-	}
-	dbg("after moving back '%s'", devpath);
-	strlcat(devpath, "/", size);
-	strlcat(devpath, &link_target[back * 3], size);
-	return 0;
-}
-
-size_t sysfs_attr_get_value(const char *devpath, const char *attr_name,
-			    char *attr_value, int attr_len)
+ssize_t sysfs_attr_set_value(struct udev_device *dev, const char *attr_name,
+			     char * value, size_t value_len)
 {
-	char path_full[PATH_SIZE];
+	const char *devpath;
 	struct stat statbuf;
 	int fd;
-	ssize_t size;
-	size_t sysfs_len;
+	ssize_t size = -1;
 
-	if (!attr_value || !attr_len)
+	if (!dev || !attr_name || !value)
 		return 0;
 
-	attr_value[0] = '\0';
-	size = 0;
-
-	dbg("open '%s'/'%s'", devpath, attr_name);
-	sysfs_len = strlcpy(path_full, sysfs_path, sizeof(path_full));
-	if(sysfs_len >= sizeof(path_full))
-		sysfs_len = sizeof(path_full) - 1;
-
-	strlcat(path_full, devpath, sizeof(path_full));
-	strlcat(path_full, "/", sizeof(path_full));
-	strlcat(path_full, attr_name, sizeof(path_full));
-
-	if (stat(path_full, &statbuf) != 0) {
-		dbg("stat '%s' failed: %s", path_full, strerror(errno));
-		goto out;
+	devpath = udev_device_get_syspath(dev);
+	condlog(4, "open '%s'/'%s'", devpath, attr_name);
+	if (stat(devpath, &statbuf) != 0) {
+		condlog(4, "stat '%s' failed: %s", devpath, strerror(errno));
+		return 0;
 	}
 
 	/* skip directories */
 	if (S_ISDIR(statbuf.st_mode))
-		goto out;
+		return 0;
 
-	/* skip non-readable files */
-	if ((statbuf.st_mode & S_IRUSR) == 0)
-		goto out;
+	/* skip non-writeable files */
+	if ((statbuf.st_mode & S_IWUSR) == 0)
+		return 0;
 
-	/* read attribute value */
-	fd = open(path_full, O_RDONLY);
+	/* write attribute value */
+	fd = open(devpath, O_WRONLY);
 	if (fd < 0) {
-		dbg("attribute '%s' can not be opened: %s",
-		    path_full, strerror(errno));
-		goto out;
+		condlog(4, "attribute '%s' can not be opened: %s",
+			devpath, strerror(errno));
+		return 0;
 	}
-	size = read(fd, attr_value, attr_len);
-	close(fd);
-	if (size < 0)
-		goto out;
-	if (size == attr_len) {
-		dbg("overflow in attribute '%s', truncating", path_full);
-		size--;
+	size = write(fd, value, value_len);
+	if (size < 0) {
+		condlog(4, "write to %s failed: %s", devpath, strerror(errno));
+		size = 0;
+	} else if (size < value_len) {
+		condlog(4, "tried to write %ld to %s. Wrote %ld\n",
+			(long)value_len, devpath, (long)size);
+		size = 0;
 	}
 
-	/* got a valid value, store and return it */
-	attr_value[size] = '\0';
-	remove_trailing_chars(attr_value, '\n');
-
-out:
+	close(fd);
 	return size;
 }
 
-ssize_t sysfs_attr_set_value(const char *devpath, const char *attr_name,
-			     const char *value, int value_len)
+int
+sysfs_get_size (struct path *pp, unsigned long long * size)
 {
-	char path_full[PATH_SIZE];
-	struct stat statbuf;
-	int fd;
-	ssize_t size = -1;
-	size_t sysfs_len;
-
-	if (!attr_name || !value || !value_len)
-		return 0;
+	const char * attr;
+	int r;
 
-	dbg("open '%s'/'%s'", devpath, attr_name);
-	sysfs_len = snprintf(path_full, PATH_SIZE, "%s%s/%s", sysfs_path,
-			     devpath, attr_name);
-	if (sysfs_len >= PATH_SIZE || sysfs_len < 0) {
-		if (sysfs_len < 0)
-			dbg("cannot copy sysfs path %s%s/%s : %s", sysfs_path,
-			    devpath, attr_name, strerror(errno));
-		else
-			dbg("sysfs_path %s%s/%s too large", sysfs_path,
-			    devpath, attr_name);
-		goto out;
-	}
+	if (!pp->udev)
+		return 1;
 
-	if (stat(path_full, &statbuf) != 0) {
-		dbg("stat '%s' failed: %s", path_full, strerror(errno));
-		goto out;
+	attr = udev_device_get_sysattr_value(pp->udev, "size");
+	if (!attr) {
+		condlog(3, "%s: No size attribute in sysfs", pp->dev);
+		return 1;
 	}
 
-	/* skip directories */
-	if (S_ISDIR(statbuf.st_mode))
-		goto out;
-
-	/* skip non-writeable files */
-	if ((statbuf.st_mode & S_IWUSR) == 0)
-		goto out;
+	r = sscanf(attr, "%llu\n", size);
 
-	/* write attribute value */
-	fd = open(path_full, O_WRONLY);
-	if (fd < 0) {
-		dbg("attribute '%s' can not be opened: %s",
-		    path_full, strerror(errno));
-		goto out;
+	if (r != 1) {
+		condlog(3, "%s: Cannot parse size attribute '%s'",
+			pp->dev, attr);
+		return 1;
 	}
-	size = write(fd, value, value_len);
-	if (size < 0)
-		dbg("write to %s failed: %s", path_full, strerror(errno));
-	else if (size < value_len) {
-		dbg("tried to write %d to %s. Wrote %d\n", value_len,
-		    path_full, size);
-		size = -1;
-	}
-
-	close(fd);
-out:
 
-	return size;
+	return 0;
 }
 
 int sysfs_check_holders(char * check_devt, char * new_devt)
diff --git a/libmultipath/sysfs.h b/libmultipath/sysfs.h
index b5a3f21..13d7545 100644
--- a/libmultipath/sysfs.h
+++ b/libmultipath/sysfs.h
@@ -5,23 +5,8 @@
 #ifndef _LIBMULTIPATH_SYSFS_H
 #define _LIBMULTIPATH_SYSFS_H
 
-#ifdef DEBUG
-# define dbg(format, args...) condlog(4, format, ##args)
-#else
-# define dbg(format, args...) do {} while (0)
-#endif
-
-int sysfs_init(char *path, size_t len);
-void sysfs_cleanup(void);
-struct sysfs_device *sysfs_device_get(const char *devpath);
-struct sysfs_device *sysfs_device_get_parent(struct sysfs_device *dev);
-void sysfs_device_put(struct sysfs_device *dev);
-struct sysfs_device *sysfs_device_verify(struct sysfs_device *dev);
-size_t sysfs_attr_get_value(const char *devpath, const char *attr_name,
-			    char *attr_value, int attr_len);
-ssize_t sysfs_attr_set_value(const char *devpath, const char *attr_name,
-			     const char *value, int value_len);
-int sysfs_resolve_link(char *path, size_t size);
-int sysfs_get_size(struct path *pp, unsigned long long * size);
+ssize_t sysfs_attr_set_value(struct udev_device *dev, const char *attr_name,
+			     char * value, size_t value_len);
+int sysfs_get_size (struct path *pp, unsigned long long * size);
 int sysfs_check_holders(char * check_devt, char * new_devt);
 #endif
diff --git a/multipath/main.c b/multipath/main.c
index 9be52b5..9ea2ae3 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -412,10 +412,6 @@ main (int argc, char *argv[])
 	if (load_config(DEFAULT_CONFIGFILE))
 		exit(1);
 
-	if (sysfs_init(conf->sysfs_dir, FILE_NAME_SIZE)) {
-		condlog(0, "multipath tools need sysfs mounted");
-		exit(1);
-	}
 	while ((arg = getopt(argc, argv, ":dhl::FfM:v:p:b:Brtq")) != EOF ) {
 		switch(arg) {
 		case 1: printf("optarg : %s\n",optarg);
diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index b04a2a9..8dd4a4b 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -79,10 +79,6 @@ default is
 maximal interval between two path checks in seconds; default is
 .I 4 * polling_interval
 .TP
-.B udev_dir
-directory where udev creates its device nodes; default is
-.I /dev
-.TP
 .B multipath_dir
 directory where the dynamic shared objects are stored; default is system
 dependent, commonly
diff --git a/multipathd/main.c b/multipathd/main.c
index b54f6c6..f7625ca 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1607,10 +1607,6 @@ child (void * param)
 	if (!vecs)
 		exit(1);
 
-	if (sysfs_init(conf->sysfs_dir, FILE_NAME_SIZE)) {
-		condlog(0, "can not find sysfs mount point");
-		exit(1);
-	}
 	conf->daemon = 1;
 	udev_set_sync_support(0);
 	/*
-- 
1.7.3.4
