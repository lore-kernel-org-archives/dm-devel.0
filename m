From: NeilBrown <nfbrown@novell.com>
Subject: [PATCH 0/8] The DM part of dm-raid45
Date: Mon, 26 Jul 2010 13:24:35 +1000
Message-ID: <20100726032230.29687.5366.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Heinz Mauelshagen <heinzm@redhat.com>, Alasdair G Kergon <agk@redhat.com>
Cc: linux-raid@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

As I discussed with Alasdair and Heinz, I have split my
"dm-raid45 using md/raid5.c" patches in to two sets.
The first set contains only changes to md code and is now in
my for-next branch
   git://neil.brown.name/md for-next

so it should appear in linux-next soon and I plan to submit it for the
next merge window.

The second set is all the dm specific bits.  They follow this email.
I'm hoping Alasdair will have time to review and approve these in time
for the next merge window.  All other review and comments are, of
course, most welcome.

Thanks,
NeilBrown

---

NeilBrown (8):
      md/dm: create dm-raid456 module using md/raid5
      dm-raid456: add congestion checking.
      dm-raid456: support unplug
      dm-raid456: add support for setting IO hints.
      dm-raid456: add suspend/resume method
      dm-raid456: add message handler.
      dm-dirty-log: allow log size to be different from target size.
      dm-raid456: switch to use dm_dirty_log for tracking dirty regions.


 drivers/md/Kconfig                 |    8 +
 drivers/md/Makefile                |    1 
 drivers/md/dm-log-userspace-base.c |   11 -
 drivers/md/dm-log.c                |   18 +
 drivers/md/dm-raid1.c              |    4 
 drivers/md/dm-raid456.c            |  576 ++++++++++++++++++++++++++++++++++++
 drivers/md/dm-table.c              |   19 +
 include/linux/device-mapper.h      |   13 +
 include/linux/dm-dirty-log.h       |    3 
 9 files changed, 639 insertions(+), 14 deletions(-)
 create mode 100644 drivers/md/dm-raid456.c

-- 

