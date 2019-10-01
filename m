From: Heinz Mauelshagen <heinzm@redhat.com>
Subject: [PATCH 5/4] dm raid: revert recovery offset definition
Date: Tue,  1 Oct 2019 22:37:47 +0200
Message-ID: <53c8e7d1576cb4471cb399a3630d021087a150f3.1569962154.git.heinzm@redhat.com>
References: <c38233bcdbd0d33e1bcf71bf0ad01335e79c845e.1569962154.git.heinzm@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <c38233bcdbd0d33e1bcf71bf0ad01335e79c845e.1569962154.git.heinzm@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, snitzer@redhat.com
Cc: heinzm@redhat.com
List-Id: dm-devel.ids

Previous patch "dm raid: streamline rs_get_progress() and its
raid_status() caller side" mistakenly simplified the definition
of the recovery offset.  This caused the offset to immediately be
resync maximum when checks or repairs are requested.

Revert to the old definition.

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
---
 drivers/md/dm-raid.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 63a4a26fae3e..13fa90546a0f 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -3426,7 +3426,10 @@ static sector_t rs_get_progress(struct raid_set *rs, unsigned long recovery,
 		set_bit(RT_FLAG_RS_IN_SYNC, &rs->runtime_flags);
 
 	} else {
-		r = max(mddev->recovery_cp, mddev->curr_resync_completed);
+		if (state == st_idle && !test_bit(MD_RECOVERY_INTR, &recovery))
+			r = mddev->recovery_cp;
+		else
+			r = mddev->curr_resync_completed;
 
 		if (state == st_idle && r >= resync_max_sectors) {
 			/*
-- 
2.21.0
