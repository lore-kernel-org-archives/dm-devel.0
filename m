From: heinzm@redhat.com
Subject: [PATCH v2] dm raid: ensure metadata IO matches device
	block size
Date: Fri, 17 Oct 2014 13:38:50 +0200
Message-ID: <1413545930-24488-1-git-send-email-heinzm@redhat.com>
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
Cc: Heinz Mauelshagen <heinzm@redhat.com>
List-Id: dm-devel.ids

From: Heinz Mauelshagen <heinzm@redhat.com>

This is v2 of a patch submitted by Neil Brown on 10/15/2014.


The dm-raid superblock (struct dm_raid_superblock) is hard padded to
be 512 bytes in size and that size is being used to read it in from
the metadata device into one preallocated page.

Reading or writing this on a 512-byte sector drive works fine but
on a 4096-byte sector device this fails.

The patch sets the superblock size to the logical block size of the
metadata device, because IO at that size is guaranteed too work.
It adds a size check to avoid silent partial metadata loss in case
the superblock should ever grow past the logical block size
or the latter past PAGE_SIZE.


Reported-by: "Liuhua Wang" <lwang@suse.com>
Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>


---
 drivers/md/dm-raid.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 4880b69..aa25112 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -785,8 +785,7 @@ struct dm_raid_superblock {
 	__le32 layout;
 	__le32 stripe_sectors;
 
-	__u8 pad[452];		/* Round struct to 512 bytes. */
-				/* Always set to 0 when writing. */
+	/* Always set rest up to logical block size to 0 when writing (see super_sync()). */
 } __packed;
 
 static int read_disk_sb(struct md_rdev *rdev, int size)
@@ -823,7 +822,7 @@ static void super_sync(struct mddev *mddev, struct md_rdev *rdev)
 		    test_bit(Faulty, &(rs->dev[i].rdev.flags)))
 			failed_devices |= (1ULL << i);
 
-	memset(sb, 0, sizeof(*sb));
+	memset(sb + sizeof(*sb), 0, rdev->sb_size - sizeof(*sb));
 
 	sb->magic = cpu_to_le32(DM_RAID_MAGIC);
 	sb->features = cpu_to_le32(0);	/* No features yet */
@@ -858,7 +857,11 @@ static int super_load(struct md_rdev *rdev, struct md_rdev *refdev)
 	uint64_t events_sb, events_refsb;
 
 	rdev->sb_start = 0;
-	rdev->sb_size = sizeof(*sb);
+	rdev->sb_size = bdev_logical_block_size(rdev->meta_bdev);
+	if (rdev->sb_size < sizeof(*sb) || rdev->sb_size > PAGE_SIZE) {
+		DMERR("superblock size missmatch");
+		return -EINVAL;
+	}
 
 	ret = read_disk_sb(rdev, rdev->sb_size);
 	if (ret)
-- 
1.9.3
