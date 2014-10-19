From: Mike Snitzer <snitzer@redhat.com>
Subject: [for-3.19 PATCH v2 fix 18/17] dm thin: fix
	process_shared_bio (fixes SnapshotTests)
Date: Sun, 19 Oct 2014 19:02:34 -0400
Message-ID: <1413759757-7935-1-git-send-email-snitzer@redhat.com>
References: <20141017183119.GA31854@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20141017183119.GA31854@redhat.com>
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
Cc: ejt@redhat.com
List-Id: dm-devel.ids

Fold into "dm thin: direct dispatch when breaking sharing"

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-thin.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index cd63180..f5c59cf 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -1435,7 +1435,7 @@ static void process_shared_bio(struct thin_c *tc, struct bio *bio,
 
 		h->shared_read_entry = dm_deferred_entry_inc(pool->shared_read_ds);
 		inc_all_io_entry(pool, bio);
-		remap_and_issue(tc, bio, block);
+		remap_and_issue(tc, bio, lookup_result->block);
 
 		remap_and_issue_shared_cell(tc, data_cell, lookup_result->block);
 		remap_and_issue_shared_cell(tc, virt_cell, lookup_result->block);
-- 
1.8.3.1
