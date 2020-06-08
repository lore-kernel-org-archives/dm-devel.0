From: yangerkun <yangerkun@huawei.com>
Subject: [PATCH 1/2] dm dust: add interface to list all badblocks
Date: Mon, 8 Jun 2020 16:45:12 +0800
Message-ID: <20200608084513.115671-2-yangerkun@huawei.com>
References: <20200608084513.115671-1-yangerkun@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200608084513.115671-1-yangerkun@huawei.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: bgurney@redhat.com, agk@redhat.com, snitzer@redhat.com
Cc: dm-devel@redhat.com, yangerkun@huawei.com
List-Id: dm-devel.ids

This interface may help anyone want to know all badblocks without query
block one by one.

Signed-off-by: yangerkun <yangerkun@huawei.com>
Reviewed-by: Bryan Gurney <bgurney@redhat.com>
---
 drivers/md/dm-dust.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/drivers/md/dm-dust.c b/drivers/md/dm-dust.c
index ff03b90072c5..da5c10605c59 100644
--- a/drivers/md/dm-dust.c
+++ b/drivers/md/dm-dust.c
@@ -280,6 +280,24 @@ static int dust_clear_badblocks(struct dust_device *dd)
 	return 0;
 }
 
+static void dust_list_badblocks(struct dust_device *dd)
+{
+	unsigned long flags;
+	struct rb_root badblocklist;
+	struct rb_node *node;
+	struct badblock *bblk;
+
+	DMINFO("%s: badblocks list below:", __func__);
+	spin_lock_irqsave(&dd->dust_lock, flags);
+	badblocklist = dd->badblocklist;
+	for (node = rb_first(&badblocklist); node; node = rb_next(node)) {
+		bblk = rb_entry(node, struct badblock, node);
+		DMINFO("bad block: %llu", bblk->bb);
+	}
+	spin_unlock_irqrestore(&dd->dust_lock, flags);
+	DMINFO("%s: badblocks list end.", __func__);
+}
+
 /*
  * Target parameters:
  *
@@ -422,6 +440,9 @@ static int dust_message(struct dm_target *ti, unsigned int argc, char **argv,
 			else
 				dd->quiet_mode = false;
 			r = 0;
+		} else if (!strcasecmp(argv[0], "listbadblocks")) {
+			dust_list_badblocks(dd);
+			r = 0;
 		} else {
 			invalid_msg = true;
 		}
-- 
2.23.0.rc2.8.gff66981f45
