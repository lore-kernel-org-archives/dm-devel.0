From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 18/24] dm cache: optimize commit_if_needed
Date: Thu, 24 Oct 2013 14:30:31 -0400
Message-ID: <1382639437-27007-19-git-send-email-snitzer@redhat.com>
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

Check commit_requested flag _before_ calling
dm_cache_changed_this_transaction() superfluously.

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-cache-target.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
index f999ddd..502ae64 100644
--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -1324,8 +1324,8 @@ static int need_commit_due_to_time(struct cache *cache)
 
 static int commit_if_needed(struct cache *cache)
 {
-	if (dm_cache_changed_this_transaction(cache->cmd) &&
-	    (cache->commit_requested || need_commit_due_to_time(cache))) {
+	if ((cache->commit_requested || need_commit_due_to_time(cache)) &&
+	    dm_cache_changed_this_transaction(cache->cmd)) {
 		atomic_inc(&cache->stats.commit_count);
 		cache->last_commit_jiffies = jiffies;
 		cache->commit_requested = false;
-- 
1.8.1.4
