From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH] dm thin: emit "ignore_discard" in status if
	discards are disabled
Date: Mon, 10 Dec 2012 12:04:35 -0500
Message-ID: <1355159075-10517-1-git-send-email-snitzer@redhat.com>
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

If "ignore_discard" is specified when creating the thin pool device then
discard support is disabled for that device.  The pool device's status
should reflect this fact rather than stating "no_discard_passdown"
(which implies discards are enabled but passdown is disabled).

Reported-by: Zdenek Kabelac <zkabelac@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-thin.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 4644f5e..f1d2f5e 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -2370,7 +2370,9 @@ static int pool_status(struct dm_target *ti, status_type_t type,
 		else
 			DMEMIT("rw ");
 
-		if (pool->pf.discard_enabled && pool->pf.discard_passdown)
+		if (!pool->pf.discard_enabled)
+			DMEMIT("ignore_discard");
+		else if (pool->pf.discard_passdown)
 			DMEMIT("discard_passdown");
 		else
 			DMEMIT("no_discard_passdown");
-- 
1.7.1
