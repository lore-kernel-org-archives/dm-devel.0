From: Mike Snitzer <snitzer@redhat.com>
Subject: [git pull] device mapper changes for 4.16
Date: Wed, 31 Jan 2018 13:44:52 -0500
Message-ID: <20180131184452.GA24901@redhat.com>
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
Cc: Scott Bauer <scott.bauer@intel.com>, mulhern <amulhern@redhat.com>, Ma Shimiao <mashimiao.fnst@cn.fujitsu.com>, Luis de Bethencourt <luisbg@kernel.org>, Heinz Mauelshagen <heinzm@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Brian Norris <briannorris@chromium.org>, NeilBrown <neilb@suse.com>, Khazhismel Kumykov <khazhy@google.com>, Ming Lei <ming.lei@redhat.com>, dm-devel@redhat.com, Aliaksei Karaliou <akaraliou.dev@gmail.com>, Alasdair G Kergon <agk@redhat.com>, Wei Yongjun <weiyongjun1@huawei.com>, Mikulas Patocka <mpatocka@redhat.com>, John Pittman <jpittman@redhat.com>, Goldwyn Rodrigues <rgoldwyn@suse.com>
List-Id: dm-devel.ids

Hi Linus,

The following changes since commit fbc7c07ec23c040179384a1f16b62b6030eb6bdd:

  dm bufio: fix shrinker scans when (nr_to_scan < retain_target) (2017-12-08 10:54:25 -0500)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-4.16/dm-changes

for you to fetch changes up to 9614e2ba9161c7f5419f4212fa6057d2a65f6ae6:

  dm cache: Documentation: update default migration_throttling value (2018-01-30 16:55:47 -0500)

Please pull, thanks!
Mike

----------------------------------------------------------------
- DM core fixes to ensure that bio submission follows a depth-first tree
  walk; this is critical to allow forward progress without the need to
  use the bioset's BIOSET_NEED_RESCUER.

- Remove DM core's BIOSET_NEED_RESCUER based dm_offload infrastructure.

- DM core cleanups and improvements to make bio-based DM more efficient
  (e.g. reduced memory footprint as well leveraging per-bio-data more).

- Introduce new bio-based mode (DM_TYPE_NVME_BIO_BASED) that leverages
  the more direct IO submission path in the block layer; this mode is
  used by DM multipath and also optimizes targets like DM thin-pool that
  stack directly on NVMe data device.

- DM multipath improvements to factor out legacy SCSI-only
  (e.g. scsi_dh) code paths to allow for more optimized support for NVMe
  multipath.

- A fix for DM multipath path selectors (service-time and queue-length)
  to select paths in a more balanced way; largely academic but doesn't
  hurt.

- Numerous DM raid target fixes and improvements.

- Add a new DM "unstriped" target that enables Intel to workaround
  firmware limitations in some NVMe drives that are striped internally
  (this target also works when stacked above the DM "striped" target).

- Various Documentation fixes and improvements.

- Misc. cleanups and fixes across various DM infrastructure and targets
  (e.g. bufio, flakey, log-writes, snapshot).

----------------------------------------------------------------
Aliaksei Karaliou (2):
      dm bufio: add missed destroys of client mutex
      dm bufio: check result of register_shrinker()

Brian Norris (1):
      dm: move dm_table_destroy() to same header as dm_table_create()

Goldwyn Rodrigues (1):
      dm flakey: check for null arg_name in parse_features()

Heinz Mauelshagen (15):
      dm raid: fix deadlock caused by premature md_stop_writes()
      dm raid: consume sizes after md_finish_reshape() completes changing them
      dm raid: correct resizing state relative to reshape space in ctr
      dm raid: fix raid set size revalidation
      dm raid: add component device size checks to avoid runtime failure
      dm raid: fix raid_resume() to keep raid set frozen as needed
      dm raid: display a consistent copy of the MD status via raid_status()
      dm raid: avoid passing array_in_sync variable to raid_status() callees
      dm raid: fix rs_get_progress() synchronization state/ratio
      dm raid: small cleanup and remove unsed "struct raid_set" member
      dm raid: validate current raid sets redundancy
      dm raid: stop keeping raid set frozen altogether
      dm raid: ensure 'a' chars during reshape
      dm raid: simplify rs_get_progress()
      dm raid: use rs_is_raid*()

John Pittman (1):
      dm cache: Documentation: update default migration_throttling value

Khazhismel Kumykov (1):
      dm mpath selector: more evenly distribute ties

Luis de Bethencourt (1):
      dm thin: fix trailing semicolon in __remap_and_issue_shared_cell

Ma Shimiao (1):
      dm log writes: fix max length used for kstrndup

