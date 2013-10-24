From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 11/24] dm table: print error on preresume failure
Date: Thu, 24 Oct 2013 14:30:24 -0400
Message-ID: <1382639437-27007-12-git-send-email-snitzer@redhat.com>
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

If preresume fails it is worth logging an error given that a device is
left suspended due to the failure.

This change was motivated by local preresume error logging that was
added to the cache target.  Elevating this error logging to DM core
makes sense.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Joe Thornber <ejt@redhat.com>
---
 drivers/md/dm-table.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 8f87835..9bd75dc 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1548,8 +1548,11 @@ int dm_table_resume_targets(struct dm_table *t)
 			continue;
 
 		r = ti->type->preresume(ti);
-		if (r)
+		if (r) {
+			DMERR("%s: %s: preresume failed, error = %d",
+			      dm_device_name(t->md), ti->type->name, r);
 			return r;
+		}
 	}
 
 	for (i = 0; i < t->num_targets; i++) {
-- 
1.8.1.4
