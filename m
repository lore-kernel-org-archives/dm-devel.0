From: tang.junhui@zte.com.cn
Subject: [PATCH] md/dm-mpath: Add NULL pointer check in
	parse_hw_handler()
Date: Fri, 28 Oct 2016 17:04:46 +0800
Message-ID: <1477645486-8428-1-git-send-email-tang.junhui@zte.com.cn>
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
To: agk@redhat.com, snitzer@redhat.com
Cc: zhang.kai16@zte.com.cn, dm-devel@redhat.com, "tang.junhui" <tang.junhui@zte.com.cn>
List-Id: dm-devel.ids

From: "tang.junhui" <tang.junhui@zte.com.cn>

m->hw_handler_name value should be checked in parse_hw_handler()
after calling kstrdup() to avoid access of NULL pointer.

Signed-off-by: tang.junhui <tang.junhui@zte.com.cn>
---
 drivers/md/dm-mpath.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index d376dc8..77428fb 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -732,6 +732,9 @@ static int parse_hw_handler(struct dm_arg_set *as, struct multipath *m)
 		return 0;
 
 	m->hw_handler_name = kstrdup(dm_shift_arg(as), GFP_KERNEL);
+	if (!m->hw_handler_name)
+		return -ENOMEM;
+
 	if (!try_then_request_module(scsi_dh_handler_exist(m->hw_handler_name),
 				     "scsi_dh_%s", m->hw_handler_name)) {
 		ti->error = "unknown hardware handler type";
-- 
2.8.1.windows.1
