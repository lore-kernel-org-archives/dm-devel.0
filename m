From: Wenwen Wang <wenwen@cs.uga.edu>
Subject: [PATCH] dm raid: add cleanup in raid_ctr()
Date: Sun, 18 Aug 2019 19:18:34 -0500
Message-ID: <1566173915-5837-1-git-send-email-wenwen@cs.uga.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Wenwen Wang <wenwen@cs.uga.edu>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, "maintainer:DEVICE-MAPPER LVM" <dm-devel@redhat.com>, open list <linux-kernel@vger.kernel.org>
List-Id: dm-devel.ids

If rs_prepare_reshape() fails, no cleanup is executed, leading to
memory/resource leaks. To fix this issue, go to the label 'bad' if the
error occurs.

Signed-off-by: Wenwen Wang <wenwen@cs.uga.edu>
---
 drivers/md/dm-raid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 8a60a4a..1f933dd 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -3194,7 +3194,7 @@ static int raid_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 			  */
 			r = rs_prepare_reshape(rs);
 			if (r)
-				return r;
+				goto bad;
 
 			/* Reshaping ain't recovery, so disable recovery */
 			rs_setup_recovery(rs, MaxSector);
-- 
2.7.4
