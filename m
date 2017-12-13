From: Heinz Mauelshagen <heinzm@redhat.com>
Subject: [PATCH 3/5] dm raid: ensure 'a' chars during reshape
Date: Wed, 13 Dec 2017 03:02:36 +0100
Message-ID: <9aa9139fe73e9fe87ca452b4fb33f00093b98ef9.1513125666.git.heinzm@redhat.com>
References: <cover.1513125666.git.heinzm@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <cover.1513125666.git.heinzm@redhat.com>
In-Reply-To: <cover.1513125666.git.heinzm@redhat.com>
References: <cover.1513125666.git.heinzm@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: heinzm@redhat.com, dm-devel@redhat.com
Cc: snitzer@redhat.com
List-Id: dm-devel.ids

During reshape, 'A' chars were reported in status rather than 'a'.

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
---
 drivers/md/dm-raid.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 0e1a296cd08d..f5db4ce69d6b 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -3451,6 +3451,15 @@ static sector_t rs_get_progress(struct raid_set *rs, unsigned long recovery,
 			 */
 			set_bit(RT_FLAG_RS_RESYNCING, &rs->runtime_flags);
 
+		} else if (test_bit(MD_RECOVERY_RESHAPE, &recovery) &&
+			   !test_bit(MD_RECOVERY_REQUESTED, &recovery)) {
+			/*
+			 * If "reshape" is occurring, the raid set
+			 * is or may be out of sync hence the health
+			 * characters shall be 'a'.
+			 */
+			set_bit(RT_FLAG_RS_RESYNCING, &rs->runtime_flags);
+
 		} else if (test_bit(MD_RECOVERY_REQUESTED, &recovery)) {
 			/*
 			 * If "check" or "repair" is occurring, the raid set has
-- 
2.13.6
