From: Milan Broz <mbroz@redhat.com>
Subject: [PATCH] Wipe buffer even if vamlloc fails
Date: Wed,  9 Mar 2011 17:51:56 +0100
Message-ID: <1299689516-2295-1-git-send-email-mbroz@redhat.com>
References: <1299612945-6900-1-git-send-email-mbroz@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1299612945-6900-1-git-send-email-mbroz@redhat.com>
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

We can honor secure data flag even when allocation
of local buffer fails but user params is valid.

Signed-off-by: Milan Broz <mbroz@redhat.com>
---
 drivers/md/dm-ioctl.c |   13 +++++++++----
 1 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index 516def2..4cacdad 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -1504,6 +1504,7 @@ static int check_version(unsigned int cmd, struct dm_ioctl __user *user)
 static int copy_params(struct dm_ioctl __user *user, struct dm_ioctl **param)
 {
 	struct dm_ioctl tmp, *dmi;
+	int secure_data;
 
 	if (copy_from_user(&tmp, user, sizeof(tmp) - sizeof(tmp.data)))
 		return -EFAULT;
@@ -1511,23 +1512,27 @@ static int copy_params(struct dm_ioctl __user *user, struct dm_ioctl **param)
 	if (tmp.data_size < (sizeof(tmp) - sizeof(tmp.data)))
 		return -EINVAL;
 
+	secure_data = tmp.flags & DM_SECURE_DATA_FLAG;
+
 	dmi = vmalloc(tmp.data_size);
-	if (!dmi)
+	if (!dmi) {
+		if (secure_data && clear_user(user, tmp.data_size))
+			return -EFAULT;
 		return -ENOMEM;
+	}
 
 	if (copy_from_user(dmi, user, tmp.data_size))
 		goto bad;
 
 	/* Wipe the user buffer so we do not return it to userspace */
-	if ((tmp.flags & DM_SECURE_DATA_FLAG) &&
-	    clear_user(user, tmp.data_size))
+	if (secure_data && clear_user(user, tmp.data_size))
 		goto bad;
 
 	*param = dmi;
 	return 0;
 
 bad:
-	if (tmp.flags & DM_SECURE_DATA_FLAG)
+	if (secure_data)
 		memset(dmi, 0, tmp.data_size);
 	vfree(dmi);
 	return -EFAULT;
-- 
1.7.2.3
