From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 19/20] libmultipath/foreign/nvme: indicate ANA
	support
Date: Sun, 23 Dec 2018 23:21:25 +0100
Message-ID: <20181223222126.30882-20-mwilck@suse.com>
References: <20181223222126.30882-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20181223222126.30882-1-mwilck@suse.com>
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
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

Indicate ANA support in the "hwhandler" output field.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/foreign/Makefile |  2 +-
 libmultipath/foreign/nvme.c   | 47 +++++++++++++++++++++++++++++++++--
 2 files changed, 46 insertions(+), 3 deletions(-)

diff --git a/libmultipath/foreign/Makefile b/libmultipath/foreign/Makefile
index fe98ddf7..713762cb 100644
--- a/libmultipath/foreign/Makefile
+++ b/libmultipath/foreign/Makefile
@@ -3,7 +3,7 @@
 #
 include ../../Makefile.inc
 
-CFLAGS += $(LIB_CFLAGS) -I..
+CFLAGS += $(LIB_CFLAGS) -I.. -I../nvme
 
 # If you add or remove a checker also update multipath/multipath.conf.5
 LIBS= \
diff --git a/libmultipath/foreign/nvme.c b/libmultipath/foreign/nvme.c
index bda9bcc4..838e450e 100644
--- a/libmultipath/foreign/nvme.c
+++ b/libmultipath/foreign/nvme.c
@@ -15,6 +15,8 @@
   along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */
 
+#include "nvme-lib.h"
+#include <sys/types.h>
 #include <sys/sysmacros.h>
 #include <libudev.h>
 #include <stdio.h>
@@ -27,6 +29,7 @@
 #include <dirent.h>
 #include <errno.h>
 #include <ctype.h>
+#include <fcntl.h>
 #include "util.h"
 #include "vector.h"
 #include "generic.h"
@@ -65,6 +68,7 @@ struct nvme_map {
 	dev_t devt;
 	struct _vector pgvec;
 	int nr_live;
+	int ana_supported;
 };
 
 #define NAME_LEN 64 /* buffer length for temp attributes */
@@ -183,11 +187,14 @@ static int snprint_nvme_map(const struct gen_multipath *gmp,
 			return snprintf(buff, len, "%s", "rw");
 	case 'G':
 		return snprintf(buff, len, "%s", THIS);
+	case 'h':
+		if (nvm->ana_supported == YNU_YES)
+			return snprintf(buff, len, "ANA");
 	default:
-		return snprintf(buff, len, N_A);
 		break;
 	}
-	return 0;
+
+	return snprintf(buff, len, N_A);
 }
 
 static const struct _vector*
@@ -567,6 +574,40 @@ out:
 	return blkdev;
 }
 
+static void test_ana_support(struct nvme_map *map, struct udev_device *ctl)
+{
+	const char *dev_t;
+	char sys_path[64];
+	long fd;
+	int rc;
+
+	if (map->ana_supported != YNU_UNDEF)
+		return;
+
+	dev_t = udev_device_get_sysattr_value(ctl, "dev");
+	if (snprintf(sys_path, sizeof(sys_path), "/dev/char/%s", dev_t)
+	    >= sizeof(sys_path))
+		return;
+
+	fd = open(sys_path, O_RDONLY);
+	if (fd == -1) {
+		condlog(2, "%s: error opening %s", __func__, sys_path);
+		return;
+	}
+
+	pthread_cleanup_push(close_fd, (void *)fd);
+	rc = nvme_id_ctrl_ana(fd, NULL);
+	if (rc < 0)
+		condlog(2, "%s: error in nvme_id_ctrl: %s", __func__,
+			strerror(errno));
+	else {
+		map->ana_supported = (rc == 1 ? YNU_YES : YNU_NO);
+		condlog(3, "%s: NVMe ctrl %s: ANA %s supported", __func__, dev_t,
+			rc == 1 ? "is" : "is not");
+	}
+	pthread_cleanup_pop(1);
+}
+
 static void _find_controllers(struct context *ctx, struct nvme_map *map)
 {
 	char pathbuf[PATH_MAX], realbuf[PATH_MAX];
@@ -670,6 +711,8 @@ static void _find_controllers(struct context *ctx, struct nvme_map *map)
 			cleanup_nvme_path(path);
 			continue;
 		}
+		test_ana_support(map, path->ctl);
+
 		path->pg.gen.ops = &nvme_pg_ops;
 		if (vector_alloc_slot(&path->pg.pathvec) == NULL) {
 			cleanup_nvme_path(path);
-- 
2.19.2
