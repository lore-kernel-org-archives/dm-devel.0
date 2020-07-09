From: mwilck@suse.com
Subject: [PATCH 28/35] libmultipath: snprint_devices(): use
	udev_enumerate
Date: Thu,  9 Jul 2020 12:16:13 +0200
Message-ID: <20200709101620.6786-29-mwilck@suse.com>
References: <20200709101620.6786-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200709101620.6786-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

From: Martin Wilck <mwilck@suse.com>

Rather than hand-coding the device enumeration, use udev as we do elsewhere,
too. While at it, improve the overflow detection.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/print.c | 75 ++++++++++++++++++++------------------------
 libmultipath/print.h |  2 +-
 2 files changed, 35 insertions(+), 42 deletions(-)

diff --git a/libmultipath/print.c b/libmultipath/print.c
index 298b376..fb94f86 100644
--- a/libmultipath/print.c
+++ b/libmultipath/print.c
@@ -2026,65 +2026,58 @@ int snprint_status(char *buff, int len, const struct vectors *vecs)
 	return fwd;
 }
 
-int snprint_devices(struct config *conf, char * buff, int len,
+int snprint_devices(struct config *conf, char *buff, size_t len,
 		    const struct vectors *vecs)
 {
-	DIR *blkdir;
-	struct dirent *blkdev;
-	struct stat statbuf;
-	char devpath[PATH_MAX];
-	int threshold = MAX_LINE_LEN;
-	int fwd = 0;
+	size_t fwd = 0;
 	int r;
+	struct udev_enumerate *enm;
+	struct udev_list_entry *item, *first;
 
 	struct path * pp;
 
-	if (!(blkdir = opendir("/sys/block")))
+	enm = udev_enumerate_new(udev);
+	if (!enm)
 		return 1;
+	udev_enumerate_add_match_subsystem(enm, "block");
 
-	if ((len - fwd - threshold) <= 0) {
-		closedir(blkdir);
-		return len;
-	}
 	fwd += snprintf(buff + fwd, len - fwd, "available block devices:\n");
+	r = udev_enumerate_scan_devices(enm);
+	if (r < 0)
+		goto out;
 
-	while ((blkdev = readdir(blkdir)) != NULL) {
-		if ((strcmp(blkdev->d_name,".") == 0) ||
-		    (strcmp(blkdev->d_name,"..") == 0))
-			continue;
-
-		if (safe_sprintf(devpath, "/sys/block/%s", blkdev->d_name))
-			continue;
-
-		if (stat(devpath, &statbuf) < 0)
-			continue;
+	first = udev_enumerate_get_list_entry(enm);
+	udev_list_entry_foreach(item, first) {
+		const char *path, *devname, *status;
+		struct udev_device *u_dev;
 
-		if (S_ISDIR(statbuf.st_mode) == 0)
-			continue;
+		path = udev_list_entry_get_name(item);
+		u_dev = udev_device_new_from_syspath(udev, path);
+		devname = udev_device_get_sysname(u_dev);
 
-		if ((len - fwd - threshold)  <= 0) {
-			closedir(blkdir);
-			return len;
-		}
+		fwd += snprintf(buff + fwd, len - fwd, "    %s", devname);
+		if (fwd >= len)
+			break;
 
-		fwd += snprintf(buff + fwd, len - fwd, "    %s",
-				blkdev->d_name);
-		pp = find_path_by_dev(vecs->pathvec, blkdev->d_name);
+		pp = find_path_by_dev(vecs->pathvec, devname);
 		if (!pp) {
 			r = filter_devnode(conf->blist_devnode,
-					   conf->elist_devnode, blkdev->d_name);
+					   conf->elist_devnode,
+					   devname);
 			if (r > 0)
-				fwd += snprintf(buff + fwd, len - fwd,
-						" devnode blacklisted, unmonitored");
-			else if (r <= 0)
-				fwd += snprintf(buff + fwd, len - fwd,
-						" devnode whitelisted, unmonitored");
+				status = "devnode blacklisted, unmonitored";
+			else
+				status = "devnode whitelisted, unmonitored";
 		} else
-			fwd += snprintf(buff + fwd, len - fwd,
-					" devnode whitelisted, monitored");
-		fwd += snprintf(buff + fwd, len - fwd, "\n");
+			status = " devnode whitelisted, monitored";
+
+		fwd += snprintf(buff + fwd, len - fwd, " %s\n", status);
+		udev_device_unref(u_dev);
+		if (fwd >= len)
+			break;
 	}
-	closedir(blkdir);
+out:
+	udev_enumerate_unref(enm);
 
 	if (fwd >= len)
 		return len;
diff --git a/libmultipath/print.h b/libmultipath/print.h
index e8260d0..0042cef 100644
--- a/libmultipath/print.h
+++ b/libmultipath/print.h
@@ -129,7 +129,7 @@ int snprint_multipath_map_json (char * buff, int len,
 int snprint_blacklist_report (struct config *, char *, int);
 int snprint_wildcards (char *, int);
 int snprint_status (char *, int, const struct vectors *);
-int snprint_devices (struct config *, char *, int, const struct vectors *);
+int snprint_devices (struct config *, char *, size_t, const struct vectors *);
 int snprint_path_serial (char *, size_t, const struct path *);
 int snprint_host_wwnn (char *, size_t, const struct path *);
 int snprint_host_wwpn (char *, size_t, const struct path *);
-- 
2.26.2
