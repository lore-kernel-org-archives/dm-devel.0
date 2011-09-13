From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH] dm mpath: never re-queue request if I_T_L nexus
	failure and no paths
Date: Tue, 13 Sep 2011 10:22:34 -0400
Message-ID: <1315923754-12107-1-git-send-email-snitzer@redhat.com>
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
To: Hannes Reinecke <hare@suse.de>
Cc: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

Commit 751b2a7d (dm mpath: propagate target errors immediately) intended
to prevent request re-queue if I_T_L nexus failure and no paths are
available.

However, !m->queue_if_no_path does not imply !__must_push_back(m) so it
is possible that an -EBADE failure will result in requeue if
queue_if_no_path was previously enabled (but currently
!m->queue_if_no_path) and __must_push_back(m).

Fix this so requests that fail with -EBADE will never be re-queued.
Return -EIO if queue_if_no_path was really not enabled, otherwise if
queueing is enabled return -EBADE.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-mpath.c |   11 ++++-------
 1 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 5e0090e..d0297c2 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -1239,13 +1239,10 @@ static int do_end_io(struct multipath *m, struct request *clone,
 
 	spin_lock_irqsave(&m->lock, flags);
 	if (!m->nr_valid_paths) {
-		if (!m->queue_if_no_path) {
-			if (!__must_push_back(m))
-				r = -EIO;
-		} else {
-			if (error == -EBADE)
-				r = error;
-		}
+		if (!m->queue_if_no_path && !__must_push_back(m))
+			r = -EIO;
+		else if (error == -EBADE)
+			r = error;
 	}
 	spin_unlock_irqrestore(&m->lock, flags);
 
-- 
1.7.4.4
