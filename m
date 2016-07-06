From: heinzm@redhat.com
Subject: [PATCH 04/26] dm raid: reject too many write_mostly
	devices
Date: Wed,  6 Jul 2016 19:24:35 +0200
Message-ID: <1467825897-26058-5-git-send-email-heinzm@redhat.com>
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
Cc: Heinz Mauelshagen <heinzm@redhat.com>
List-Id: dm-devel.ids

From: Heinz Mauelshagen <heinzm@redhat.com>

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
---
 drivers/md/dm-raid.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 0eceee8..a382985 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -1025,7 +1025,7 @@ static int parse_raid_params(struct raid_set *rs, struct dm_arg_set *as,
 {
 	int value, raid10_format = ALGORITHM_RAID10_DEFAULT;
 	unsigned raid10_copies = 2;
-	unsigned i;
+	unsigned i, write_mostly = 0;
 	unsigned region_size = 0;
 	sector_t max_io_len;
 	const char *arg, *key;
@@ -1179,6 +1179,7 @@ static int parse_raid_params(struct raid_set *rs, struct dm_arg_set *as,
 				return -EINVAL;
 			}
 
+			write_mostly++;
 			set_bit(WriteMostly, &rs->dev[value].rdev.flags);
 			set_bit(__CTR_FLAG_WRITE_MOSTLY, &rs->ctr_flags);
 		} else if (!strcasecmp(key, dm_raid_arg_name_by_flag(CTR_FLAG_MAX_WRITE_BEHIND))) {
@@ -1303,6 +1304,11 @@ static int parse_raid_params(struct raid_set *rs, struct dm_arg_set *as,
 		return -EINVAL;
 	}
 
+	if (write_mostly >= rs->md.raid_disks) {
+		rs->ti->error = "Can't set all raid1 devices to write_mostly";
+		return -EINVAL;
+	}
+
 	if (validate_region_size(rs, region_size))
 		return -EINVAL;
 
-- 
2.5.5
