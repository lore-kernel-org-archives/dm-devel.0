From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 13/24] dm cache policy: have
	policy_writeback_work return -ENODATA by default
Date: Thu, 24 Oct 2013 14:30:26 -0400
Message-ID: <1382639437-27007-14-git-send-email-snitzer@redhat.com>
References: <1382639437-27007-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1382639437-27007-1-git-send-email-snitzer@redhat.com>
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
Cc: Morgan Mears <morgan.mears@netapp.com>, Heinz Mauelshagen <heinzm@redhat.com>, Joe Thornber <ejt@redhat.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

From: Heinz Mauelshagen <heinzm@redhat.com>

Caller of policy_writeback_work doesn't care, so doesn't actually fix
anything but increases consistency of returns used (which helps
debugging).

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-cache-policy-internal.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-cache-policy-internal.h b/drivers/md/dm-cache-policy-internal.h
index 0f749e8..9b1473b 100644
--- a/drivers/md/dm-cache-policy-internal.h
+++ b/drivers/md/dm-cache-policy-internal.h
@@ -56,7 +56,7 @@ static inline int policy_writeback_work(struct dm_cache_policy *p,
 					dm_oblock_t *oblock,
 					dm_cblock_t *cblock)
 {
-	return p->writeback_work ? p->writeback_work(p, oblock, cblock) : -ENOENT;
+	return p->writeback_work ? p->writeback_work(p, oblock, cblock) : -ENODATA;
 }
 
 static inline void policy_remove_mapping(struct dm_cache_policy *p, dm_oblock_t oblock)
-- 
1.8.1.4
