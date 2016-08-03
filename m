From: heinzm@redhat.com
Subject: [PATCH] dm raid: constructor fails on non-zero
	incompat_features
Date: Wed,  3 Aug 2016 17:47:04 +0200
Message-ID: <1470239224-5884-1-git-send-email-heinzm@redhat.com>
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

When lvm2 userspace requests a RaidLV repair, it sets
the rebuild constructor flag on the new, replaced DataLVs
but does not clear the respective MetaLVs. Hence the
superblock loaded from such new MetaLVs may have a non-zero
incompat_features member and the constructor will fail on
checking it to be zero.

Solve by initializing the incompat_features member properly.

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
---
 drivers/md/dm-raid.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 8498354..2b1279c 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -1960,6 +1960,7 @@ static void super_sync(struct mddev *mddev, struct md_rdev *rdev)
 	sb->data_offset = cpu_to_le64(rdev->data_offset);
 	sb->new_data_offset = cpu_to_le64(rdev->new_data_offset);
 	sb->sectors = cpu_to_le64(rdev->sectors);
+	sb->incompat_features = cpu_to_le32(0);
 
 	/* Zero out the rest of the payload after the size of the superblock */
 	memset(sb + 1, 0, rdev->sb_size - sizeof(*sb));
-- 
2.5.5
