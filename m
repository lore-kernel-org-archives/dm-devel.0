From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 5 of 5] MD RAID1: Further conditionalize 'fullsync'
Date: Tue, 17 Apr 2012 21:43:51 -0500
Message-ID: <1334717031.23908.28.camel@f14.redhat.com>
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

A RAID1 device does not necessarily need a fullsync if the bitmap can be used instead.

Similar to commit d6b212f4b19da5301e6b6eca562e5c7a2a6e8c8d in raid5.c, if a raid1
device can be brought back (i.e. from a transient failure) it shouldn't need a
complete resync.  Provided the bitmap is not to old, it will have recorded the areas
of the disk that need recovery.

** I've used 'saved_raid_disk' here similar to RAID5, but it doesn't seem to fit
   as well.  The positions aren't really as important as they are in RAID5, and
   I'm using the 'saved_raid_disk' as more of an indicator that it can use the
   bitmap, rather than for any other purpose.  Perhaps the meaning is being
   overloaded and a different solution should be found?

RFC-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-upstream/drivers/md/raid1.c
===================================================================
--- linux-upstream.orig/drivers/md/raid1.c
+++ linux-upstream/drivers/md/raid1.c
@@ -2597,7 +2597,8 @@ static struct r1conf *setup_conf(struct 
 		if (!disk->rdev ||
 		    !test_bit(In_sync, &disk->rdev->flags)) {
 			disk->head_position = 0;
-			if (disk->rdev)
+			if (disk->rdev &&
+			    (disk->rdev->saved_raid_disk != disk->rdev->raid_disk))
 				conf->fullsync = 1;
 		} else if (conf->last_used < 0)
 			/*


