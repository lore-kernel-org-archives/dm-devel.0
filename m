From: tang.junhui@zte.com.cn
Subject: [PATCH 1/2] dm-mpath: Enable hw_handler_params to take
	effect if hw_handler is the same between new and old
Date: Thu, 24 Nov 2016 15:11:48 +0800
Message-ID: <1479971509-6320-1-git-send-email-tang.junhui@zte.com.cn>
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
To: snitzer@redhat.com, agk@redhat.com
Cc: zhang.kai16@zte.com.cn, dm-devel@redhat.com, "tang.junhui" <tang.junhui@zte.com.cn>
List-Id: dm-devel.ids

From: "tang.junhui" <tang.junhui@zte.com.cn>

If the hardware handle which a device has already attached is the same
with m->hw_handler_name, m->hw_handler_params should not be ignored, but
be enabled to take effect.

Signed-off-by: tang.junhui <tang.junhui@zte.com.cn>
---
 drivers/md/dm-mpath.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 0caab4b..b1aba63 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -849,19 +849,23 @@ static struct pgpath *parse_path(struct dm_arg_set *as, struct path_selector *ps
 retain:
 		attached_handler_name = scsi_dh_attached_handler_name(q, GFP_KERNEL);
 		if (attached_handler_name) {
+			/* clear any hw_handler_params associated with
+			 * m->hw_handler_params if a different handler has
+			 * already been attached.
+			 */
+			if(!m->hw_handler_name || strcmp(attached_handler_name, m->hw_handler_name))
+			{
+				kfree(m->hw_handler_params);
+				m->hw_handler_params = NULL;
+			}
 			/*
 			 * Reset hw_handler_name to match the attached handler
-			 * and clear any hw_handler_params associated with the
-			 * ignored handler.
 			 *
 			 * NB. This modifies the table line to show the actual
 			 * handler instead of the original table passed in.
 			 */
 			kfree(m->hw_handler_name);
 			m->hw_handler_name = attached_handler_name;
-
-			kfree(m->hw_handler_params);
-			m->hw_handler_params = NULL;
 		}
 	}
 
-- 
2.8.1.windows.1
