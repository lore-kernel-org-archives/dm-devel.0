From: Joe Thornber <ejt@redhat.com>
Subject: [PATCH 13/14] dm_thin: commit just before processing a
	pool target info request
Date: Fri, 16 Mar 2012 15:22:36 +0000
Message-ID: <1331911358-8848-13-git-send-email-ejt@redhat.com>
References: <20120316152156.GA8836@ubuntu>
	<1331911358-8848-1-git-send-email-ejt@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1331911358-8848-1-git-send-email-ejt@redhat.com>
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
Cc: Joe Thornber <ejt@redhat.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

Enhancement.

This makes the free block counts more accurate.

Signed-off-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-thin.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index a3a66af..63f8adf 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -2305,6 +2305,15 @@ static int pool_status(struct dm_target *ti, status_type_t type,
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
1.7.9.1
