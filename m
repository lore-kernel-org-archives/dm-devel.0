From: Alasdair G Kergon <agk@redhat.com>
Subject: [2.6.29 PATCH] dm ioctl: validate name length when
	renaming
Date: Wed, 7 Jan 2009 13:15:16 +0000
Message-ID: <20090107131516.GT5098@agk.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

From: Milan Broz <mbroz@redhat.com>

When renaming a mapped device validate the length of the new name.

The rename ioctl accepted any correctly-terminated string enclosed
within the data passed from userspace.  The other ioctls enforce a
size limit of DM_NAME_LEN.  If the name is changed and becomes longer
than that, the device can no longer be addressed by name.

Fix it by properly checking for device name length (including
terminating zero).

Cc: stable@kernel.org
Signed-off-by: Milan Broz <mbroz@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
---
 drivers/md/dm-ioctl.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletion(-)

Index: linux-2.6.28/drivers/md/dm-ioctl.c
===================================================================
--- linux-2.6.28.orig/drivers/md/dm-ioctl.c	2009-01-06 15:06:06.000000000 +0000
+++ linux-2.6.28/drivers/md/dm-ioctl.c	2009-01-06 15:07:04.000000000 +0000
@@ -704,7 +704,8 @@ static int dev_rename(struct dm_ioctl *p
 	char *new_name = (char *) param + param->data_start;
 
 	if (new_name < param->data ||
-	    invalid_str(new_name, (void *) param + param_size)) {
+	    invalid_str(new_name, (void *) param + param_size) ||
+	    strlen(new_name) > DM_NAME_LEN - 1) {
 		DMWARN("Invalid new logical volume name supplied.");
 		return -EINVAL;
 	}
