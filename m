From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 15/24] dm cache: use cell_defer() boolean
	argument consistently
Date: Thu, 24 Oct 2013 14:30:28 -0400
Message-ID: <1382639437-27007-16-git-send-email-snitzer@redhat.com>
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

Fix a few cell_defer() calls that weren't passing a bool.

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-cache-target.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
index 5fb4d64..db27dfa 100644
--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -808,13 +808,13 @@ static void migration_failure(struct dm_cache_migration *mg)
 		DMWARN_LIMIT("demotion failed; couldn't copy block");
 		policy_force_mapping(cache->policy, mg->new_oblock, mg->old_oblock);
 
-		cell_defer(cache, mg->old_ocell, mg->promote ? 0 : 1);
+		cell_defer(cache, mg->old_ocell, mg->promote ? false : true);
 		if (mg->promote)
-			cell_defer(cache, mg->new_ocell, 1);
+			cell_defer(cache, mg->new_ocell, true);
 	} else {
 		DMWARN_LIMIT("promotion failed; couldn't copy block");
 		policy_remove_mapping(cache->policy, mg->new_oblock);
-		cell_defer(cache, mg->new_ocell, 1);
+		cell_defer(cache, mg->new_ocell, true);
 	}
 
 	cleanup_migration(mg);
@@ -866,7 +866,7 @@ static void migration_success_post_commit(struct dm_cache_migration *mg)
 		return;
 
 	} else if (mg->demote) {
-		cell_defer(cache, mg->old_ocell, mg->promote ? 0 : 1);
+		cell_defer(cache, mg->old_ocell, mg->promote ? false : true);
 
 		if (mg->promote) {
 			mg->demote = false;
-- 
1.8.1.4
