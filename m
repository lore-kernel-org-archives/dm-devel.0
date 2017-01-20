From: Hou Tao <houtao1@huawei.com>
Subject: [PATCH RFC 1/4] dm thin: add a pool feature
	"keep_bio_blkcg"
Date: Fri, 20 Jan 2017 19:15:49 +0800
Message-ID: <1484910952-29820-2-git-send-email-houtao1@huawei.com>
References: <1484910952-29820-1-git-send-email-houtao1@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1484910952-29820-1-git-send-email-houtao1@huawei.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, linux-block@vger.kernel.org
Cc: ejt@redhat.com, snitzer@redhat.com, agk@redhat.com, vgoyal@redhat.com
List-Id: dm-devel.ids

"keep_bio_blkcg" is used to control whether or not
dm-thin needs to save the original blkcg of bio

Signed-off-by: Hou Tao <houtao1@huawei.com>
---
 drivers/md/dm-thin.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index d1c05c1..8178ee8 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -211,6 +211,7 @@ struct pool_features {
 	bool discard_enabled:1;
 	bool discard_passdown:1;
 	bool error_if_no_space:1;
+	bool keep_bio_blkcg:1;
 };
 
 struct thin_c;
@@ -277,6 +278,7 @@ struct pool {
 
 static enum pool_mode get_pool_mode(struct pool *pool);
 static void metadata_operation_failed(struct pool *pool, const char *op, int r);
+static bool keep_pool_bio_blkcg(struct pool *pool);
 
 /*
  * Target context for a pool.
@@ -2390,6 +2392,11 @@ static void noflush_work(struct thin_c *tc, void (*fn)(struct work_struct *))
 
 /*----------------------------------------------------------------*/
 
+static bool keep_pool_bio_blkcg(struct pool *pool)
+{
+	return pool->pf.keep_bio_blkcg;
+}
+
 static enum pool_mode get_pool_mode(struct pool *pool)
 {
 	return pool->pf.mode;
-- 
2.5.0
