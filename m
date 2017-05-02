From: Mike Snitzer <snitzer@redhat.com>
Subject: [git pull] device mapper changes for 4.12
Date: Tue, 2 May 2017 14:58:47 -0400
Message-ID: <20170502185847.GA79886@redhat.com>
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
Cc: Somasundaram Krishnasamy <somasundaram.krishnasamy@oracle.com>, Adrian Salido <salidoa@google.com>, Heinz Mauelshagen <heinzm@redhat.com>, Eric Biggers <ebiggers@google.com>, Andy Shevchenko <andy.shevchenko@gmail.com>, Dennis Yang <dennisyang@qnap.com>, Milan Broz <gmazyland@gmail.com>, Vinothkumar Raja <vinraja@cs.stonybrook.edu>, Gilad Ben-Yossef <gilad@benyossef.com>, dm-devel@redhat.com, Matthias Kaehlcke <mka@chromium.org>, Mikulas Patocka <mpatocka@redhat.com>, Tim Murray <timmurray@google.com>, Ondrej Kozina <okozina@redhat.com>, Bart Van Assche <bart.vanassche@sandisk.com>, Joe Thornber <ejt@redhat.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Hi Linus,

The following changes since commit c1ae3cfa0e89fa1a7ecc4c99031f5e9ae99d9201:

  Linux 4.11-rc1 (2017-03-05 12:59:56 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-4.12/dm-changes

for you to fetch changes up to 390020ad2af9ca04844c4f3b1f299ad8746d84c8:

  dm bufio: check new buffer allocation watermark every 30 seconds (2017-05-01 15:21:42 -0400)

Please pull, thanks.
Mike

----------------------------------------------------------------
- A major update for DM cache that reduces the latency for deciding
  whether blocks should migrate to/from the cache.  The bio-prison-v2
  interface supports this improvement by enabling direct dispatch of
  work to workqueues rather than having to delay the actual work
  dispatch to the DM cache core.  So the dm-cache policies are much more
  nimble by being able to drive IO as they see fit.  One immediate
  benefit from the improved latency is a cache that should be much more
  adaptive to changing workloads.

- Add a new DM integrity target that emulates a block device that has
  additional per-sector tags that can be used for storing integrity
  information.

- Add a new authenticated encryption feature to the DM crypt target that
  builds on the capabilities provided by the DM integrity target.

- Add MD interface for switching the raid4/5/6 journal mode and update
  the DM raid target to use it to enable aid4/5/6 journal write-back
  support.

- Switch the DM verity target over to using the asynchronous hash crypto
  API (this helps work better with architectures that have access to
  off-CPU algorithm providers, which should reduce CPU utilization).

- Various request-based DM and DM multipath fixes and improvements from
  Bart and Christoph.

- A DM thinp target fix for a bio structure leak that occurs for each
  discard IFF discard passdown is enabled.

- A fix for a possible deadlock in DM bufio and a fix to re-check the
  new buffer allocation watermark in the face of competing admin changes
  to the 'max_cache_size_bytes' tunable.

- A couple DM core cleanups.

----------------------------------------------------------------
Adrian Salido (1):
      dm ioctl: prevent stack leak in dm ioctl call

Andy Shevchenko (1):
      dm crypt: replace custom implementation of hex2bin()

Bart Van Assche (12):
      dm mpath: requeue after a small delay if blk_get_request() fails
      dm mpath: split and rename activate_path() to prepare for its expanded use
      dm mpath: avoid that path removal can trigger an infinite loop
      dm mpath: delay requeuing while path initialization is in progress
      dm rq: check blk_mq_register_dev() return value in dm_mq_init_request_queue()
      dm block manager: remove an unused argument from dm_block_manager_create()
      dm: verify suspend_locking assumptions at runtime
      dm mpath: verify __pg_init_all_paths locking assumptions at runtime
      dm: introduce enum dm_queue_mode to cleanup related code
      dm mpath: micro-optimize the hot path relative to MPATHF_QUEUE_IF_NO_PATH
      dm mpath: cleanup QUEUE_IF_NO_PATH bit manipulation by introducing assign_bit()
      dm mpath: make it easier to detect unintended I/O request flushes

Dennis Yang (1):
      dm thin: fix a memory leak when passing discard bio down

Eric Biggers (1):
      dm crypt: remove obsolete references to per-CPU state

Gilad Ben-Yossef (1):
      dm verity: switch to using asynchronous hash crypto API

Heinz Mauelshagen (3):
      md: add raid4/5/6 journal mode switching API
      dm raid: fix table line argument order in status
      dm raid: add raid4/5/6 journal write-back support via journal_mode option

Joe Thornber (4):
      dm bio prison v2: new interface for the bio prison
      dm cache: significant rework to leverage dm-bio-prison-v2
      dm cache: set/clear the cache core's dirty_bitset when loading mappings
      dm cache policy smq: make the cleaner policy write-back more aggressively

Matthias Kaehlcke (1):
      dm ioctl: remove double parentheses

Mike Snitzer (1):
      dm integrity: factor out create_journal() from dm_integrity_ctr()

Mikulas Patocka (15):
      dm bufio: add sector start offset to dm-bufio interface
      dm: add integrity target
      dm integrity: add recovery mode
      dm crypt: use shifts instead of sector_div
      dm raid: select the Kconfig option CONFIG_MD_RAID0
      dm table: replace while loops with for loops
      dm: mark targets that pass integrity data
      dm integrity: various small changes and cleanups
      dm integrity: support larger block sizes
      dm crypt: fix large block integrity support
      dm: remove dummy dm_table definition
      dm integrity: use hex2bin instead of open-coded variant
      dm integrity: use previously calculated log2 of sectors_per_block
      dm bufio: avoid a possible ABBA deadlock
      dm bufio: check new buffer allocation watermark every 30 seconds

Milan Broz (5):
      dm table: add flag to allow target to handle its own integrity metadata
      dm crypt: add cryptographic data integrity protection (authenticated encryption)
      dm crypt: factor IV constructor out to separate function
      dm crypt: introduce new format of cipher with "capi:" prefix
      dm crypt: optionally support larger encryption sector size

Ondrej Kozina (1):
      dm crypt: rewrite (wipe) key in crypto layer using random data

Somasundaram Krishnasamy (1):
      dm era: save spacemap metadata root after the pre-commit

Tim Murray (1):
      dm crypt: use WQ_HIGHPRI for the IO and crypt workqueues

Vinothkumar Raja (1):
      dm btree: fix for dm_btree_find_lowest_key()

 Documentation/device-mapper/dm-crypt.txt           |   53 +-
 Documentation/device-mapper/dm-integrity.txt       |  199 ++
 Documentation/device-mapper/dm-raid.txt            |   14 +-
 drivers/md/Kconfig                                 |   19 +-
 drivers/md/Makefile                                |    7 +-
 drivers/md/{dm-bio-prison.c => dm-bio-prison-v1.c} |   46 +-
 drivers/md/{dm-bio-prison.h => dm-bio-prison-v1.h} |    2 +-
 drivers/md/dm-bio-prison-v2.c                      |  369 +++
 drivers/md/dm-bio-prison-v2.h                      |  152 +
 drivers/md/dm-bufio.c                              |   70 +-
 drivers/md/dm-bufio.h                              |    7 +
 drivers/md/dm-cache-background-tracker.c           |  238 ++
 drivers/md/dm-cache-background-tracker.h           |   46 +
 drivers/md/dm-cache-metadata.c                     |    3 -
 drivers/md/dm-cache-metadata.h                     |    2 +
 drivers/md/dm-cache-policy-cleaner.c               |  469 ---
 drivers/md/dm-cache-policy-internal.h              |   76 +-
 drivers/md/dm-cache-policy-smq.c                   |  821 ++---
 drivers/md/dm-cache-policy.h                       |  187 +-
 drivers/md/dm-cache-target.c                       | 2535 +++++++--------
 drivers/md/dm-core.h                               |    2 +-
 drivers/md/dm-crypt.c                              | 1253 ++++++--
 drivers/md/dm-delay.c                              |    1 +
 drivers/md/dm-era-target.c                         |   10 +-
 drivers/md/dm-integrity.c                          | 3238 ++++++++++++++++++++
 drivers/md/dm-ioctl.c                              |   16 +-
 drivers/md/dm-linear.c                             |    1 +
 drivers/md/dm-mpath.c                              |  171 +-
 drivers/md/dm-raid.c                               |  164 +-
 drivers/md/dm-rq.c                                 |    8 +-
 drivers/md/dm-stripe.c                             |    1 +
 drivers/md/dm-table.c                              |   99 +-
 drivers/md/dm-thin-metadata.c                      |    2 -
 drivers/md/dm-thin.c                               |    3 +-
 drivers/md/dm-verity-fec.c                         |    4 +-
 drivers/md/dm-verity-target.c                      |  201 +-
 drivers/md/dm-verity.h                             |   23 +-
 drivers/md/dm.c                                    |   35 +-
 drivers/md/dm.h                                    |    8 +-
 drivers/md/persistent-data/dm-block-manager.c      |    1 -
 drivers/md/persistent-data/dm-block-manager.h      |    2 +-
 drivers/md/persistent-data/dm-btree.c              |    8 +-
 drivers/md/raid5-cache.c                           |   62 +-
 drivers/md/raid5.h                                 |   11 +
 include/linux/device-mapper.h                      |   26 +-
 45 files changed, 7640 insertions(+), 3025 deletions(-)
 create mode 100644 Documentation/device-mapper/dm-integrity.txt
 rename drivers/md/{dm-bio-prison.c => dm-bio-prison-v1.c} (94%)
 rename drivers/md/{dm-bio-prison.h => dm-bio-prison-v1.h} (99%)
 create mode 100644 drivers/md/dm-bio-prison-v2.c
 create mode 100644 drivers/md/dm-bio-prison-v2.h
 create mode 100644 drivers/md/dm-cache-background-tracker.c
 create mode 100644 drivers/md/dm-cache-background-tracker.h
 delete mode 100644 drivers/md/dm-cache-policy-cleaner.c
 create mode 100644 drivers/md/dm-integrity.c
