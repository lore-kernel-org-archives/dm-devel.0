From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH] dm mpath: only try to load the scsi_dh module if
	the scsi_dh doesn't exist
Date: Tue,  1 May 2012 13:52:17 -0400
Message-ID: <1335894737-28825-1-git-send-email-snitzer@redhat.com>
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
Cc: agk@redhat.com
List-Id: dm-devel.ids

There have been reports of multipath table loads hanging due to
__request_module hanging (for some unknown reason).

More often than not, the scsi_dh is already available and there is no
need to request_module().

Reported-by: Ben Marzinski <bmarzins@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-mpath.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 922a338..754f38f 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -718,8 +718,8 @@ static int parse_hw_handler(struct dm_arg_set *as, struct multipath *m)
 		return 0;
 
 	m->hw_handler_name = kstrdup(dm_shift_arg(as), GFP_KERNEL);
-	request_module("scsi_dh_%s", m->hw_handler_name);
-	if (scsi_dh_handler_exist(m->hw_handler_name) == 0) {
+	if (!try_then_request_module(scsi_dh_handler_exist(m->hw_handler_name),
+				     "scsi_dh_%s", m->hw_handler_name)) {
 		ti->error = "unknown hardware handler type";
 		ret = -EINVAL;
 		goto fail;
-- 
1.7.1
