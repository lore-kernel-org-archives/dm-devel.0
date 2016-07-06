From: heinzm@redhat.com
Subject: [PATCH 02/26] dm raid: prohibit to pass in both sync and
	nosync ctr flags
Date: Wed,  6 Jul 2016 19:24:33 +0200
Message-ID: <1467825897-26058-3-git-send-email-heinzm@redhat.com>
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
 drivers/md/dm-raid.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 4bf7747..e8e9b6a 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -1297,6 +1297,12 @@ static int parse_raid_params(struct raid_set *rs, struct dm_arg_set *as,
 		}
 	}
 
+	if (test_bit(__CTR_FLAG_SYNC, &rs->ctr_flags) &&
+	    test_bit(__CTR_FLAG_NOSYNC, &rs->ctr_flags)) {
+		rs->ti->error = "sync and nosync are mutually exclusive";
+		return -EINVAL;
+	}
+
 	if (validate_region_size(rs, region_size))
 		return -EINVAL;
 
-- 
2.5.5
