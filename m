From: Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH v3 45/72] libmultipath: fix -Wsign-compare
 warnings with snprintf()
Date: Thu, 7 Nov 2019 09:27:41 +0000
Message-ID: <20191107092651.10975-2-martin.wilck@suse.com>
References: <20191107092651.10975-1-martin.wilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20191107092651.10975-1-martin.wilck@suse.com>
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
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Bart Van Assche <Bart.VanAssche@sandisk.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, Martin Wilck <Martin.Wilck@suse.com>
List-Id: dm-devel.ids

From: Martin Wilck <mwilck@suse.com>

snprintf() returns int, but the size argument "n" is size_t.
Use safe_snprintf() to avoid -Wsign-compare warnings. At the same
time, improve these macros to check for errors in snprintf(), too.

Note: there are more uses of snprintf() in our code that may
need review, too. For now, I'm fixing only those that were causing
warnings.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 kpartx/devmapper.c          |  3 ++-
 kpartx/kpartx.h             | 11 ++++++++++-
 libmultipath/foreign/nvme.c |  6 ++----
 libmultipath/sysfs.c        |  7 +++----
 libmultipath/util.c         |  3 +--
 libmultipath/util.h         | 11 +++++++++--
 libmultipath/wwids.c        |  3 +--
 multipath/main.c            |  3 +--
 8 files changed, 29 insertions(+), 18 deletions(-)

diff --git a/kpartx/devmapper.c b/kpartx/devmapper.c
index 3aa4988d..b100b5ef 100644
--- a/kpartx/devmapper.c
+++ b/kpartx/devmapper.c
@@ -10,6 +10,7 @@
 #include <errno.h>
 #include <sys/sysmacros.h>
 #include "devmapper.h"
+#include "kpartx.h"
=20
 #define _UUID_PREFIX "part"
 #define UUID_PREFIX _UUID_PREFIX "%d-"
