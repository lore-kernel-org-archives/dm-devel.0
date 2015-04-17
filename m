From: Mike Snitzer <snitzer@redhat.com>
Subject: [git pull] device mapper changes for 4.1
Date: Thu, 16 Apr 2015 22:20:23 -0400
Message-ID: <20150417022023.GA672@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
Cc: Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@redhat.com>, Josef Bacik <jbacik@fb.com>, Joe Thornber <ejt@redhat.com>, Dan Ehrenberg <dehrenberg@chromium.org>, dm-devel@redhat.com, Sami Tolvanen <samitolvanen@google.com>, Nicholas Mc Guire <hofrat@osadl.org>, Joe Perches <joe@perches.com>, Wei Yongjun <yongjun_wei@trendmicro.com.cn>, Ben Collins <ben.c@servergy.com>, Milan Broz <gmazyland@gmail.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Hi Linus,

The following changes since commit 851c9f38e4199adb612366f8e202036d624d5de2:

  Merge remote-tracking branch 'jens/for-4.1/core' into dm/for-next (2015-03-31 12:00:32 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm tags/dm-4.1-changes

for you to fetch changes up to 44c144f9c8e8fbd73ede2848da8253b3aae42ec2:

  dm crypt: fix missing error code return from crypt_ctr error path (2015-04-16 22:00:50 -0400)

Please pull, thanks.
Mike

----------------------------------------------------------------
- Most extensive changes this cycle are the DM core improvements to add
  full blk-mq support to request-based DM.
  - disabled by default but user can opt-in with CONFIG_DM_MQ_DEFAULT
  - depends on some blk-mq changes from Jens' for-4.1/core branch so
    that explains why this pull is built on linux-block.git

- Update DM to use name_to_dev_t() rather than open-coding a less
  capable device parser.
  - includes a couple small improvements to name_to_dev_t() that offer
    stricter constraints that DM's code provided.

- Improvements to the dm-cache "mq" cache replacement policy.

- A DM crypt crypt_ctr() error path fix and an async crypto deadlock fix.

- A small efficiency improvement for DM crypt decryption by leveraging
  immutable biovecs.

- Add error handling modes for corrupted blocks to DM verity.

- A new "log-writes" DM target from Josef Bacik that is meant for
  file system developers to test file system integrity at particular
  points in the life of a file system.

- A few DM log userspace cleanups and fixes.

- A few Documentation fixes (for thin, cache, crypt and switch).

----------------------------------------------------------------
Ben Collins (1):
      dm crypt: fix deadlock when async crypto algorithm returns -EBUSY

Dan Ehrenberg (3):
      init: export name_to_dev_t and mark name argument as const
      init: stricter checking of major:minor root= values
      dm table: fall back to getting device using name_to_dev_t()

Joe Perches (1):
      dm table: use bool function return values of true/false not 1/0

Joe Thornber (5):
      dm cache policy mq: keep track of the number of entries in a multiqueue
      dm cache policy mq: remove queue_shift_down()
      dm cache policy mq: track entries hit this 'tick' via sentinel objects
      dm cache policy mq: remove unused generation member of struct entry
      dm cache policy mq: try not to writeback data that changed in the last second

Josef Bacik (1):
      dm: add log writes target

Mike Snitzer (17):
      dm log userspace: split flush_entry_pool to be per dirty-log
      dm switch: fix Documentation to use plain text
      dm: rename __dm_get_reserved_ios() helper to __dm_get_module_param()
      dm: remove unnecessary wrapper around blk_lld_busy
      dm: remove request-based DM queue's lld_busy_fn hook
      dm: remove request-based logic from make_request_fn wrapper
      dm: only run the queue on completion if congested or no requests pending
      dm: don't schedule delayed run of the queue if nothing to do
      dm: reduce the queue delay used in dm_request_fn from 100ms to 10ms
      dm: don't start current request if it would've merged with the previous
      dm sysfs: introduce ability to add writable attributes
      dm: impose configurable deadline for dm_request_fn's merge heuristic
      dm: add full blk-mq support to request-based DM
      dm: optimize dm_mq_queue_rq to _not_ use kthread if using pure blk-mq
      dm: add 'use_blk_mq' module param and expose in per-device ro sysfs attr
      dm thin: remove stale 'trim' message documentation
      dm crypt: leverage immutable biovecs when decrypting on read

Milan Broz (1):
      dm crypt: update URLs to new cryptsetup project page

Nicholas Mc Guire (3):
      dm log userspace transfer: match wait_for_completion_timeout return type
      dm log userspace base: fix compile warning
      dm delay: use msecs_to_jiffies for time conversion

Sami Tolvanen (1):
      dm verity: add error handling modes for corrupted blocks

Wei Yongjun (1):
      dm crypt: fix missing error code return from crypt_ctr error path

 Documentation/ABI/testing/sysfs-block-dm          |  22 +
 Documentation/device-mapper/dm-crypt.txt          |   4 +-
 Documentation/device-mapper/log-writes.txt        | 140 ++++
 Documentation/device-mapper/switch.txt            |   4 +-
 Documentation/device-mapper/thin-provisioning.txt |   3 -
 Documentation/device-mapper/verity.txt            |  21 +-
 drivers/md/Kconfig                                |  27 +
 drivers/md/Makefile                               |   1 +
 drivers/md/dm-cache-policy-mq.c                   | 251 +++++--
 drivers/md/dm-crypt.c                             |  25 +-
 drivers/md/dm-delay.c                             |   2 +-
 drivers/md/dm-log-userspace-base.c                |  91 +--
 drivers/md/dm-log-userspace-transfer.c            |   5 +-
 drivers/md/dm-log-writes.c                        | 825 ++++++++++++++++++++++
 drivers/md/dm-mpath.c                             |   6 +-
 drivers/md/dm-sysfs.c                             |  43 +-
 drivers/md/dm-table.c                             |  71 +-
 drivers/md/dm-verity.c                            | 147 +++-
 drivers/md/dm.c                                   | 556 +++++++++++----
 drivers/md/dm.h                                   |  10 +-
 include/linux/device-mapper.h                     |   5 -
 include/linux/mount.h                             |   2 +-
 include/uapi/linux/dm-ioctl.h                     |   4 +-
 init/do_mounts.c                                  |   6 +-
 24 files changed, 1928 insertions(+), 343 deletions(-)
 create mode 100644 Documentation/device-mapper/log-writes.txt
 create mode 100644 drivers/md/dm-log-writes.c
