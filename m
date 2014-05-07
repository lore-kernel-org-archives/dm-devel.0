From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH] dm thin: allow metadata commit if pool is in
	PM_OUT_OF_DATA_SPACE mode
Date: Wed,  7 May 2014 15:59:57 -0400
Message-ID: <1399492797-1801-1-git-send-email-snitzer@redhat.com>
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
List-Id: dm-devel.ids

From: Joe Thornber <ejt@redhat.com>

Commit 3e1a0699 ("dm thin: fix out of data space handling") introduced
a regression in the metadata commit() method by returning an error if
the pool is in PM_OUT_OF_DATA_SPACE mode.  This oversight caused a thin
device to return errors even if the default queue_if_no_space ENOSPC
handling mode is used.

Fix commit() to only fail if pool is in PM_READ_ONLY or PM_FAIL mode.

Reported-by: qindehua@163.com
Signed-off-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Cc: stable@vger.kernel.org # 3.14+
---
 drivers/md/dm-thin.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 13abade..15f748b 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -935,7 +935,7 @@ static int commit(struct pool *pool)
 {
 	int r;
 
-	if (get_pool_mode(pool) != PM_WRITE)
+	if (get_pool_mode(pool) >= PM_READ_ONLY)
 		return -EINVAL;
 
 	r = dm_pool_commit_metadata(pool->pmd);
-- 
1.7.1
