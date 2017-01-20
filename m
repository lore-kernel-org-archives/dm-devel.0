From: Hou Tao <houtao1@huawei.com>
Subject: [PATCH RFC 2/4] dm thin: parse "keep_bio_blkcg" from
	userspace tools
Date: Fri, 20 Jan 2017 19:15:50 +0800
Message-ID: <1484910952-29820-3-git-send-email-houtao1@huawei.com>
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

keep_bio_blkcg feature is off by default, and it can
be turned on by using "keep_bio_blkcg" argument.

Signed-off-by: Hou Tao <houtao1@huawei.com>
---
 drivers/md/dm-thin.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 8178ee8..57d6202 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -2824,6 +2824,7 @@ static void pool_features_init(struct pool_features *pf)
 	pf->discard_enabled = true;
 	pf->discard_passdown = true;
 	pf->error_if_no_space = false;
+	pf->keep_bio_blkcg = false;
 }
 
 static void __pool_destroy(struct pool *pool)
@@ -3053,7 +3054,7 @@ static int parse_pool_features(struct dm_arg_set *as, struct pool_features *pf,
 	const char *arg_name;
 
 	static struct dm_arg _args[] = {
-		{0, 4, "Invalid number of pool feature arguments"},
+		{0, 5, "Invalid number of pool feature arguments"},
 	};
 
 	/*
@@ -3085,6 +3086,9 @@ static int parse_pool_features(struct dm_arg_set *as, struct pool_features *pf,
 		else if (!strcasecmp(arg_name, "error_if_no_space"))
 			pf->error_if_no_space = true;
 
+		else if (!strcasecmp(arg_name, "keep_bio_blkcg"))
+			pf->keep_bio_blkcg = true;
+
 		else {
 			ti->error = "Unrecognised pool feature requested";
 			r = -EINVAL;
-- 
2.5.0
