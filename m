From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 09/57] libmultipath: Do not use 'sscanf' for
	parsing integers
Date: Wed, 27 Apr 2016 13:10:10 +0200
Message-ID: <1461755458-29225-10-git-send-email-hare@suse.de>
References: <1461755458-29225-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1461755458-29225-1-git-send-email-hare@suse.de>
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
Cc: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

'sscanf' doesn't really have a way of signalling errors,
so strtoul(l) should be used instead.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/discovery.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 446c91e..324e217 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -6,6 +6,7 @@
 #include <stdio.h>
 #include <ctype.h>
 #include <unistd.h>
+#include <limits.h>
 #include <fcntl.h>
 #include <sys/ioctl.h>
 #include <sys/stat.h>
@@ -237,8 +238,8 @@ sysfs_get_timeout(struct path *pp, unsigned int *timeout)
 	const char *attr = NULL;
 	const char *subsys;
 	struct udev_device *parent;
-	int r;
-	unsigned int t;
+	char *eptr;
+	unsigned long t;
 
 	if (!pp->udev || pp->bus != SYSFS_BUS_SCSI)
 		return -ENOSYS;
@@ -256,14 +257,17 @@ sysfs_get_timeout(struct path *pp, unsigned int *timeout)
 		return -ENXIO;
 	}
 
-	r = sscanf(attr, "%u\n", &t);
-
-	if (r != 1) {
+	t = strtoul(attr, &eptr, 0);
+	if (attr == eptr || t == ULONG_MAX) {
 		condlog(3, "%s: Cannot parse timeout attribute '%s'",
 			pp->dev, attr);
 		return -EINVAL;
 	}
-
+	if (t > UINT_MAX) {
+		condlog(3, "%s: Overflow in timeout value '%s'",
+			pp->dev, attr);
+		return -ERANGE;
+	}
 	*timeout = t;
 
 	return 0;
@@ -482,7 +486,7 @@ static void
 sysfs_set_rport_tmo(struct multipath *mpp, struct path *pp)
 {
 	struct udev_device *rport_dev = NULL;
-	char value[16];
+	char value[16], *eptr;
 	char rport_id[32];
 	unsigned long long tmo = 0;
 	int ret;
@@ -522,7 +526,8 @@ sysfs_set_rport_tmo(struct multipath *mpp, struct path *pp)
 				"error %d", rport_id, -ret);
 			goto out;
 		}
-		if (sscanf(value, "%llu\n", &tmo) != 1) {
+		tmo = strtoull(value, &eptr, 0);
+		if (value == eptr || tmo == ULLONG_MAX) {
 			condlog(0, "%s: Cannot parse dev_loss_tmo "
 				"attribute '%s'", rport_id, value);
 			goto out;
-- 
2.6.6
