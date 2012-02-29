From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 13/13] dm thin: pre-commit in pool_status so it
	provides accurate free block counts
Date: Wed, 29 Feb 2012 09:50:17 -0500
Message-ID: <1330527017-28618-14-git-send-email-snitzer@redhat.com>
References: <1330527017-28618-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1330527017-28618-1-git-send-email-snitzer@redhat.com>
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
Cc: Heinz Mauelshagen <heinzm@redhat.com>, Joe Thornber <thornber@redhat.com>, snitzer@redhat.com
List-Id: dm-devel.ids

From: Heinz Mauelshagen <heinzm@redhat.com>

If we're in the middle of a transaction the free block counts can be
quite out of date, so do a quick commit to update them.

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
Signed-off-by: Joe Thornber <thornber@redhat.com>
Acked-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-thin.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 2e16b3a..2b1d5bd 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -2343,6 +2343,15 @@ static int pool_status(struct dm_target *ti, status_type_t type,
 		if (r)
 			return r;
 
+		/*
+		 * If we're in the middle of a transaction the free block
+		 * counts can be quite out of date, so we do a quick
+		 * commit.
+		 */
+		r = dm_pool_commit_metadata(pool->pmd);
+		if (r)
+			return r;
+
 		r = dm_pool_get_free_metadata_block_count(pool->pmd,
 							  &nr_free_blocks_metadata);
 		if (r)
-- 
1.7.1
