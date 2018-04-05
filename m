From: Mike Snitzer <snitzer@redhat.com>
Subject: [git pull] device mapper changes for 4.17
Date: Thu, 5 Apr 2018 11:19:42 -0400
Message-ID: <20180405151942.GA20923@redhat.com>
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
Cc: Tycho Andersen <tycho@tycho.ws>, Mike Snitzer <snitzer@redhat.com>, Heinz Mauelshagen <heinzm@redhat.com>, Patrik Torstensson <totte@google.com>, Wang Sheng-Hui <shhuiw@foxmail.com>, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, Qu Wenruo <wqu@suse.com>, weiyongjun <weiyongjun1@huawei.com>, Denis Semakin <d.semakin@omprussia.ru>, Milan Broz <gmazyland@gmail.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Hi Linus,

There is one merge conflict with the 4.17 block tree to be aware of,
please see this patch that linux-next has been carrying:
https://lkml.org/lkml/2018/3/26/768

The following changes since commit da5dadb4f11660ca67580cd4a7420161266d6254:

  dm: fix dropped return code from dm_get_bdev_for_ioctl (2018-03-29 23:31:32 -0400)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-4.17/dm-changes

for you to fetch changes up to 5bd5e8d891c1fd2d966a7e2c26f0452d22410683:

  dm: remove fmode_t argument from .prepare_ioctl hook (2018-04-04 12:12:39 -0400)

Please pull, thanks!
Mike

----------------------------------------------------------------
- DM core passthrough ioctl fix to retain reference to DM table, and
  that table's block devices, while issuing the ioctl to one of those
  block devices.

- DM core passthrough ioctl fix to _not_ override the fmode_t used to
  issue the ioctl.  Overriding by using the fmode_t that the block
  device was originally open with during DM table load is a liability.

- Add DM core support for secure erase forwarding and update the DM
  linear and DM striped targets to support them.

- A DM core 4.16 stable fix to allow abnormal IO (e.g. discard, write
  same, write zeroes) for targets that make use of the non-splitting IO
  variant (as is done for multipath or thinp when layered directly on
  NVMe).

- Allow DM targets to return a payload in response to a DM message that
  they are sent.  This is useful for DM targets that would like to
  provide statistics data in response to DM messages.

- Update DM bufio to support non-power-of-2 block sizes.  Numerous other
  related changes prepare the DM bufio code for this support.

- Fix DM crypt to use a bounded amount of memory across the entire
  system.  This is to avoid OOM that can otherwise occur in response to
  certain pathological IO workloads (e.g. discarding a large DM crypt
  device).

- Add a 'check_at_most_once' feature to the DM verity target to allow
  verity to be used on mobile devices that have very limited resources.

- Fix the DM integrity target to fail early if a keyed algorithm
  (e.g. HMAC) is to be used but the key isn't set.

- Add non-power-of-2 support to the DM unstripe target.

- Eliminate the use of a Variable Length Array in the DM stripe target.

- Update the DM log-writes target to record metadata (REQ_META flag).

- DM raid fixes for its nosync status and some variable range issues.

----------------------------------------------------------------
Denis Semakin (1):
      dm: add support for secure erase forwarding

Heinz Mauelshagen (6):
      dm unstripe: support non-power-of-2 chunk size
      dm unstripe: add "dm-unstriped" module alias
      dm unstripe: remove superfluous module init error path message
      dm unstripe: remove unnecessary header includes
      dm raid: fix nosync status
      dm raid: fix parse_raid_params() variable range issue

Mike Snitzer (4):
      dm: allow targets to return output from messages they are sent
      dm: backfill abnormal IO support to non-splitting IO submission
      dm: hold DM table for duration of ioctl rather than use blkdev_get
      dm: remove fmode_t argument from .prepare_ioctl hook

Mikulas Patocka (10):
      dm crypt: limit the number of allocated pages
      dm bufio: delete outdated comment
      dm bufio: move dm-bufio.h to include/linux/
      dm bufio: get rid of slab cache name allocations
      dm bufio: remove code that merges slab caches
      dm bufio: relax alignment constraint on slab cache
      dm bufio: reorder fields in dm_buffer structure
      dm bufio: use slab cache for dm_buffer structure allocations
      dm bufio: support non-power-of-two block sizes
      dm bufio: don't embed a bio in the dm_buffer structure

Milan Broz (1):
      dm integrity: fail early if required HMAC key is not available

Patrik Torstensson (1):
      dm verity: add 'check_at_most_once' option to only validate hashes once

Qu Wenruo (1):
      dm log writes: record metadata flag for better flags record

Tycho Andersen (1):
      dm stripe: get rid of a Variable Length Array (VLA)

Wang Sheng-Hui (2):
      dm: remove unused macro DM_MOD_NAME_SIZE
      dm mpath: use DM_MAPIO_SUBMITTED instead of magic number 0 in process_queued_bios()

weiyongjun (A) (1):
      dm verity: make verity_for_io_block static

 Documentation/device-mapper/verity.txt        |  11 +
 drivers/md/dm-bufio.c                         | 279 +++++++++++---------------
 drivers/md/dm-cache-target.c                  |   3 +-
 drivers/md/dm-crypt.c                         |  69 ++++++-
 drivers/md/dm-era-target.c                    |   3 +-
 drivers/md/dm-flakey.c                        |   3 +-
 drivers/md/dm-integrity.c                     |   5 +-
 drivers/md/dm-ioctl.c                         |   2 +-
 drivers/md/dm-linear.c                        |   4 +-
 drivers/md/dm-log-writes.c                    |  17 +-
 drivers/md/dm-mpath.c                         |   8 +-
 drivers/md/dm-raid.c                          |  33 ++-
 drivers/md/dm-snap-persistent.c               |   2 +-
 drivers/md/dm-stripe.c                        |  12 +-
 drivers/md/dm-switch.c                        |   7 +-
 drivers/md/dm-table.c                         |  31 +++
 drivers/md/dm-target.c                        |   2 -
 drivers/md/dm-thin.c                          |   3 +-
 drivers/md/dm-unstripe.c                      |  37 ++--
 drivers/md/dm-verity-target.c                 |  71 ++++++-
 drivers/md/dm-verity.h                        |   3 +-
 drivers/md/dm-zoned-target.c                  |   3 +-
 drivers/md/dm.c                               | 145 +++++++------
 drivers/md/persistent-data/dm-block-manager.c |   2 +-
 include/linux/device-mapper.h                 |  12 +-
 {drivers/md => include/linux}/dm-bufio.h      |   4 +-
 include/uapi/linux/dm-ioctl.h                 |   4 +-
 27 files changed, 465 insertions(+), 310 deletions(-)
 rename {drivers/md => include/linux}/dm-bufio.h (98%)
