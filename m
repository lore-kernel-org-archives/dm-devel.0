From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [2.6.24 PATCH 02/25] dm io:ctl use constant struct size
Date: Sat, 13 Oct 2007 00:16:29 +0200
Message-ID: <200710130016.29937.arnd@arndb.de>
References: <20071012170509.GM24157@agk.fab.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1760648AbXJLWQu@vger.kernel.org>
In-Reply-To: <20071012170509.GM24157@agk.fab.redhat.com>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Alasdair G Kergon <agk@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, dm-devel@redhat.com, linux-kernel@vger.kernel.org, Milan Broz <mbroz@redhat.com>, Guido Guenther <agx@sigxcpu.org>, Kevin Corry <kevcorry@us.ibm.com>, stable@kernel.org
List-Id: dm-devel.ids

On Friday 12 October 2007, Alasdair G Kergon wrote:
> Make size of dm_ioctl struct always 312 bytes on all supported
> architectures.
>=20
> This change retains compatibility with already-compiled code because
> it uses an embedded offset to locate the payload that follows the
> structure.
>=20
> On 64-bit architectures there is no change at all; on 32-bit
> we are increasing the size of dm-ioctl from 308 to 312 bytes.
>=20
> Currently with 32-bit userspace / 64-bit kernel on x86_64
> some ioctls (including rename, message) are incorrectly rejected
> by the comparison against 'param + 1'. =A0This breaks userspace
> lvrename and multipath 'fail_if_no_path' changes, for example.
>=20
> (BTW Device-mapper uses its own versioning and ignores the ioctl
> size bits. =A0Only the generic ioctl compat code on mixed arches
> checks them, and that will continue to accept both sizes for now,
> but we intend to list 308 as deprecated and eventually remove it.)
>=20
> Signed-off-by: Milan Broz <mbroz@redhat.com>
> Signed-off-by: Alasdair G Kergon <agk@redhat.com>
> Cc: Guido Guenther <agx@sigxcpu.org>
> Cc: Kevin Corry <kevcorry@us.ibm.com>
> Cc: stable@kernel.org
>=20

This change seems rather bogus, you're changing the ABI just to work
around a bug in the compat_ioctl layer. Why not just do the compat
code the right way, like the patch below?

	Arnd <><

---
dm: move compat_ioctl handling to dm-ioctl.c

Device mapper ioctl numbers use a variable size field

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index b441d82..a662279 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -700,7 +700,7 @@ static int dev_rename(struct dm_ioctl *param, size_=
t param_size)
 	int r;
 	char *new_name =3D (char *) param + param->data_start;
