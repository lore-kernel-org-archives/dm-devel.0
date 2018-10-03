From: Wenwen Wang <wang6495@umn.edu>
Subject: [PATCH] dm ioctl: fix a missing-check bug
Date: Wed,  3 Oct 2018 11:43:59 -0500
Message-ID: <1538585040-13872-1-git-send-email-wang6495@umn.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Wenwen Wang <wang6495@umn.edu>
Cc: Kangjie Lu <kjlu@umn.edu>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, "maintainer:DEVICE-MAPPER LVM" <dm-devel@redhat.com>, open list <linux-kernel@vger.kernel.org>
List-Id: dm-devel.ids

In copy_params(), the struct 'dm_ioctl' is firstly copied from the user
space buffer 'user' to 'param_kernel' and the field 'data_size' is checked
against 'minimum_data_size'. If the check fails, an error code EINVAL will
be returned. Otherwise, the 'data_size' is used to do the second copy,
which copies from the same user-space buffer to 'dmi'. After the second
copy, only 'dmi->data_size' is checked against 'param_kernel->data_size'.
Given that the buffer 'user' resides in the user space, a malicious
user-space process can race to change the content in the buffer between the
two copies. This way, the attacker can inject inconsistent data in
'param_kernel' and 'dmi'.

This patch removes the redundant part in the second copy and reuses the
result in the first copy. It also remove the check of 'data_size' after the
second copy because it is unnecessary with this patch.

Signed-off-by: Wenwen Wang <wang6495@umn.edu>
---
 drivers/md/dm-ioctl.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index b810ea7..b708c69 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -1762,18 +1762,13 @@ static int copy_params(struct dm_ioctl __user *user, struct dm_ioctl *param_kern
 
 	*param_flags |= DM_PARAMS_MALLOC;
 
-	if (copy_from_user(dmi, user, param_kernel->data_size))
+	if (copy_from_user(&dmi->data, (char __user *)user + minimum_data_size,
+				param_kernel->data_size - minimum_data_size))
 		goto bad;
 
-data_copied:
-	/*
-	 * Abort if something changed the ioctl data while it was being copied.
-	 */
-	if (dmi->data_size != param_kernel->data_size) {
-		DMERR("rejecting ioctl: data size modified while processing parameters");
-		goto bad;
-	}
+	memcpy(dmi, param_kernel, minimum_data_size);
 
+data_copied:
 	/* Wipe the user buffer so we do not return it to userspace */
 	if (secure_data && clear_user(user, param_kernel->data_size))
 		goto bad;
-- 
2.7.4
