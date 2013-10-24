From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 17/24] dm cache: use a boolean when setting
	cache->quiescing
Date: Thu, 24 Oct 2013 14:30:30 -0400
Message-ID: <1382639437-27007-18-git-send-email-snitzer@redhat.com>
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

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-cache-target.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
index afeda1b..f999ddd 100644
--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -1448,7 +1448,7 @@ static void start_quiescing(struct cache *cache)
 	unsigned long flags;
 
 	spin_lock_irqsave(&cache->lock, flags);
-	cache->quiescing = 1;
+	cache->quiescing = true;
 	spin_unlock_irqrestore(&cache->lock, flags);
 }
 
@@ -1457,7 +1457,7 @@ static void stop_quiescing(struct cache *cache)
 	unsigned long flags;
 
 	spin_lock_irqsave(&cache->lock, flags);
-	cache->quiescing = 0;
+	cache->quiescing = false;
 	spin_unlock_irqrestore(&cache->lock, flags);
 }
 
-- 
1.8.1.4
