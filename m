From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 2/3] dm-ioctl: fix unsafe use of
	dm_ioctl.data_size
Date: Thu, 22 Nov 2012 19:20:36 -0500 (EST)
Message-ID: <Pine.LNX.4.64.1211221919540.11244@file.rdu.redhat.com>
References: <Pine.LNX.4.64.1211221918270.11244@file.rdu.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.1211221918270.11244@file.rdu.redhat.com>
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

dm-ioctl: fix unsafe use of dm_ioctl.data_size

1. ctl_ioctl calls copy_params
2. copy_params makes a first copy of the beginning of userspace
   parameters into the local variable "tmp"
3. copy_params then validates tmp.data_size and allocates a new
   structure and copies the whole userspace buffer there
4. ctl_ioctl reads userspace data the second time and copies the whole
   buffer into the pointer "param"
5. ctl_ioctl reads param->data_size without any validation and stores it
   in the variable "input_param_size"
6. "input_param_size" is further used as the authoritative size of the
   kernel buffer

The problem is that the userspace code can change the content of user
memory between steps 2. and 4. The userspace can set valid data_size,
call the ioctl, the kernel code concludes that tmp.data_size is valid,
the userspace changes the value to something invalid, the kernel reads
the userspace buffer at step 4. The kernel then uses the invalid value
in param->data_size without any checks.

Thus, userspace can force the kernel to access invalid kernel memory.

This patch fixes it so that "input_param_size" is read in copy_params,
so the validated value is used.

Hopefully, this doesn't have security impact because only root can
access /dev/mapper/control device. But it should be fixed anyway.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@kernel.org

---
 drivers/md/dm-ioctl.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

Index: linux-3.7-rc6/drivers/md/dm-ioctl.c
===================================================================
--- linux-3.7-rc6.orig/drivers/md/dm-ioctl.c	2012-11-22 03:06:49.000000000 +0100
+++ linux-3.7-rc6/drivers/md/dm-ioctl.c	2012-11-22 03:23:47.000000000 +0100
@@ -1585,7 +1585,8 @@ static int check_version(unsigned int cm
 	return r;
 }
 
-static int copy_params(struct dm_ioctl __user *user, struct dm_ioctl **param)
+static int copy_params(struct dm_ioctl __user *user, struct dm_ioctl **param,
+		       size_t *param_size)
 {
 	struct dm_ioctl tmp, *dmi;
 	int secure_data;
@@ -1596,6 +1597,8 @@ static int copy_params(struct dm_ioctl _
 	if (tmp.data_size < (sizeof(tmp) - sizeof(tmp.data)))
 		return -EINVAL;
 
+	*param_size = tmp.data_size;
+
 	secure_data = tmp.flags & DM_SECURE_DATA_FLAG;
 
 	dmi = __vmalloc(tmp.data_size, GFP_NOIO | __GFP_REPEAT | __GFP_HIGH, PAGE_KERNEL);
@@ -1693,12 +1696,11 @@ static int ctl_ioctl(uint command, struc
 	/*
 	 * Copy the parameters into kernel space.
 	 */
-	r = copy_params(user, &param);
+	r = copy_params(user, &param, &input_param_size);
 
 	if (r)
 		return r;
 
-	input_param_size = param->data_size;
 	wipe_buffer = param->flags & DM_SECURE_DATA_FLAG;
 
 	r = validate_params(cmd, param);
