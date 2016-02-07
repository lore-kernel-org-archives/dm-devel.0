From: Mike Snitzer <snitzer@redhat.com>
Subject: [dm-4.6 PATCH v2 14/15] dm mpath: reduce granularity of
	locking in __multipath_map
Date: Sun,  7 Feb 2016 10:53:36 -0500
Message-ID: <1454860417-3203-15-git-send-email-snitzer@redhat.com>
References: <1454860417-3203-1-git-send-email-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1454860417-3203-1-git-send-email-snitzer@redhat.com>
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
Cc: Mike Snitzer <snitzer@redhat.com>, Sagi Grimberg <sagig@dev.mellanox.co.il>
List-Id: dm-devel.ids

No need to hold m->lock after path has been selected (and 'struct
multipath' state updated).

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-mpath.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 7986446..199d3d3 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -427,18 +427,18 @@ static int __multipath_map(struct dm_target *ti, struct request *clone,
 		goto out_unlock;
 	}
 
+	spin_unlock_irq(&m->lock);
+
 	mpio = set_mpio(m, map_context);
 	if (!mpio)
 		/* ENOMEM, requeue */
-		goto out_unlock;
+		return r;
 
 	mpio->pgpath = pgpath;
 	mpio->nr_bytes = nr_bytes;
 
 	bdev = pgpath->path.dev->bdev;
 
-	spin_unlock_irq(&m->lock);
-
 	if (clone) {
 		/*
 		 * Old request-based interface: allocated clone is passed in.
-- 
2.5.4 (Apple Git-61)