Mike Snitzer (26):
      dm raid: bump target version to reflect numerous fixes
      dm: safely allocate multiple bioset bios
      dm: remove BIOSET_NEED_RESCUER based dm_offload infrastructure
      dm: ensure bio-based DM's bioset and io_pool support targets' maximum IOs
      dm: fix __send_changing_extent_only() to send first bio and chain remainder
      dm: set QUEUE_FLAG_DAX accordingly in dm_table_set_restrictions()
      dm: remove stale comment blocks
      dm: rename 'bio' member of dm_io structure to 'orig_bio'
      dm: improve performance by moving dm_io structure to per-bio-data
      dm: remove now unused bio-based io_pool and _io_cache
      dm: remove redundant mapped_device member from clone_info structure
      dm: simplify start of block stats accounting for bio-based
      dm: introduce DM_TYPE_NVME_BIO_BASED
      dm: optimize bio-based NVMe IO submission
      dm mpath: remove unused param from multipath_init_per_bio_data()
      dm mpath: remove unnecessary memset() calls for per-io-data
      dm mpath: optimize retrieval of bio_details from per-bio-data
      dm mpath: move dm_bio_restore out of endio method
      dm mpath: implement NVMe bio-based support
      dm mpath: optimize NVMe bio-based support
      dm mpath: factor out SCSI vs NVMe path selection
      dm bufio: eliminate unnecessary labels in dm_bufio_client_create()
      dm: backfill missing calls to mutex_destroy()
      dm mpath: delay the retry of a request if the target responded as busy
      dm: various cleanups to md->queue initialization code
      dm table: fix NVMe bio-based dm_table_determine_type() validation

Mikulas Patocka (3):
      dm bufio: use REQ_OP_READ and REQ_OP_WRITE
      dm snapshot: improve documentation relative to origin suspend requirements
      dm snapshot: use mutex instead of rw_semaphore

Ming Lei (2):
      dm mpath: return DM_MAPIO_REQUEUE on blk-mq rq allocation failure
      dm mpath: return DM_MAPIO_DELAY_REQUEUE if QUEUE_IO or PG_INIT_REQUIRED

NeilBrown (5):
      dm: fix comment above dm_accept_partial_bio
      dm crypt: remove BIOSET_NEED_RESCUER flag
      dm io: remove BIOSET_NEED_RESCUER flag from bios bioset
      dm: ensure bio submission follows a depth-first tree walk
      dm: remove unused 'num_write_bios' target interface

Scott Bauer (2):
      dm: add unstriped target
      dm unstripe: fix target length versus number of stripes size check

Wei Yongjun (1):
      dm raid: make raid_sets symbol static

mulhern (7):
      dm cache: fix grammar in cache-policies.txt
      dm cache: delete obsoleted paragraph in cache.txt
      dm cache: be consistent in specifying sectors and SI units in cache.txt
      dm thin: fix documentation relative to low water mark threshold
      dm thin: document representation of <highest mapped sector> when there is none
      dm thin: fixes in thin-provisioning.txt
      dm thin: extend thinpool status format string with omitted fields

 Documentation/device-mapper/cache-policies.txt    |   4 +-
 Documentation/device-mapper/cache.txt             |   9 +-
 Documentation/device-mapper/dm-raid.txt           |   5 +-
 Documentation/device-mapper/snapshot.txt          |   4 +
 Documentation/device-mapper/thin-provisioning.txt |  14 +-
 Documentation/device-mapper/unstriped.txt         | 124 ++++
 drivers/md/Kconfig                                |   7 +
 drivers/md/Makefile                               |   1 +
 drivers/md/dm-bufio.c                             |  37 +-
 drivers/md/dm-core.h                              |   5 +-
 drivers/md/dm-crypt.c                             |   5 +-
 drivers/md/dm-delay.c                             |   2 +
 drivers/md/dm-flakey.c                            |   5 +
 drivers/md/dm-io.c                                |   3 +-
 drivers/md/dm-kcopyd.c                            |   6 +-
 drivers/md/dm-log-writes.c                        |   2 +-
 drivers/md/dm-mpath.c                             | 297 ++++++----
 drivers/md/dm-queue-length.c                      |   6 +-
 drivers/md/dm-raid.c                              | 380 ++++++++-----
 drivers/md/dm-rq.c                                |   6 +-
 drivers/md/dm-service-time.c                      |   6 +-
 drivers/md/dm-snap.c                              |  84 +--
 drivers/md/dm-stats.c                             |   1 +
 drivers/md/dm-table.c                             | 114 +++-
 drivers/md/dm-thin.c                              |   9 +-
 drivers/md/dm-unstripe.c                          | 219 +++++++
 drivers/md/dm-zoned-metadata.c                    |   3 +
 drivers/md/dm-zoned-target.c                      |   3 +
 drivers/md/dm.c                                   | 659 +++++++++++++---------
 drivers/md/dm.h                                   |   4 +-
 include/linux/device-mapper.h                     |  56 +-
 31 files changed, 1409 insertions(+), 671 deletions(-)
 create mode 100644 Documentation/device-mapper/unstriped.txt
 create mode 100644 drivers/md/dm-unstripe.c
