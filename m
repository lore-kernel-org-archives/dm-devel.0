From: Milan Broz <mbroz@redhat.com>
Subject: [PATCH] Fix using of possible uninitialised params
	struct (secure flag)
Date: Tue,  8 Mar 2011 20:35:45 +0100
Message-ID: <1299612945-6900-1-git-send-email-mbroz@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
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

If copy_param() fails, we cannot trust param structure,
so access it only if this call returned success.

Bug introduced in patch adding secure flag to dm-ioctl (currently in linux-next).

Found during regression tests.

Signed-off-by: Milan Broz <mbroz@redhat.com>
---
 drivers/md/dm-ioctl.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index e7af88b..516def2 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -1611,14 +1611,15 @@ static int ctl_ioctl(uint command, struct dm_ioctl __user *user)
 	 * Copy the parameters into kernel space.
 	 */
 	r = copy_params(user, &param);
-	input_param_size = param->data_size;
-	wipe_buffer = param->flags & DM_SECURE_DATA_FLAG;
 
 	current->flags &= ~PF_MEMALLOC;
 
 	if (r)
 		return r;
 
+	input_param_size = param->data_size;
+	wipe_buffer = param->flags & DM_SECURE_DATA_FLAG;
+
 	r = validate_params(cmd, param);
 	if (r)
 		goto out;
-- 
1.7.2.3
