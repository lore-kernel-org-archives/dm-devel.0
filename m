From: Bryan Gurney <bgurney@redhat.com>
Subject: [PATCH v4 3/4] dm dust: add interface to list all
	badblocks
Date: Fri, 19 Jun 2020 17:12:42 -0400
Message-ID: <1592601162-4107-1-git-send-email-bgurney@redhat.com>
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
To: dm-devel@redhat.com, snitzer@redhat.com, agk@redhat.com
Cc: yangerkun <yangerkun@huawei.com>, Bryan Gurney <bgurney@redhat.com>
List-Id: dm-devel.ids

From: yangerkun <yangerkun@huawei.com>

From: yangerkun <yangerkun@huawei.com>

This interface may help anyone who want to know all badblocks without
query block for each.

[Bryan: DMEMIT an empty list if no blocks are in the bad block list.]

Signed-off-by: yangerkun <yangerkun@huawei.com>
Signed-off-by: Bryan Gurney <bgurney@redhat.com>
---
 drivers/md/dm-dust.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/drivers/md/dm-dust.c b/drivers/md/dm-dust.c
index f1f2dd6a4e84..f7be00a54268 100644
--- a/drivers/md/dm-dust.c
+++ b/drivers/md/dm-dust.c
@@ -284,6 +284,31 @@ static int dust_clear_badblocks(struct dust_device *dd, char *result, unsigned i
 	return 1;
 }
 
+static int dust_list_badblocks(struct dust_device *dd, char *result, unsigned int maxlen,
+				unsigned int *sz_ptr)
+{
+	unsigned long flags;
+	struct rb_root badblocklist;
+	struct rb_node *node;
+	struct badblock *bblk;
+	unsigned int sz = *sz_ptr;
+	unsigned long long num = 0;
+
+	spin_lock_irqsave(&dd->dust_lock, flags);
+	badblocklist = dd->badblocklist;
+	for (node = rb_first(&badblocklist); node; node = rb_next(node)) {
+		bblk = rb_entry(node, struct badblock, node);
+		DMEMIT("%llu\n", bblk->bb);
+		num++;
+	}
+
+	spin_unlock_irqrestore(&dd->dust_lock, flags);
+	if (!num)
+		DMEMIT("");
+
+	return 1;
+}
+
 /*
  * Target parameters:
  *
@@ -427,6 +452,8 @@ static int dust_message(struct dm_target *ti, unsigned int argc, char **argv,
 			else
 				dd->quiet_mode = false;
 			r = 0;
+		} else if (!strcasecmp(argv[0], "listbadblocks")) {
+			r = dust_list_badblocks(dd, result, maxlen, &sz);
 		} else {
 			invalid_msg = true;
 		}
-- 
2.25.4
