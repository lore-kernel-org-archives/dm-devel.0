From: Heinz Mauelshagen <heinzm@redhat.com>
Subject: [PATCH] dm raid: fix parse_raid_params() variable range
	issue
Date: Mon, 19 Mar 2018 15:39:30 +0100
Message-ID: <0ac594ac72b9ddf16c50da4e97361a4471f6651c.1521470284.git.heinzm@redhat.com>
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
To: heinzm@redhat.com, dm-devel@redhat.com, snitzer@redhat.com
List-Id: dm-devel.ids

parse_raid_parames() compared variable "int value" with INT_MAX to
prevent overflow of mddev variables set.

Change type to "long value".

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
---
 drivers/md/dm-raid.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 335ebd46a986..7ffa1839b206 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -1141,7 +1141,7 @@ static int validate_raid_redundancy(struct raid_set *rs)
 static int parse_raid_params(struct raid_set *rs, struct dm_arg_set *as,
 			     unsigned int num_raid_params)
 {
-	int value, raid10_format = ALGORITHM_RAID10_DEFAULT;
+	long value, raid10_format = ALGORITHM_RAID10_DEFAULT;
 	unsigned int raid10_copies = 2;
 	unsigned int i, write_mostly = 0;
 	unsigned int region_size = 0;
@@ -1153,7 +1153,7 @@ static int parse_raid_params(struct raid_set *rs, struct dm_arg_set *as,
 	arg = dm_shift_arg(as);
 	num_raid_params--; /* Account for chunk_size argument */
 
-	if (kstrtoint(arg, 10, &value) < 0) {
+	if (kstrtol(arg, 10, &value) < 0) {
 		rs->ti->error = "Bad numerical argument given for chunk_size";
 		return -EINVAL;
 	}
@@ -1315,7 +1315,7 @@ static int parse_raid_params(struct raid_set *rs, struct dm_arg_set *as,
 		/*
 		 * Parameters with number values from here on.
 		 */
-		if (kstrtoint(arg, 10, &value) < 0) {
+		if (kstrtol(arg, 10, &value) < 0) {
 			rs->ti->error = "Bad numerical argument given in raid params";
 			return -EINVAL;
 		}
-- 
2.14.3
