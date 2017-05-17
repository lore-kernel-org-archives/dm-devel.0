From: Mike Snitzer <snitzer@redhat.com>
Subject: [git pull] device mapper fixes for 4.12-rc2
Date: Wed, 17 May 2017 15:12:33 -0400
Message-ID: <20170517191233.GA17419@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Joe Thornber <ejt@redhat.com>, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, Colin Ian King <colin.king@canonical.com>, Christoph Hellwig <hch@lst.de>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Hi Linus,

The following changes since commit 2ea659a9ef488125eb46da6eb571de5eae5c43f6:

  Linux 4.12-rc1 (2017-05-13 13:19:49 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-4.12/dm-fixes-2

for you to fetch changes up to 7e1b9521f5a8356553f5e58b07952bf346632ea4:

  dm cache: handle kmalloc failure allocating background_tracker struct (2017-05-17 09:44:53 -0400)

Please pull, thanks.
Mike

----------------------------------------------------------------
- A couple DM thin provisioning fixes

- A few request-based DM and DM multipath fixes for issues that were
  made when merging Christoph's changes with Bart's changes for 4.12

- A DM bufio unsigned overflow fix

- A couple pure fixes for the DM cache target.

- Various very small tweaks to the DM cache target that enable
  considerable speed improvements in the face of continuous IO.  Given
  that the cache target was significantly reworked for 4.12 I see no
  reason to sit on these advances until 4.13 considering the favorable
  results associated with such minimalist tweaks.

----------------------------------------------------------------
Christoph Hellwig (3):
      dm rq: add a missing break to map_request
      dm mpath: don't return -EIO from dm_report_EIO
      dm mpath: multipath_clone_and_map must not return -EIO

Colin Ian King (1):
      dm cache: handle kmalloc failure allocating background_tracker struct

Joe Thornber (10):
      dm cache: fix incorrect 'idle_time' reset in IO tracker
      dm cache policy smq: only demote entries in bottom half of the clean multiqueue
      dm cache policy smq: be more aggressive about triggering a writeback
      dm cache policy smq: put newly promoted entries at the top of the multiqueue
      dm cache policy smq: stop preemptively demoting blocks
      dm cache: track all IO to the cache rather than just the origin device's IO
      dm cache: simplify the IDLE vs BUSY state calculation
      dm cache policy smq: don't do any writebacks unless IDLE
      dm thin metadata: call precommit before saving the roots
      dm space map disk: fix some book keeping in the disk space map

Mikulas Patocka (1):
      dm bufio: make the parameter "retain_bytes" unsigned long

 drivers/md/dm-bufio.c                          | 16 ++++++-------
 drivers/md/dm-cache-background-tracker.c       |  5 +++++
 drivers/md/dm-cache-policy-smq.c               | 31 ++++++++++----------------
 drivers/md/dm-cache-target.c                   | 27 +++++++++++-----------
 drivers/md/dm-mpath.c                          | 19 +++++++++-------
 drivers/md/dm-rq.c                             |  1 +
 drivers/md/dm-thin-metadata.c                  |  4 ++--
 drivers/md/persistent-data/dm-space-map-disk.c | 15 ++++++++++++-
 8 files changed, 66 insertions(+), 52 deletions(-)
