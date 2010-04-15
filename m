From: NeilBrown <neilb@suse.de>
Subject: [PATCH 00/12] A dm-raid45 target implemented using md
	raid5.
Date: Thu, 15 Apr 2010 16:43:02 +1000
Message-ID: <20100415062909.15646.16.stgit@notabene.brown>
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
Cc: linux-raid@vger.kernel.org, HeinzMauelshagen <heinzm@redhat.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Greetings Heinz, Alasdair, and all,
(Alasdair and Heinz cc:ed on this intro, but the patches are
 only going to the lists).

 Some months ago I posted a proof-of-concept patch which attempted to
 provide RAID4/5/6 functionality to 'dm' using md/raid5.c.
 While it did a least partly work it contained lots of hacks and was
 very ugly.

 I finally made time to do the job "properly".

 The following series, when applied on top of a bunch of patches I
 just submitted for linux-next, provides a 'dm-raid45' target which is
 largely compatible with the one that Heinz has written (and several
 distros are shipping), but which uses md/raid5.c for the core IO
 processing.

 I have tried to split the patch up into easy-to-handle pieces.  You
 will note that some changes to core-dm are required, in particular to
 pass back 'congestion' information and to handle plugging (which
 raid5 uses to improve throughput).  I hope the approach I have taken
 is suitable, but it can obviously be changed if necessary.

 The create/status/message interface differs from the one in Heinz's
 patch, but should be close enough to work with current 'dmraid'.

 If you want to try the patches (rather than just read them) you
 should probably "git pull" (please don't clone) from
      git://neil.brown.name/md md-dm-raid45

 so as to get all the prior refactoring patches in md.

 Some advantages of this over Heinz's patch (at least as it was
 when I last looked at it) are:
  - raid6 support
  - support for XOR-offload hardware where present
  - less code duplication
  - a single dm device can include multiple dm-raid45 targets.
    (Heinz' code accesses dm_disk(md)->queue directly which
     is a layering violations and assumes that there is no
     other target in the mapped_device).

 There is a lot more that could be done to this such as getting to
 work with a disk based dirty-log and making the reshape options
 available.  But this patch set should provide all basic RAID5
 functionality.

 Would the dm community be interested in including this work upstream
 (after suitable review and testing)?

Thanks,
NeilBrown


---

NeilBrown (12):
      md: reduce dependence on sysfs.
      md/raid5: factor out code for changing size of stripe cache.
      md/dm: create dm-raid456 module using md/raid5
      dm-raid456: add support for raising events to userspace.
      raid5: Don't set read-ahead when there is no queue
      dm-raid456: add congestion checking.
      md/raid5: add simple plugging infrastructure.
      md/plug: optionally use plugger to unplug an array during resync/recovery.
      dm-raid456: support unplug
      dm-raid456: add support for setting IO hints.
      dm-raid456: add suspend/resume method
      dm-raid456: add message handler.


 drivers/md/Kconfig            |    8 +
 drivers/md/Makefile           |    1 
 drivers/md/dm-raid456.c       |  540 +++++++++++++++++++++++++++++++++++++++++
 drivers/md/dm-table.c         |   19 +
 drivers/md/md.c               |  211 ++++++++++------
 drivers/md/md.h               |   43 +++
 drivers/md/raid5.c            |  155 +++++++-----
 drivers/md/raid5.h            |    6 
 include/linux/device-mapper.h |   13 +
 9 files changed, 859 insertions(+), 137 deletions(-)
 create mode 100644 drivers/md/dm-raid456.c

-- 
