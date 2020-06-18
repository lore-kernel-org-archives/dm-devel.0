From: yangerkun <yangerkun@huawei.com>
Subject: [PATCH v2 1/2] dm dust: list badblock in dust_status
Date: Thu, 18 Jun 2020 17:06:19 +0800
Message-ID: <20200618090620.3517530-2-yangerkun@huawei.com>
References: <20200618090620.3517530-1-yangerkun@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200618090620.3517530-1-yangerkun@huawei.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: snitzer@redhat.com, bgurney@redhat.com, agk@redhat.com, bmr@redhat.com
Cc: dm-devel@redhat.com, yangerkun@huawei.com
List-Id: dm-devel.ids

List all bad blocks may help user check the status of dust. We add this
logical in dust_status, which will return result to user directly.

Signed-off-by: yangerkun <yangerkun@huawei.com>
---
 drivers/md/dm-dust.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/drivers/md/dm-dust.c b/drivers/md/dm-dust.c
index ff03b90072c5..f96adb240adc 100644
--- a/drivers/md/dm-dust.c
+++ b/drivers/md/dm-dust.c
@@ -478,6 +478,30 @@ static int dust_message(struct dm_target *ti, unsigned int argc, char **argv,
 	return r;
 }
 
+static void dust_list_badblocks(struct dust_device *dd, char *result, unsigned int maxlen,
+				unsigned int *sz_ptr)
+{
+	unsigned long flags;
+	struct rb_root badblocklist;
+	struct rb_node *node;
+	struct badblock *bblk;
+	unsigned int sz = *sz_ptr;
+	int num = 0;
+
+	DMEMIT(" badblocks list:");
+	spin_lock_irqsave(&dd->dust_lock, flags);
+	badblocklist = dd->badblocklist;
+	for (node = rb_first(&badblocklist); node; node = rb_next(node)) {
+		bblk = rb_entry(node, struct badblock, node);
+		DMEMIT(" %llu", bblk->bb);
+		num++;
+	}
+
+	spin_unlock_irqrestore(&dd->dust_lock, flags);
+	if (!num)
+		DMEMIT(" null");
+}
+
 static void dust_status(struct dm_target *ti, status_type_t type,
 			unsigned int status_flags, char *result, unsigned int maxlen)
 {
@@ -489,6 +513,7 @@ static void dust_status(struct dm_target *ti, status_type_t type,
 		DMEMIT("%s %s %s", dd->dev->name,
 		       dd->fail_read_on_bb ? "fail_read_on_bad_block" : "bypass",
 		       dd->quiet_mode ? "quiet" : "verbose");
+		dust_list_badblocks(dd, result, maxlen, &sz);
 		break;
 
 	case STATUSTYPE_TABLE:
-- 
2.25.4
