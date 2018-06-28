From: Mike Snitzer <snitzer@redhat.com>
Subject: [git pull] device mapper fixes for 4.18-rc3
Date: Thu, 28 Jun 2018 17:34:16 -0400
Message-ID: <20180628213416.GA20090@redhat.com>
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
Cc: Bart Van Assche <bart.vanassche@wdc.com>, dm-devel@redhat.com, Kees Cook <keescook@chromium.org>, Arnd Bergmann <arnd@arndb.de>, Ross Zwisler <ross.zwisler@linux.intel.com>
List-Id: dm-devel.ids

Hi Linus,

The following changes since commit ce397d215ccd07b8ae3f71db689aedb85d56ab40:

  Linux 4.18-rc1 (2018-06-17 08:04:49 +0900)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-4.18/dm-fixes

for you to fetch changes up to dbc626597c39b24cefce09fbd8e9dea85869a801:

  dm: prevent DAX mounts if not supported (2018-06-28 16:06:14 -0400)

Please pull, thanks.
Mike

----------------------------------------------------------------
- Fix dm core to use more efficient bio_split() instead of
  bio_clone_bioset().  Also fixes splitting bio that has integrity
  payload.

- Three fixes related to properly validating DAX capabilities of a
  stacked DM device that will advertise DAX support.

- Update DM writecache target to use 2-factor allocator arguments.  Kees
  says this is the last related change for 4.18.

- Fix DM zoned target to use GFP_NOIO to avoid triggering reclaim during
  IO submission (caught by lockdep).

- Fix DM thinp to gracefully recover from running out of data space
  while a previous async discard completes (whereby freeing space).

- Fix DM thinp's metadata transaction commit to avoid needless work.

----------------------------------------------------------------
Arnd Bergmann (1):
      dm raid: don't use 'const' in function return

Bart Van Assche (1):
      dm zoned: avoid triggering reclaim from inside dmz_map()

Kees Cook (1):
      dm writecache: use 2-factor allocator arguments

Mike Snitzer (3):
      dm: use bio_split() when splitting out the already processed bio
      dm thin metadata: remove needless work from __commit_transaction
      dm thin: handle running out of data space vs concurrent discard

Ross Zwisler (3):
      pmem: only set QUEUE_FLAG_DAX for fsdax mode
      dax: check for QUEUE_FLAG_DAX in bdev_dax_supported()
      dm: prevent DAX mounts if not supported

 drivers/dax/super.c           |  8 ++++++++
 drivers/md/dm-raid.c          |  2 +-
 drivers/md/dm-table.c         |  7 ++++---
 drivers/md/dm-thin-metadata.c |  9 ---------
 drivers/md/dm-thin.c          | 11 +++++++++--
 drivers/md/dm-writecache.c    | 10 +++++-----
 drivers/md/dm-zoned-target.c  |  2 +-
 drivers/md/dm.c               |  8 +++-----
 drivers/nvdimm/pmem.c         |  3 ++-
 9 files changed, 33 insertions(+), 27 deletions(-)
