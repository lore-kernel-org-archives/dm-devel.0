From: Mike Snitzer <snitzer@redhat.com>
Subject: [git pull v2] device mapper fixes to include in 3.14-rc6
Date: Fri, 7 Mar 2014 12:58:21 -0500
Message-ID: <20140307175820.GA9660@redhat.com>
References: <20140306205051.GA24631@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140306205051.GA24631@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org, Heinz Mauelshagen <heinzm@redhat.com>, Joe Thornber <ejt@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

Hi Linus,

Seems you haven't pulled tags/dm-3.14-fixes-2 yet, but either way please
pull tags/dm-3.14-fixes-3

Sorry for requesting that you pull another tag so quickly but a late
breaking yet _very_ important bug fix for dm thin-provisioning and dm
cache has landed based on a really helpful bug report from last night
(see commit cebc2de).

The following changes since commit e0d849fad746cb36a6822e4595d8ba9bf0adf7fa:

  dm cache: fix truncation bug when mapping I/O to >2TB fast device (2014-02-28 09:23:02 -0500)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/dm-3.14-fixes-3

for you to fetch changes up to cebc2de44d3bce53e46476e774126c298ca2c8a9:

  dm space map metadata: fix refcount decrement below 0 which caused corruption (2014-03-07 12:02:47 -0500)

Please pull, thanks!
Mike

----------------------------------------------------------------
A dm-cache memory allocation failure fix, fix DM's Kconfig identation, a
dm-snapshot metadata corruption fix for bug introduced in 3.14-rc1, an
important refcount < 0 fix for the DM persistent data library's space
map metadata interface which fixes corruption reported by a few dm-thinp
users, and last but not least: more extensive fixes than ideal for
dm-thinp's data resize capability (which has had growing pain much like
we've seen from -ENOSPC handling of filesystems that mature).  The end
result is dm-thinp now handles metadata operation failure and no data
space error conditions much better than before.

----------------------------------------------------------------
Heinz Mauelshagen (1):
      dm cache mq: fix memory allocation failure for large cache devices

Joe Thornber (4):
      dm thin: fix out of data space handling
      dm thin: fix deadlock in __requeue_bio_list
      dm thin: fix noflush suspend IO queueing
      dm space map metadata: fix refcount decrement below 0 which caused corruption

Mike Snitzer (4):
      dm: fix Kconfig indentation
      dm thin: synchronize the pool mode during suspend
      dm thin: ensure user takes action to validate data and metadata consistency
      dm thin: fix Documentation for held metadata root feature

Mikulas Patocka (1):
      dm snapshot: fix metadata corruption

 Documentation/device-mapper/cache.txt              |  11 +-
 Documentation/device-mapper/thin-provisioning.txt  |  34 ++-
 drivers/md/Kconfig                                 |  10 -
 drivers/md/dm-cache-policy-mq.c                    |   4 +-
 drivers/md/dm-snap-persistent.c                    |   3 +
 drivers/md/dm-thin-metadata.c                      |  37 ++-
 drivers/md/dm-thin-metadata.h                      |  11 +
 drivers/md/dm-thin.c                               | 304 ++++++++++++++++-----
 drivers/md/persistent-data/Kconfig                 |  10 +
 drivers/md/persistent-data/dm-space-map-metadata.c | 113 ++++++--
 10 files changed, 425 insertions(+), 112 deletions(-)
