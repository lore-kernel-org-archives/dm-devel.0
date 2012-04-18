From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 4 of 5] DM RAID: Use md_error() in place of simply setting
 Faulty bit
Date: Tue, 17 Apr 2012 21:41:09 -0500
Message-ID: <1334716869.23908.25.camel@f14.redhat.com>
References: <1334716219.23908.14.camel@f14.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1334716219.23908.14.camel@f14.redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: dm-devel@redhat.com, linux-raid@vger.kernel.org
Cc: neilb@suse.de, agk@redhat.com
List-Id: dm-devel.ids

When encountering an error while reading the superblock, call md_error.

We are currently setting the 'Faulty' bit on one of the array devices when an
error is encountered while reading the superblock of a dm-raid array.  We should
be calling md_error(), as it handles the error more completely.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>
Index: linux-upstream/drivers/md/dm-raid.c
===================================================================
--- linux-upstream.orig/drivers/md/dm-raid.c
+++ linux-upstream/drivers/md/dm-raid.c
@@ -606,7 +606,7 @@ static int read_disk_sb(struct md_rdev *
 	if (!sync_page_io(rdev, 0, size, rdev->sb_page, READ, 1)) {
 		DMERR("Failed to read superblock of device at position %d",
 		      rdev->raid_disk);
-		set_bit(Faulty, &rdev->flags);
+		md_error(rdev->mddev, rdev);
 		return -EINVAL;
 	}
 


