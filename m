From: Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 45/72] libmultipath: fix -Wsign-compare warnings
 with snprintf()
Date: Sat, 12 Oct 2019 21:28:33 +0000
Message-ID: <20191012212703.12989-46-martin.wilck@suse.com>
References: <20191012212703.12989-1-martin.wilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20191012212703.12989-1-martin.wilck@suse.com>
Content-Language: en-US
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
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, Martin Wilck <Martin.Wilck@suse.com>
List-Id: dm-devel.ids

From: Martin Wilck <mwilck@suse.com>

snprintf() returns int, and thus its result needs to be compared
with a signed int. In theory, snprintf can return -1 with errno
EOVERFLOW if the "size" argument exceeds INT_MAX, but this can
be quite safely ignored for now.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 kpartx/devmapper.c          | 3 ++-
 kpartx/kpartx.h             | 2 +-
 libmultipath/foreign/nvme.c | 4 ++--
 libmultipath/sysfs.c        | 4 ++--
 libmultipath/util.c         | 3 ++-
 libmultipath/util.h         | 4 ++--
 libmultipath/wwids.c        | 2 +-
 multipath/main.c            | 2 +-
 8 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/kpartx/devmapper.c b/kpartx/devmapper.c
index 3aa4988d..7e599e07 100644
--- a/kpartx/devmapper.c
+++ b/kpartx/devmapper.c
@@ -107,7 +107,8 @@ strip_slash (char * device)
 static int format_partname(char *buf, size_t bufsiz,
 			   const char *mapname, const char *delim, int part)
 {
-	if (snprintf(buf, bufsiz, "%s%s%d", mapname, delim, part) >= bufsiz)
+	if (snprintf(buf, bufsiz, "%s%s%d", mapname, delim, part)
+	    >= (int)bufsiz)
 		return 0;
 	strip_slash(buf);
 	return 1;
diff --git a/kpartx/kpartx.h b/kpartx/kpartx.h
index 52920e43..3ec13dbc 100644
--- a/kpartx/kpartx.h
+++ b/kpartx/kpartx.h
@@ -17,7 +17,7 @@
 #define unlikely(x)     __builtin_expect(!!(x), 0)
 
 #define safe_sprintf(var, format, args...)	\
-	snprintf(var, sizeof(var), format, ##args) >= sizeof(var)
+	snprintf(var, sizeof(var), format, ##args) >= (int)sizeof(var)
 
 #ifndef BLKSSZGET
 #define BLKSSZGET  _IO(0x12,104)	/* get block device sector size */
diff --git a/libmultipath/foreign/nvme.c b/libmultipath/foreign/nvme.c
index e8ca516c..17569b36 100644
--- a/libmultipath/foreign/nvme.c
+++ b/libmultipath/foreign/nvme.c
@@ -592,7 +592,7 @@ static void test_ana_support(struct nvme_map *map, struct udev_device *ctl)
 
 	dev_t = udev_device_get_sysattr_value(ctl, "dev");
 	if (snprintf(sys_path, sizeof(sys_path), "/dev/char/%s", dev_t)
-	    >= sizeof(sys_path))
+	    >= (int)sizeof(sys_path))
 		return;
 
 	fd = open(sys_path, O_RDONLY);
@@ -664,7 +664,7 @@ static void _find_controllers(struct context *ctx, struct nvme_map *map)
 		struct udev_device *ctrl, *udev;
 
 		if (snprintf(pathbuf + n, sizeof(pathbuf) - n, "/%s", fn)
-		    >= sizeof(pathbuf) - n)
+		    >= (int)(sizeof(pathbuf) - n))
 			continue;
 		if (realpath(pathbuf, realbuf) == NULL) {
 			condlog(3, "%s: %s: realpath: %s", __func__, THIS,
diff --git a/libmultipath/sysfs.c b/libmultipath/sysfs.c
index 923b529b..eb1f03e1 100644
--- a/libmultipath/sysfs.c
+++ b/libmultipath/sysfs.c
@@ -306,7 +306,7 @@ bool sysfs_is_multipathed(const struct path *pp)
 	n = snprintf(pathbuf, sizeof(pathbuf), "/sys/block/%s/holders",
 		     pp->dev);
 
-	if (n >= sizeof(pathbuf)) {
+	if (n >= (int)sizeof(pathbuf)) {
 		condlog(1, "%s: pathname overflow", __func__);
 		return false;
 	}
@@ -329,7 +329,7 @@ bool sysfs_is_multipathed(const struct path *pp)
 
 		if (snprintf(pathbuf + n, sizeof(pathbuf) - n,
 			     "/%s/dm/uuid", di[i]->d_name)
-		    >= sizeof(pathbuf) - n)
+		    >= (int)(sizeof(pathbuf) - n))
 			continue;
 
 		fd = open(pathbuf, O_RDONLY);
diff --git a/libmultipath/util.c b/libmultipath/util.c
index ccc0de29..4657e7db 100644
--- a/libmultipath/util.c
+++ b/libmultipath/util.c
@@ -213,7 +213,8 @@ int devt2devname(char *devname, int devname_len, char *devt)
 
 		if ((major == tmpmaj) && (minor == tmpmin)) {
 			if (snprintf(block_path, sizeof(block_path),
-				     "/sys/block/%s", dev) >= sizeof(block_path)) {
+				     "/sys/block/%s", dev)
+			    >= (int)sizeof(block_path)) {
 				condlog(0, "device name %s is too long", dev);
 				fclose(fd);
 				return 1;
diff --git a/libmultipath/util.h b/libmultipath/util.h
index 913ab7c2..cfc3b7a9 100644
--- a/libmultipath/util.h
+++ b/libmultipath/util.h
@@ -29,9 +29,9 @@ void set_max_fds(rlim_t max_fds);
 #define ARRAY_SIZE(x) (sizeof(x)/sizeof((x)[0]))
 
 #define safe_sprintf(var, format, args...)	\
-	snprintf(var, sizeof(var), format, ##args) >= sizeof(var)
+	snprintf((var), sizeof(var), (format), ##args) >= (int)sizeof(var)
 #define safe_snprintf(var, size, format, args...)      \
-	snprintf(var, size, format, ##args) >= size
+	snprintf(var, size, format, ##args) >= (int)size
 
 #define pthread_cleanup_push_cast(f, arg)		\
 	pthread_cleanup_push(((void (*)(void *))&f), (arg))
diff --git a/libmultipath/wwids.c b/libmultipath/wwids.c
index 291db8f5..57c2707b 100644
--- a/libmultipath/wwids.c
+++ b/libmultipath/wwids.c
@@ -394,7 +394,7 @@ static int _failed_wwid_op(const char *wwid, bool rw,
 	int r = -1;
 
 	if (snprintf(path, sizeof(path), "%s/%s", shm_dir, wwid)
-	    >= sizeof(path)) {
+	    >= (int)sizeof(path)) {
 		condlog(1, "%s: path name overflow", __func__);
 		return -1;
 	}
diff --git a/multipath/main.c b/multipath/main.c
index c2ef8c7b..8d518585 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -424,7 +424,7 @@ static int find_multipaths_check_timeout(const struct path *pp, long tmo,
 	clock_gettime(CLOCK_REALTIME, &now);
 
 	if (snprintf(path, sizeof(path), "%s/%s", shm_find_mp_dir, pp->dev_t)
-	    >= sizeof(path)) {
+	    >= (int)sizeof(path)) {
 		condlog(1, "%s: path name overflow", __func__);
 		return FIND_MULTIPATHS_ERROR;
 	}
-- 
2.23.0