@@ -107,7 +108,7 @@ strip_slash (char * device)
 static int format_partname(char *buf, size_t bufsiz,
 =09=09=09   const char *mapname, const char *delim, int part)
 {
-=09if (snprintf(buf, bufsiz, "%s%s%d", mapname, delim, part) >=3D bufsiz)
+=09if (safe_snprintf(buf, bufsiz, "%s%s%d", mapname, delim, part))
 =09=09return 0;
 =09strip_slash(buf);
 =09return 1;
diff --git a/kpartx/kpartx.h b/kpartx/kpartx.h
index 52920e43..8a2db046 100644
--- a/kpartx/kpartx.h
+++ b/kpartx/kpartx.h
@@ -16,8 +16,17 @@
 #define likely(x)       __builtin_expect(!!(x), 1)
 #define unlikely(x)     __builtin_expect(!!(x), 0)
=20
+#define safe_snprintf(var, size, format, args...)=09=09=09\
+=09({=09=09=09=09=09=09=09=09\
+=09=09size_t __size =3D size;=09=09=09=09=09\
+=09=09int __ret;=09=09=09=09=09=09\
+=09=09=09=09=09=09=09=09=09\
+=09=09__ret =3D snprintf(var, __size, format, ##args);=09=09\
+=09=09__ret < 0 || (size_t)__ret >=3D __size;=09=09=09\
+=09})
+
 #define safe_sprintf(var, format, args...)=09\
-=09snprintf(var, sizeof(var), format, ##args) >=3D sizeof(var)
+=09=09safe_snprintf(var, sizeof(var), format, ##args)
=20
 #ifndef BLKSSZGET
 #define BLKSSZGET  _IO(0x12,104)=09/* get block device sector size */
diff --git a/libmultipath/foreign/nvme.c b/libmultipath/foreign/nvme.c
index e8ca516c..09cdddf0 100644
--- a/libmultipath/foreign/nvme.c
+++ b/libmultipath/foreign/nvme.c
@@ -591,8 +591,7 @@ static void test_ana_support(struct nvme_map *map, stru=
ct udev_device *ctl)
 =09=09return;
=20
 =09dev_t =3D udev_device_get_sysattr_value(ctl, "dev");
-=09if (snprintf(sys_path, sizeof(sys_path), "/dev/char/%s", dev_t)
-=09    >=3D sizeof(sys_path))
+=09if (safe_sprintf(sys_path, "/dev/char/%s", dev_t))
 =09=09return;
=20
 =09fd =3D open(sys_path, O_RDONLY);
@@ -663,8 +662,7 @@ static void _find_controllers(struct context *ctx, stru=
ct nvme_map *map)
 =09=09char *fn =3D di[i]->d_name;
 =09=09struct udev_device *ctrl, *udev;
=20
-=09=09if (snprintf(pathbuf + n, sizeof(pathbuf) - n, "/%s", fn)
-=09=09    >=3D sizeof(pathbuf) - n)
+=09=09if (safe_snprintf(pathbuf + n, sizeof(pathbuf) - n, "/%s", fn))
 =09=09=09continue;
 =09=09if (realpath(pathbuf, realbuf) =3D=3D NULL) {
 =09=09=09condlog(3, "%s: %s: realpath: %s", __func__, THIS,
diff --git a/libmultipath/sysfs.c b/libmultipath/sysfs.c
index 923b529b..62ec2ed7 100644
--- a/libmultipath/sysfs.c
+++ b/libmultipath/sysfs.c
@@ -306,7 +306,7 @@ bool sysfs_is_multipathed(const struct path *pp)
 =09n =3D snprintf(pathbuf, sizeof(pathbuf), "/sys/block/%s/holders",
 =09=09     pp->dev);
=20
-=09if (n >=3D sizeof(pathbuf)) {
+=09if (n < 0 || (size_t)n >=3D sizeof(pathbuf)) {
 =09=09condlog(1, "%s: pathname overflow", __func__);
 =09=09return false;
 =09}
@@ -327,9 +327,8 @@ bool sysfs_is_multipathed(const struct path *pp)
 =09=09int nr;
 =09=09char uuid[6];
=20
-=09=09if (snprintf(pathbuf + n, sizeof(pathbuf) - n,
-=09=09=09     "/%s/dm/uuid", di[i]->d_name)
-=09=09    >=3D sizeof(pathbuf) - n)
+=09=09if (safe_snprintf(pathbuf + n, sizeof(pathbuf) - n,
+=09=09=09=09  "/%s/dm/uuid", di[i]->d_name))
 =09=09=09continue;
=20
 =09=09fd =3D open(pathbuf, O_RDONLY);
diff --git a/libmultipath/util.c b/libmultipath/util.c
index ccc0de29..51c38c87 100644
--- a/libmultipath/util.c
+++ b/libmultipath/util.c
@@ -212,8 +212,7 @@ int devt2devname(char *devname, int devname_len, char *=
devt)
 =09=09=09continue;
=20
 =09=09if ((major =3D=3D tmpmaj) && (minor =3D=3D tmpmin)) {
-=09=09=09if (snprintf(block_path, sizeof(block_path),
-=09=09=09=09     "/sys/block/%s", dev) >=3D sizeof(block_path)) {
+=09=09=09if (safe_sprintf(block_path, "/sys/block/%s", dev)) {
 =09=09=09=09condlog(0, "device name %s is too long", dev);
 =09=09=09=09fclose(fd);
 =09=09=09=09return 1;
diff --git a/libmultipath/util.h b/libmultipath/util.h
index 913ab7c2..56bd78c7 100644
--- a/libmultipath/util.h
+++ b/libmultipath/util.h
@@ -29,9 +29,16 @@ void set_max_fds(rlim_t max_fds);
 #define ARRAY_SIZE(x) (sizeof(x)/sizeof((x)[0]))
=20
 #define safe_sprintf(var, format, args...)=09\
-=09snprintf(var, sizeof(var), format, ##args) >=3D sizeof(var)
+=09safe_snprintf(var, sizeof(var), format, ##args)
+
 #define safe_snprintf(var, size, format, args...)      \
-=09snprintf(var, size, format, ##args) >=3D size
+=09({=09=09=09=09=09=09=09=09\
+=09=09size_t __size =3D size;=09=09=09=09=09\
+=09=09int __ret;=09=09=09=09=09=09\
+=09=09=09=09=09=09=09=09=09\
+=09=09__ret =3D snprintf(var, __size, format, ##args);=09=09\
+=09=09__ret < 0 || (size_t)__ret >=3D __size;=09=09=09\
+=09})
=20
 #define pthread_cleanup_push_cast(f, arg)=09=09\
 =09pthread_cleanup_push(((void (*)(void *))&f), (arg))
diff --git a/libmultipath/wwids.c b/libmultipath/wwids.c
index 291db8f5..28a2150d 100644
--- a/libmultipath/wwids.c
+++ b/libmultipath/wwids.c
@@ -393,8 +393,7 @@ static int _failed_wwid_op(const char *wwid, bool rw,
 =09long lockfd;
 =09int r =3D -1;
=20
-=09if (snprintf(path, sizeof(path), "%s/%s", shm_dir, wwid)
-=09    >=3D sizeof(path)) {
+=09if (safe_sprintf(path, "%s/%s", shm_dir, wwid)) {
 =09=09condlog(1, "%s: path name overflow", __func__);
 =09=09return -1;
 =09}
diff --git a/multipath/main.c b/multipath/main.c
index c2ef8c7b..c553437b 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -423,8 +423,7 @@ static int find_multipaths_check_timeout(const struct p=
ath *pp, long tmo,
=20
 =09clock_gettime(CLOCK_REALTIME, &now);
=20
-=09if (snprintf(path, sizeof(path), "%s/%s", shm_find_mp_dir, pp->dev_t)
-=09    >=3D sizeof(path)) {
+=09if (safe_sprintf(path, "%s/%s", shm_find_mp_dir, pp->dev_t)) {
 =09=09condlog(1, "%s: path name overflow", __func__);
 =09=09return FIND_MULTIPATHS_ERROR;
 =09}
--=20
2.23.0
