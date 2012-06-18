From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH] dm thin: commit metadata before creating
	metadata snapshot
Date: Mon, 18 Jun 2012 14:51:48 -0400
Message-ID: <1340045508-685-1-git-send-email-snitzer@redhat.com>
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
To: agk@redhat.com
Cc: dm-devel@redhat.com, ejt@redhat.com
List-Id: dm-devel.ids

From: Joe Thornber <ejt@redhat.com>

If metadata is changing rapidly userland sometimes gets a corrupt
metadata block.

The checksums mean userland spots this corruption immediately so there's
no risk of acting on incorrect data.  No corruption exists from the
kernel's point of view, and thin_check passes after pool shutdown.

I believe this is to do with shared blocks at the first level of the
{device, mapping} btree.  Prior to the metadata-snap support no sharing
at this level was possible.  The problem goes away if we commit before
we take the metadata snapshot (which is a sensible thing to do anyway).

Signed-off-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-thin.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 54ae5c3..7dd25ff 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -2296,6 +2296,13 @@ static int process_reserve_metadata_snap_mesg(unsigned argc, char **argv, struct
 	if (r)
 		return r;
 
+	r = dm_pool_commit_metadata(pool->pmd);
+	if (r) {
+		DMERR("%s: dm_pool_commit_metadata() failed, error = %d",
+		      __func__, r);
+		return r;
+	}
+
 	r = dm_pool_reserve_metadata_snap(pool->pmd);
 	if (r)
 		DMWARN("reserve_metadata_snap message failed.");
-- 
1.7.4.4
