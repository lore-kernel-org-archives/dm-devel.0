From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 3 of 5] DM RAID: Use safe version of rdev_for_each
Date: Tue, 17 Apr 2012 21:38:22 -0500
Message-ID: <1334716702.23908.22.camel@f14.redhat.com>
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

Fix segfault caused by using rdev_for_each instead of rdev_for_each_safe

Commit dafb20fa34320a472deb7442f25a0c086e0feb33 mistakenly replaced a safe
iterator with an unsafe one when making some macro changes.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-upstream/drivers/md/dm-raid.c
===================================================================
--- linux-upstream.orig/drivers/md/dm-raid.c
+++ linux-upstream/drivers/md/dm-raid.c
@@ -861,7 +861,7 @@ static int analyse_superblocks(struct dm
 	int ret;
 	unsigned redundancy = 0;
 	struct raid_dev *dev;
-	struct md_rdev *rdev, *freshest;
+	struct md_rdev *rdev, *tmp, *freshest;
 	struct mddev *mddev = &rs->md;
 
 	switch (rs->raid_type->level) {
@@ -879,7 +879,7 @@ static int analyse_superblocks(struct dm
 	}
 
 	freshest = NULL;
-	rdev_for_each(rdev, mddev) {
+	rdev_for_each_safe(rdev, tmp, mddev) {
 		if (!rdev->meta_bdev)
 			continue;
 


