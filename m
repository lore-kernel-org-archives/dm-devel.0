From: Milan Broz <mbroz@redhat.com>
Subject: [PATCH 2/3] dm ioctl: tidy code for next change
Date: Thu,  3 Feb 2011 01:08:15 +0100
Message-ID: <1296691696-23722-2-git-send-email-mbroz@redhat.com>
References: <1296691696-23722-1-git-send-email-mbroz@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1296691696-23722-1-git-send-email-mbroz@redhat.com>
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
Cc: Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

Prepare code for implementing buffer wipe flag.
No functional change in this patch.

Signed-off-by: Milan Broz <mbroz@redhat.com>
---
 drivers/md/dm-ioctl.c |   21 ++++++++-------------
 1 files changed, 8 insertions(+), 13 deletions(-)

diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index 6d12775..189c7ab 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -1501,11 +1501,6 @@ static int check_version(unsigned int cmd, struct dm_ioctl __user *user)
 	return r;
 }
 
-static void free_params(struct dm_ioctl *param)
-{
-	vfree(param);
-}
-
 static int copy_params(struct dm_ioctl __user *user, struct dm_ioctl **param)
 {
 	struct dm_ioctl tmp, *dmi;
@@ -1520,13 +1515,14 @@ static int copy_params(struct dm_ioctl __user *user, struct dm_ioctl **param)
 	if (!dmi)
 		return -ENOMEM;
 
-	if (copy_from_user(dmi, user, tmp.data_size)) {
-		vfree(dmi);
-		return -EFAULT;
-	}
+	if (copy_from_user(dmi, user, tmp.data_size))
+		goto fail;
 
 	*param = dmi;
 	return 0;
+fail:
+	vfree(dmi);
+	return -EFAULT;
 }
 
 static int validate_params(uint cmd, struct dm_ioctl *param)
@@ -1605,6 +1601,7 @@ static int ctl_ioctl(uint command, struct dm_ioctl __user *user)
 	 * Copy the parameters into kernel space.
 	 */
 	r = copy_params(user, &param);
+	param_size = param->data_size;
 
 	current->flags &= ~PF_MEMALLOC;
 
@@ -1615,7 +1612,6 @@ static int ctl_ioctl(uint command, struct dm_ioctl __user *user)
 	if (r)
 		goto out;
 
-	param_size = param->data_size;
 	param->data_size = sizeof(*param);
 	r = fn(param, param_size);
 
@@ -1624,9 +1620,8 @@ static int ctl_ioctl(uint command, struct dm_ioctl __user *user)
 	 */
 	if (!r && copy_to_user(user, param, param->data_size))
 		r = -EFAULT;
-
- out:
-	free_params(param);
+out:
+	vfree(param);
 	return r;
 }
 
-- 
1.7.2.3
