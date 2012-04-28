From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 1/2] dm: update max_io_len to support a split_io
	that is not a power of 2
Date: Sat, 28 Apr 2012 00:44:28 -0400
Message-ID: <1335588269-807-1-git-send-email-snitzer@redhat.com>
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
Cc: ejt@redhat.com, agk@redhat.com
List-Id: dm-devel.ids

Required to support a target's use of a non power of 2 blocksize.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index e24143c..fe57285 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -973,10 +973,10 @@ static sector_t max_io_len(sector_t sector, struct dm_target *ti)
 	 * Does the target need to split even further ?
 	 */
 	if (ti->split_io) {
-		sector_t boundary;
 		sector_t offset = dm_target_offset(ti, sector);
-		boundary = ((offset + ti->split_io) & ~(ti->split_io - 1))
-			   - offset;
+		sector_t boundary, tmp = offset + ti->split_io;
+
+		boundary = ti->split_io - do_div(tmp, ti->split_io);
 		if (len > boundary)
 			len = boundary;
 	}
-- 
1.7.1
