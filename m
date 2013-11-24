From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 0/1] Recent breakage of DM RAID
Date: Sun, 24 Nov 2013 17:30:42 -0600
Message-ID: <1385335843-14021-1-git-send-email-jbrassow@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: jbrassow@redhat.com, neilb@suse.de, linux-raid@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

There have been two commits that have broken DM RAID:
1) 773ca82 (v3.12-rc1) raid5: make release_stripe lockless
2) 566c09c raid5: relieve lock contention in get_active_stripe()

I've provided a patch for the first, but I don't have a patch ready for
the second yet.  Since 3.12 is alreay out, I figured I better send the
patch for the first problem now.

Simply creating a RAID 4/5/6 device via device-mapper (or LVM) is sufficent
to cause the hang to manifest.

Jonathan Brassow (1):
  MD/DM RAID: Fix hang due to recent RAID5 locking changes

 drivers/md/dm-raid.c |    1 -
 drivers/md/md.c      |    5 ++++-
 2 files changed, 4 insertions(+), 2 deletions(-)

-- 
1.7.7.6

