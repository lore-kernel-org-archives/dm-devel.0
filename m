From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 3/3] dm-ioctl: use kmalloc if possible
Date: Thu, 22 Nov 2012 19:21:04 -0500 (EST)
Message-ID: <Pine.LNX.4.64.1211221920400.11244@file.rdu.redhat.com>
References: <Pine.LNX.4.64.1211221918270.11244@file.rdu.redhat.com>
	<Pine.LNX.4.64.1211221919540.11244@file.rdu.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.1211221919540.11244@file.rdu.redhat.com>
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

dm-ioctl: use kmalloc if possible

Use kmalloc if possible to allocate the parameters and only fallback to
vmalloc if kmalloc fails.

vmalloc is noticeable slower than kmalloc because it has to manipulate
page tables.

On PA-RISC this patch speeds up activation 13 times.
On Opteron this patch speeds up activation by 5%.

This patch introduces a new variable param_flags that holds flags for
parameter allocation. The variables "int secure_data" and "int
wipe_buffer" were moved to param_flags too (as flag PARAM_SECURE) to
simplify the code.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-ioctl.c |   47 +++++++++++++++++++++++++++++------------------
 1 file changed, 29 insertions(+), 18 deletions(-)

Index: linux-3.7-rc6/drivers/md/dm-ioctl.c
===================================================================
--- linux-3.7-rc6.orig/drivers/md/dm-ioctl.c	2012-11-22 03:30:59.000000000 +0100
+++ linux-3.7-rc6/drivers/md/dm-ioctl.c	2012-11-22 03:44:01.000000000 +0100
@@ -1585,25 +1585,43 @@ static int check_version(unsigned int cm
 	return r;
 }
 
+#define PARAM_VMALLOC		1
+#define PARAM_SECURE		2
+
+static void free_params(struct dm_ioctl *param, size_t param_size,
+			int param_flags)
+{
+	if (param_flags & PARAM_SECURE)
+		memset(param, 0, param_size);
+	if (param_flags & PARAM_VMALLOC)
+		vfree(param);
+	else
+		kfree(param);
+}
+
 static int copy_params(struct dm_ioctl __user *user, struct dm_ioctl **param,
-		       size_t *param_size)
+		       size_t *param_size, int *param_flags)
 {
 	struct dm_ioctl tmp, *dmi;
-	int secure_data;
 
 	if (copy_from_user(&tmp, user, sizeof(tmp) - sizeof(tmp.data)))
 		return -EFAULT;
 
 	*param_size = tmp.data_size;
+	*param_flags = tmp.flags & DM_SECURE_DATA_FLAG ? PARAM_SECURE : 0;
 
 	if (*param_size < (sizeof(tmp) - sizeof(tmp.data)))
 		return -EINVAL;
 
-	secure_data = tmp.flags & DM_SECURE_DATA_FLAG;
-
-	dmi = __vmalloc(*param_size, GFP_NOIO | __GFP_REPEAT | __GFP_HIGH, PAGE_KERNEL);
+	dmi = NULL;
+	if (*param_size <= KMALLOC_MAX_SIZE)
+		dmi = kmalloc(*param_size, GFP_NOIO | __GFP_NORETRY | __GFP_NOMEMALLOC | __GFP_NOWARN);
 	if (!dmi) {
-		if (secure_data && clear_user(user, *param_size))
+		dmi = __vmalloc(*param_size, GFP_NOIO | __GFP_REPEAT | __GFP_HIGH, PAGE_KERNEL);
+		*param_flags |= PARAM_VMALLOC;
+	}
+	if (!dmi) {
+		if (*param_flags & PARAM_SECURE && clear_user(user, *param_size))
 			return -EFAULT;
 		return -ENOMEM;
 	}
@@ -1612,16 +1630,14 @@ static int copy_params(struct dm_ioctl _
 		goto bad;
 
 	/* Wipe the user buffer so we do not return it to userspace */
-	if (secure_data && clear_user(user, *param_size))
+	if (*param_flags & PARAM_SECURE && clear_user(user, *param_size))
 		goto bad;
 
 	*param = dmi;
 	return 0;
 
 bad:
-	if (secure_data)
-		memset(dmi, 0, *param_size);
-	vfree(dmi);
+	free_params(dmi, *param_size, *param_flags);
 	return -EFAULT;
 }
 
@@ -1658,11 +1674,11 @@ static int validate_params(uint cmd, str
 static int ctl_ioctl(uint command, struct dm_ioctl __user *user)
 {
 	int r = 0;
-	int wipe_buffer;
 	unsigned int cmd;
 	struct dm_ioctl *uninitialized_var(param);
 	ioctl_fn fn = NULL;
 	size_t input_param_size;
+	int input_param_flags;
 
 	/* only root can play with this */
 	if (!capable(CAP_SYS_ADMIN))
@@ -1696,13 +1712,11 @@ static int ctl_ioctl(uint command, struc
 	/*
 	 * Copy the parameters into kernel space.
 	 */
-	r = copy_params(user, &param, &input_param_size);
+	r = copy_params(user, &param, &input_param_size, &input_param_flags);
 
 	if (r)
 		return r;
 
-	wipe_buffer = param->flags & DM_SECURE_DATA_FLAG;
-
 	r = validate_params(cmd, param);
 	if (r)
 		goto out;
@@ -1717,10 +1731,7 @@ static int ctl_ioctl(uint command, struc
 		r = -EFAULT;
 
 out:
-	if (wipe_buffer)
-		memset(param, 0, input_param_size);
-
-	vfree(param);
+	free_params(param, input_param_size, input_param_flags);
 	return r;
 }
 
