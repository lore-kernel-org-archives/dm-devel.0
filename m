From: Bryan Gurney <bgurney@redhat.com>
Subject: [PATCH] dm dust: add __func__ to queryblocks and
	clearbadblocks DMEMIT calls
Date: Fri, 19 Jun 2020 13:43:04 -0400
Message-ID: <1592588584-25942-1-git-send-email-bgurney@redhat.com>
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
Cc: Bryan Gurney <bgurney@redhat.com>
List-Id: dm-devel.ids

Signed-off-by: Bryan Gurney <bgurney@redhat.com>
---
 drivers/md/dm-dust.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-dust.c b/drivers/md/dm-dust.c
index 2ad8fc9293e0..e08f955dfe7b 100644
--- a/drivers/md/dm-dust.c
+++ b/drivers/md/dm-dust.c
@@ -148,9 +148,9 @@ static int dust_query_block(struct dust_device *dd, unsigned long long block, ch
 	spin_lock_irqsave(&dd->dust_lock, flags);
 	bblock = dust_rb_search(&dd->badblocklist, block);
 	if (bblock != NULL)
-		DMEMIT("block %llu found in badblocklist", block);
+		DMEMIT("%s: block %llu found in badblocklist", __func__, block);
 	else
-		DMEMIT("block %llu not found in badblocklist", block);
+		DMEMIT("%s: block %llu not found in badblocklist", __func__, block);
 	spin_unlock_irqrestore(&dd->dust_lock, flags);
 
 	return 1;
@@ -277,9 +277,9 @@ static int dust_clear_badblocks(struct dust_device *dd, char *result, unsigned i
 	spin_unlock_irqrestore(&dd->dust_lock, flags);
 
 	if (!__dust_clear_badblocks(&badblocklist, badblock_count))
-		DMEMIT("no badblocks found");
+		DMEMIT("%s: no badblocks found", __func__);
 	else
-		DMEMIT("badblocks cleared");
+		DMEMIT("%s: badblocks cleared", __func__);
 
 	return 1;
 }
-- 
2.25.4
