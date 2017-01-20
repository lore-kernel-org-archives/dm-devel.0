From: Hou Tao <houtao1@huawei.com>
Subject: [PATCH RFC 3/4] dm thin: show the enabled status of
	keep_bio_blkcg feature
Date: Fri, 20 Jan 2017 19:15:51 +0800
Message-ID: <1484910952-29820-4-git-send-email-houtao1@huawei.com>
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

If keep_bio_blkcg feature is enabled, we can ensure that
by STATUSTYPE_TABLE or STATUSTYPE_INFO command.

Signed-off-by: Hou Tao <houtao1@huawei.com>
---
 drivers/md/dm-thin.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 57d6202..140cdae 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -3760,7 +3760,7 @@ static void emit_flags(struct pool_features *pf, char *result,
 {
 	unsigned count = !pf->zero_new_blocks + !pf->discard_enabled +
 		!pf->discard_passdown + (pf->mode == PM_READ_ONLY) +
-		pf->error_if_no_space;
+		pf->error_if_no_space + pf->keep_bio_blkcg;
 	DMEMIT("%u ", count);
 
 	if (!pf->zero_new_blocks)
@@ -3777,6 +3777,9 @@ static void emit_flags(struct pool_features *pf, char *result,
 
 	if (pf->error_if_no_space)
 		DMEMIT("error_if_no_space ");
+
+	if (pf->keep_bio_blkcg)
+		DMEMIT("keep_bio_blkcg ");
 }
 
 /*
@@ -3885,6 +3888,9 @@ static void pool_status(struct dm_target *ti, status_type_t type,
 		else
 			DMEMIT("queue_if_no_space ");
 
+		if (pool->pf.keep_bio_blkcg)
+			DMEMIT("keep_bio_blkcg ");
+
 		if (dm_pool_metadata_needs_check(pool->pmd))
 			DMEMIT("needs_check ");
 		else
-- 
2.5.0
