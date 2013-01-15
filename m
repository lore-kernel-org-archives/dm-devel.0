From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 2/2] dm-ioctl: optimize functions that don't take
 or produce arguments
Date: Mon, 14 Jan 2013 23:21:31 -0500 (EST)
Message-ID: <Pine.LNX.4.64.1301142321070.11994@file.rdu.redhat.com>
References: <Pine.LNX.4.64.1301142320240.11994@file.rdu.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.1301142320240.11994@file.rdu.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Alasdair G. Kergon" <agk@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

dm-ioctl: optimize functions that don't take or produce arguments

libdevmapper supplies default buffer 16384 bytes to all ioctls. However,
some ioctls don't take or produce any arguments, so allocating the
memory for them is not necessary.

This patch avoids the unnecessary allocation and also fixes a possible
deadlock - when some device is suspended, and we send a resume ioctl, we
shouldn't be doing any memory allocation at all.

The variable "struct dm_ioctl tmp" is moved from the function
copy_params to its caller ctl_ioctl. tmp is used directly when the ioctl
function doesn't need any arguments.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-ioctl.c |   52 ++++++++++++++++++++++++++++++++------------------
 1 file changed, 34 insertions(+), 18 deletions(-)

Index: linux-3.8-rc3-fast/drivers/md/dm-ioctl.c
===================================================================
--- linux-3.8-rc3-fast.orig/drivers/md/dm-ioctl.c	2013-01-15 05:17:56.000000000 +0100
+++ linux-3.8-rc3-fast/drivers/md/dm-ioctl.c	2013-01-15 05:18:15.000000000 +0100
@@ -1592,7 +1592,8 @@ static int check_version(unsigned int cm
 	return r;
 }
 
-#define DM_PARAMS_VMALLOC	0x0001	/* Params alloced with vmalloc not kmalloc */
+#define DM_PARAMS_KMALLOC	0x0001	/* Params alloced with kmalloc */
+#define DM_PARAMS_VMALLOC	0x0002	/* Params alloced with vmalloc */
 #define DM_WIPE_BUFFER		0x0010	/* Wipe input buffer before returning from ioctl */
 
 static void free_params(struct dm_ioctl *param, size_t param_size, int param_flags)
@@ -1600,66 +1601,80 @@ static void free_params(struct dm_ioctl 
 	if (param_flags & DM_WIPE_BUFFER)
 		memset(param, 0, param_size);
 
+	if (param_flags & DM_PARAMS_KMALLOC)
+		kfree(param);
 	if (param_flags & DM_PARAMS_VMALLOC)
 		vfree(param);
-	else
-		kfree(param);
 }
 
-static int copy_params(struct dm_ioctl __user *user, struct dm_ioctl **param, int *param_flags)
+static int copy_params(struct dm_ioctl __user *user, struct dm_ioctl *tmp,
+		       int ioctl_flags,
+		       struct dm_ioctl **param, int *param_flags)
 {
-	struct dm_ioctl tmp, *dmi;
+	struct dm_ioctl *dmi;
 	int secure_data;
+	const size_t minimum_data_size = sizeof(*tmp) - sizeof(tmp->data);
 
-	if (copy_from_user(&tmp, user, sizeof(tmp) - sizeof(tmp.data)))
+	if (copy_from_user(tmp, user, minimum_data_size))
 		return -EFAULT;
 
-	if (tmp.data_size < (sizeof(tmp) - sizeof(tmp.data)))
+	if (tmp->data_size < minimum_data_size)
 		return -EINVAL;
 
-	secure_data = tmp.flags & DM_SECURE_DATA_FLAG;
+	secure_data = tmp->flags & DM_SECURE_DATA_FLAG;
 
 	*param_flags = secure_data ? DM_WIPE_BUFFER : 0;
 
+	if (ioctl_flags & IOCTL_FLAGS_NO_PARAMS) {
+		dmi = tmp;
+		dmi->data_size = minimum_data_size;
+		goto data_copied;
+	}
+
 	/*
 	 * Try to avoid low memory issues when a device is suspended.
 	 * Use kmalloc() rather than vmalloc() when we can.
 	 */
 	dmi = NULL;
-	if (tmp.data_size <= KMALLOC_MAX_SIZE)
-		dmi = kmalloc(tmp.data_size, GFP_NOIO | __GFP_NORETRY | __GFP_NOMEMALLOC | __GFP_NOWARN);
+	if (tmp->data_size <= KMALLOC_MAX_SIZE) {
+		dmi = kmalloc(tmp->data_size, GFP_NOIO | __GFP_NORETRY | __GFP_NOMEMALLOC | __GFP_NOWARN);
+		if (dmi)
+			*param_flags |= DM_PARAMS_KMALLOC;
+	}
 
 	if (!dmi) {
-		dmi = __vmalloc(tmp.data_size, GFP_NOIO | __GFP_REPEAT | __GFP_HIGH, PAGE_KERNEL);
-		*param_flags |= DM_PARAMS_VMALLOC;
+		dmi = __vmalloc(tmp->data_size, GFP_NOIO | __GFP_REPEAT | __GFP_HIGH, PAGE_KERNEL);
+		if (dmi)
+			*param_flags |= DM_PARAMS_VMALLOC;
 	}
 
 	if (!dmi) {
-		if (secure_data && clear_user(user, tmp.data_size))
+		if (secure_data && clear_user(user, tmp->data_size))
 			return -EFAULT;
 		return -ENOMEM;
 	}
 
-	if (copy_from_user(dmi, user, tmp.data_size))
+	if (copy_from_user(dmi, user, tmp->data_size))
 		goto bad;
 
+data_copied:
 	/*
 	 * Abort if something changed the ioctl data while it was being copied.
 	 */
-	if (dmi->data_size != tmp.data_size) {
+	if (dmi->data_size != tmp->data_size) {
 		DMERR("rejecting ioctl: data size modified while processing parameters");
 		goto bad;
 	}
 
 	/* Wipe the user buffer so we do not return it to userspace */
-	if (secure_data && clear_user(user, tmp.data_size))
+	if (secure_data && clear_user(user, tmp->data_size))
 		goto bad;
 
 	*param = dmi;
 	return 0;
 
 bad:
-	free_params(dmi, tmp.data_size, *param_flags);
+	free_params(dmi, tmp->data_size, *param_flags);
 
 	return -EFAULT;
 }
@@ -1703,6 +1718,7 @@ static int ctl_ioctl(uint command, struc
 	struct dm_ioctl *uninitialized_var(param);
 	ioctl_fn fn = NULL;
 	size_t input_param_size;
+	struct dm_ioctl tmp;
 
 	/* only root can play with this */
 	if (!capable(CAP_SYS_ADMIN))
@@ -1736,7 +1752,7 @@ static int ctl_ioctl(uint command, struc
 	/*
 	 * Copy the parameters into kernel space.
 	 */
-	r = copy_params(user, &param, &param_flags);
+	r = copy_params(user, &tmp, ioctl_flags, &param, &param_flags);
 
 	if (r)
 		return r;
