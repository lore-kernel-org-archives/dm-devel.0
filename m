From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v4 18/20] multipath -u: quick check if path is
	multipathed
Date: Wed,  4 Apr 2018 18:16:25 +0200
Message-ID: <20180404161627.6244-19-mwilck@suse.com>
References: <20180404161627.6244-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180404161627.6244-1-mwilck@suse.com>
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
Cc: Julian Andres Klode <julian.klode@canonical.com>, dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

With "find_multipaths smart", we accept paths as valid if they are
already part of a multipath map. This patch avoids doing a full path
and device-mapper map scan for this case, speeding up "multipath -u"
considerably.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/sysfs.c | 66 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 libmultipath/sysfs.h |  2 ++
 multipath/main.c     | 14 ++++++++++-
 3 files changed, 81 insertions(+), 1 deletion(-)

diff --git a/libmultipath/sysfs.c b/libmultipath/sysfs.c
index 97e0997..589eeaf 100644
--- a/libmultipath/sysfs.c
+++ b/libmultipath/sysfs.c
@@ -27,6 +27,7 @@
 #include <string.h>
 #include <dirent.h>
 #include <libudev.h>
+#include <fnmatch.h>
 
 #include "checkers.h"
 #include "vector.h"
@@ -287,3 +288,68 @@ int sysfs_check_holders(char * check_devt, char * new_devt)
 
 	return 0;
 }
+
+static int select_dm_devs(const struct dirent *di)
+{
+	return fnmatch("dm-*", di->d_name, FNM_FILE_NAME) == 0;
+}
+
+static void close_fd(void *arg)
+{
+	close((long)arg);
+}
+
+bool sysfs_is_multipathed(const struct path *pp)
+{
+	char pathbuf[PATH_MAX];
+	struct dirent **di;
+	int n, r, i;
+	bool found = false;
+
+	n = snprintf(pathbuf, sizeof(pathbuf), "/sys/block/%s/holders",
+		     pp->dev);
+
+	if (n >= sizeof(pathbuf)) {
+		condlog(1, "%s: pathname overflow", __func__);
+		return false;
+	}
+
+	r = scandir(pathbuf, &di, select_dm_devs, alphasort);
+	if (r == 0)
+		return false;
+	else if (r < 0) {
+		condlog(1, "%s: error scanning %s", __func__, pathbuf);
+		return false;
+	}
+
+	pthread_cleanup_push(free, di);
+	for (i = 0; i < r && !found; i++) {
+		long fd;
+		int nr;
+		char uuid[6];
+
+		if (snprintf(pathbuf + n, sizeof(pathbuf) - n,
+			     "/%s/dm/uuid", di[i]->d_name)
+		    >= sizeof(pathbuf) - n)
+			continue;
+
+		fd = open(pathbuf, O_RDONLY);
+		if (fd == -1) {
+			condlog(1, "%s: error opening %s", __func__, pathbuf);
+			continue;
+		}
+
+		pthread_cleanup_push(close_fd, (void*)fd);
+		nr = read(fd, uuid, sizeof(uuid));
+		if (nr == sizeof(uuid) && !memcmp(uuid, "mpath-", sizeof(uuid)))
+			found = true;
+		else if (nr < 0) {
+			condlog(1, "%s: error reading from %s: %s",
+				__func__, pathbuf, strerror(errno));
+		}
+		pthread_cleanup_pop(1);
+	}
+	pthread_cleanup_pop(1);
+
+	return found;
+}
diff --git a/libmultipath/sysfs.h b/libmultipath/sysfs.h
index 75c0f9c..9ae30b3 100644
--- a/libmultipath/sysfs.h
+++ b/libmultipath/sysfs.h
@@ -4,6 +4,7 @@
 
 #ifndef _LIBMULTIPATH_SYSFS_H
 #define _LIBMULTIPATH_SYSFS_H
+#include <stdbool.h>
 
 ssize_t sysfs_attr_set_value(struct udev_device *dev, const char *attr_name,
 			     const char * value, size_t value_len);
@@ -13,4 +14,5 @@ ssize_t sysfs_bin_attr_get_value(struct udev_device *dev, const char *attr_name,
 				 unsigned char * value, size_t value_len);
 int sysfs_get_size (struct path *pp, unsigned long long * size);
 int sysfs_check_holders(char * check_devt, char * new_devt);
+bool sysfs_is_multipathed(const struct path *pp);
 #endif
diff --git a/multipath/main.c b/multipath/main.c
index a60a5f3..ae46e5a 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -595,6 +595,15 @@ configure (struct config *conf, enum mpath_cmds cmd,
 			    !ignore_wwids_on(conf)) {
 				goto print_valid;
 			}
+			/*
+			 * Shortcut for find_multipaths smart:
+			 * Quick check if path is already multipathed.
+			 */
+			if (ignore_wwids_on(conf) &&
+			    sysfs_is_multipathed(VECTOR_SLOT(pathvec, 0))) {
+				r = 0;
+				goto print_valid;
+			}
 		}
 	}
 
@@ -667,7 +676,10 @@ configure (struct config *conf, enum mpath_cmds cmd,
 			condlog(3, "%s: path %s is in use: %s",
 				__func__, pp->dev,
 				strerror(errno));
-			r = 1;
+			/*
+			 * Check if we raced with multipathd
+			 */
+			r = !sysfs_is_multipathed(VECTOR_SLOT(pathvec, 0));
 		}
 		goto print_valid;
 	}
-- 
2.16.1
