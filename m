From: Peter Jones <pjones@redhat.com>
Subject: [PATCH] Fix missing dm_put()
Date: Mon, 18 Oct 2010 10:39:41 -0400
Message-ID: <1287412781-26119-1-git-send-email-pjones@redhat.com>
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
Cc: Peter Jones <pjones@redhat.com>
List-Id: dm-devel.ids

The change to make UUID setable after map creation was missing one
dm_put() call; this patch adds it.
---
 drivers/md/dm-ioctl.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index 22c2e22..e2d106b 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -351,6 +351,7 @@ static struct mapped_device *dm_hash_rename(struct dm_ioctl *param,
 			DMWARN("Unable to change uuid of device, %s because "
 			       "uuid is already set to %s",
 			       param->name, hc->uuid);
+			dm_put(hd->md);
 			up_write(&_hash_lock);
 			kfree(new_data);
 			return ERR_PTR(-EINVAL);
-- 
1.7.2.2