=20
-	if (new_name < (char *) (param + 1) ||
+	if (new_name < (char *)param + param->data_size ||
 	    invalid_str(new_name, (void *) param + param_size)) {
 		DMWARN("Invalid new logical volume name supplied.");
 		return -EINVAL;
@@ -726,7 +726,7 @@ static int dev_set_geometry(struct dm_ioctl *param,=
 size_t param_size)
 	if (!md)
 		return -ENXIO;
=20
-	if (geostr < (char *) (param + 1) ||
+	if (geostr < (char *)param + param->data_size ||
 	    invalid_str(geostr, (void *) param + param_size)) {
 		DMWARN("Invalid geometry supplied.");
 		goto out;
@@ -1233,7 +1233,7 @@ static int target_message(struct dm_ioctl *param,=
 size_t param_size)
 	if (r)
 		goto out;
=20
-	if (tmsg < (struct dm_target_msg *) (param + 1) ||
+	if (tmsg < (struct dm_target_msg *) ((char *)param + param->data_size=
) ||
 	    invalid_str(tmsg->message, (void *) param + param_size)) {
 		DMWARN("Invalid target message parameters.");
 		r =3D -EINVAL;
@@ -1348,11 +1348,11 @@ static void free_params(struct dm_ioctl *param)
 	vfree(param);
 }
=20
-static int copy_params(struct dm_ioctl __user *user, struct dm_ioctl *=
*param)
+static int copy_params(struct dm_ioctl __user *user, struct dm_ioctl *=
*param, uint ulen)
 {
 	struct dm_ioctl tmp, *dmi;
=20
-	if (copy_from_user(&tmp, user, sizeof(tmp)))
+	if (copy_from_user(&tmp, user, ulen))
 		return -EFAULT;
=20
 	if (tmp.data_size < sizeof(tmp))
@@ -1399,13 +1399,11 @@ static int validate_params(uint cmd, struct dm_=
ioctl *param)
 	return 0;
 }
=20
-static int ctl_ioctl(struct inode *inode, struct file *file,
-		     uint command, ulong u)
+static int ctl_ioctl(uint command, struct dm_ioctl __user *user, uint =
ulen)
 {
 	int r =3D 0;
 	unsigned int cmd;
 	struct dm_ioctl *param;
-	struct dm_ioctl __user *user =3D (struct dm_ioctl __user *) u;
 	ioctl_fn fn =3D NULL;
 	size_t param_size;
=20
@@ -1447,7 +1445,7 @@ static int ctl_ioctl(struct inode *inode, struct =
file *file,
 	/*
 	 * Copy the parameters into kernel space.
 	 */
-	r =3D copy_params(user, &param);
+	r =3D copy_params(user, &param, ulen);
=20
 	current->flags &=3D ~PF_MEMALLOC;
=20
@@ -1459,7 +1457,7 @@ static int ctl_ioctl(struct inode *inode, struct =
file *file,
 		goto out;
=20
 	param_size =3D param->data_size;
-	param->data_size =3D sizeof(*param);
+	param->data_size =3D ulen;
 	r =3D fn(param, param_size);
=20
 	/*
@@ -1473,8 +1471,64 @@ static int ctl_ioctl(struct inode *inode, struct=
 file *file,
 	return r;
 }
=20
+static int ctl_ioctl(struct inode *inode, struct file *file,
+		     uint command, ulong u)
+{
+	return ctl_do_ioctl(command, (void __user *)u, sizeof (struct dm_ioct=
l));
+}
+
+#ifdef CONFIG_COMPAT
+struct compat_dm_ioctl {
+	/*
+	 * The version number is made up of three parts:
+	 * major - no backward or forward compatibility,
+	 * minor - only backwards compatible,
+	 * patch - both backwards and forwards compatible.
+	 *
+	 * All clients of the ioctl interface should fill in the
+	 * version number of the interface that they were
+	 * compiled with.
+	 *
+	 * All recognised ioctl commands (ie. those that don't
+	 * return -ENOTTY) fill out this field, even if the
+	 * command failed.
+	 */
+	uint32_t version[3];	/* in/out */
+	uint32_t data_size;	/* total size of data passed in
+				 * including this struct */
+
+	uint32_t data_start;	/* offset to start of data
+				 * relative to start of this struct */
+
+	uint32_t target_count;	/* in/out */
+	int32_t open_count;	/* out */
+	uint32_t flags;		/* in/out */
+	uint32_t event_nr;	/* in/out */
+	uint32_t padding;
+
+	compat_u64 dev;		/* in/out */
+
+	char name[DM_NAME_LEN];	/* device name */
+	char uuid[DM_UUID_LEN];	/* unique identifier for
+				 * the block device */
+};
+
+static int compat_ctl_ioctl(struct inode *inode, struct file *file,
+		     uint command, ulong u)
+{
+	int ret =3D 0;
+	lock_kernel();
+	ret =3D ctl_do_ioctl(command, compat_ptr(u), sizeof(struct compat_dm_=
ioctl));
+	unlock_kernel();
+	return ret;
+}
+#else
+#define compat_ctl_ioctl NULL
+#endif
+
 static const struct file_operations _ctl_fops =3D {
 	.ioctl	 =3D ctl_ioctl,
+	.compat_ioctl =3D compat_ctl_ioctl,
 	.owner	 =3D THIS_MODULE,
 };
=20
--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@ -76,7 +76,6 @@
 #include <linux/mii.h>
 #include <linux/if_bonding.h>
 #include <linux/watchdog.h>
-#include <linux/dm-ioctl.h>
=20
 #include <linux/soundcard.h>
 #include <linux/lp.h>
@@ -1986,39 +1985,6 @@ COMPATIBLE_IOCTL(STOP_ARRAY_RO)
 COMPATIBLE_IOCTL(RESTART_ARRAY_RW)
 COMPATIBLE_IOCTL(GET_BITMAP_FILE)
 ULONG_IOCTL(SET_BITMAP_FILE)
-/* DM */
-COMPATIBLE_IOCTL(DM_VERSION_32)
-COMPATIBLE_IOCTL(DM_REMOVE_ALL_32)
-COMPATIBLE_IOCTL(DM_LIST_DEVICES_32)
-COMPATIBLE_IOCTL(DM_DEV_CREATE_32)
-COMPATIBLE_IOCTL(DM_DEV_REMOVE_32)
-COMPATIBLE_IOCTL(DM_DEV_RENAME_32)
-COMPATIBLE_IOCTL(DM_DEV_SUSPEND_32)
-COMPATIBLE_IOCTL(DM_DEV_STATUS_32)
-COMPATIBLE_IOCTL(DM_DEV_WAIT_32)
-COMPATIBLE_IOCTL(DM_TABLE_LOAD_32)
-COMPATIBLE_IOCTL(DM_TABLE_CLEAR_32)
-COMPATIBLE_IOCTL(DM_TABLE_DEPS_32)
-COMPATIBLE_IOCTL(DM_TABLE_STATUS_32)
-COMPATIBLE_IOCTL(DM_LIST_VERSIONS_32)
-COMPATIBLE_IOCTL(DM_TARGET_MSG_32)
-COMPATIBLE_IOCTL(DM_DEV_SET_GEOMETRY_32)
-COMPATIBLE_IOCTL(DM_VERSION)
-COMPATIBLE_IOCTL(DM_REMOVE_ALL)
-COMPATIBLE_IOCTL(DM_LIST_DEVICES)
-COMPATIBLE_IOCTL(DM_DEV_CREATE)
-COMPATIBLE_IOCTL(DM_DEV_REMOVE)
-COMPATIBLE_IOCTL(DM_DEV_RENAME)
-COMPATIBLE_IOCTL(DM_DEV_SUSPEND)
-COMPATIBLE_IOCTL(DM_DEV_STATUS)
-COMPATIBLE_IOCTL(DM_DEV_WAIT)
-COMPATIBLE_IOCTL(DM_TABLE_LOAD)
-COMPATIBLE_IOCTL(DM_TABLE_CLEAR)
-COMPATIBLE_IOCTL(DM_TABLE_DEPS)
-COMPATIBLE_IOCTL(DM_TABLE_STATUS)
-COMPATIBLE_IOCTL(DM_LIST_VERSIONS)
-COMPATIBLE_IOCTL(DM_TARGET_MSG)
-COMPATIBLE_IOCTL(DM_DEV_SET_GEOMETRY)
 /* Big K */
 COMPATIBLE_IOCTL(PIO_FONT)
 COMPATIBLE_IOCTL(GIO_FONT)
