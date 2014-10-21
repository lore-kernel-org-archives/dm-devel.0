From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] dm raid: pointer math issue in super_sync()
Date: Tue, 21 Oct 2014 15:43:36 +0300
Message-ID: <20141021124336.GA20791@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
Sender: kernel-janitors-owner@vger.kernel.org
To: Alasdair Kergon <agk@redhat.com>
Cc: Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: dm-devel.ids

"sb" is a dm_raid_superblock struct pointer so the pointer math doesn't
work and we will end up corrupting memory.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index b802644..a7cb9dd 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -826,7 +826,7 @@ static void super_sync(struct mddev *mddev, struct md_rdev *rdev)
 		    test_bit(Faulty, &(rs->dev[i].rdev.flags)))
 			failed_devices |= (1ULL << i);
 
-	memset(sb + sizeof(*sb), 0, rdev->sb_size - sizeof(*sb));
+	memset(sb + 1, 0, rdev->sb_size - sizeof(*sb));
 
 	sb->magic = cpu_to_le32(DM_RAID_MAGIC);
 	sb->features = cpu_to_le32(0);	/* No features yet */
