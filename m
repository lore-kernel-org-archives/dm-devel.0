From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 04/33] multipath: do not check daemon from udev
	rules
Date: Tue, 28 Feb 2017 17:23:00 +0100
Message-ID: <20170228162329.14517-5-mwilck@suse.com>
References: <20170228162329.14517-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170228162329.14517-1-mwilck@suse.com>
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

From: Hannes Reinecke <hare@suse.de>

As stated previously, multipathd needs to start after udev trigger
has run as otherwise it won't be able to find any devices.
However, this also means that during udevadm trigger the daemon
wouldn't run, and consequently the check in the udev rules will
always be false, causing the device not to be marked as multipath
capable.

As it turns out, calling 'multipath' from udev rules has quite some
challenges. It _should_ check if a device is eligible for multipathing.
But it needs to work under all circumstances, even if the daemon isn't
running yet, as the program will be called from uevents which might
(and will) come in before the daemon is running.
To check if the daemon _should_ be run I'm checking the various
'.wants' directories from systemd, which carries links to the services
systemd will enable eventually. So if the multipathd.service is
listed in there it will be started, even if it isn't started yet.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 libmultipath/util.c | 59 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 libmultipath/util.h |  1 +
 multipath/main.c    | 13 +++++++-----
 3 files changed, 68 insertions(+), 5 deletions(-)

diff --git a/libmultipath/util.c b/libmultipath/util.c
index 1841f359..be454cb1 100644
--- a/libmultipath/util.c
+++ b/libmultipath/util.c
@@ -6,13 +6,16 @@
 #include <sys/stat.h>
 #include <sys/sysmacros.h>
 #include <sys/types.h>
+#include <dirent.h>
 #include <unistd.h>
+#include <errno.h>
 
 #include "debug.h"
 #include "memory.h"
 #include "checkers.h"
 #include "vector.h"
 #include "structs.h"
+#include "log.h"
 
 size_t
 strchop(char *str)
@@ -279,3 +282,59 @@ setup_thread_attr(pthread_attr_t *attr, size_t stacksize, int detached)
 		assert(ret == 0);
 	}
 }
+
+int systemd_service_enabled_in(const char *dev, const char *prefix)
+{
+	char path[PATH_SIZE], file[PATH_SIZE], service[PATH_SIZE];
+	DIR *dirfd;
+	struct dirent *d;
+	int found = 0;
+
+	snprintf(service, PATH_SIZE, "multipathd.service");
+	snprintf(path, PATH_SIZE, "%s/systemd/system", prefix);
+	condlog(3, "%s: checking for %s in %s", dev, service, path);
+
+	dirfd = opendir(path);
+	if (dirfd == NULL)
+		return 0;
+
+	while ((d = readdir(dirfd)) != NULL) {
+		char *p;
+		struct stat stbuf;
+
+		if ((strcmp(d->d_name,".") == 0) ||
+		    (strcmp(d->d_name,"..") == 0))
+			continue;
+
+		if (strlen(d->d_name) < 6)
+			continue;
+
+		p = d->d_name + strlen(d->d_name) - 6;
+		if (strcmp(p, ".wants"))
+			continue;
+		snprintf(file, PATH_SIZE, "%s/%s/%s",
+			 path, d->d_name, service);
+		if (stat(file, &stbuf) == 0) {
+			condlog(3, "%s: found %s", dev, file);
+			found++;
+			break;
+		}
+	}
+	closedir(dirfd);
+
+	return found;
+}
+
+int systemd_service_enabled(const char *dev)
+{
+	int found = 0;
+
+	found = systemd_service_enabled_in(dev, "/etc");
+	if (!found)
+		found = systemd_service_enabled_in(dev, "/usr/lib");
+	if (!found)
+		found = systemd_service_enabled_in(dev, "/lib");
+	if (!found)
+		found = systemd_service_enabled_in(dev, "/run");
+	return found;
+}
diff --git a/libmultipath/util.h b/libmultipath/util.h
index f3b37ee9..4c1f85c3 100644
--- a/libmultipath/util.h
+++ b/libmultipath/util.h
@@ -13,6 +13,7 @@ int devt2devname (char *, int, char *);
 dev_t parse_devt(const char *dev_t);
 char *convert_dev(char *dev, int is_path_device);
 void setup_thread_attr(pthread_attr_t *attr, size_t stacksize, int detached);
+int systemd_service_enabled(const char *dev);
 
 #define safe_sprintf(var, format, args...)	\
 	snprintf(var, sizeof(var), format, ##args) >= sizeof(var)
diff --git a/multipath/main.c b/multipath/main.c
index 171c08b4..befe4c53 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -682,11 +682,14 @@ main (int argc, char *argv[])
 
 		fd = mpath_connect();
 		if (fd == -1) {
-			printf("%s is not a valid multipath device path\n",
-				dev);
-			goto out;
-		}
-		mpath_disconnect(fd);
+			condlog(3, "%s: daemon is not running", dev);
+			if (!systemd_service_enabled(dev)) {
+				printf("%s is not a valid "
+				       "multipath device path\n", dev);
+				goto out;
+			}
+		} else
+			mpath_disconnect(fd);
 	}
 	if (cmd == CMD_REMOVE_WWID && !dev) {
 		condlog(0, "the -w option requires a device");
-- 
2.11.0
