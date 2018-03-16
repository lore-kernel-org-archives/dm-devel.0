From: Heinz Mauelshagen <heinzm@redhat.com>
Subject: [PATCH] dm raid: fix nosync status
Date: Fri, 16 Mar 2018 23:01:59 +0100
Message-ID: <f3f546c41f270705302b68abcb9d3aaec5c2b1fe.1521237663.git.heinzm@redhat.com>
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
To: heinzm@redhat.com, dm-devel@redhat.com
Cc: snitzer@redhat.com
List-Id: dm-devel.ids

Fix a race for "nosync" activations providing "aa.." device
health characters and "0/N" sync ratio rather than "AA..."
and "N/N".  Occurs when status for the raid set is retrieved
during resume before the MD sync thread starts and clears
the MD_RECOVERY_NEEDED flag.

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
---
 drivers/md/dm-raid.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index c1d1034ff7b7..335ebd46a986 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -3408,7 +3408,8 @@ static sector_t rs_get_progress(struct raid_set *rs, unsigned long recovery,
 		set_bit(RT_FLAG_RS_IN_SYNC, &rs->runtime_flags);
 
 	} else {
-		if (!test_bit(MD_RECOVERY_INTR, &recovery) &&
+		if (!test_bit(__CTR_FLAG_NOSYNC, &rs->ctr_flags) &&
+		    !test_bit(MD_RECOVERY_INTR, &recovery) &&
 		    (test_bit(MD_RECOVERY_NEEDED, &recovery) ||
 		     test_bit(MD_RECOVERY_RESHAPE, &recovery) ||
 		     test_bit(MD_RECOVERY_RUNNING, &recovery)))
-- 
2.14.3
