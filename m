From: Mike Snitzer <snitzer@redhat.com>
Subject: [git pull] device mapper changes for 4.10
Date: Wed, 14 Dec 2016 11:20:34 -0500
Message-ID: <20161214162034.GA1847@redhat.com>
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
Cc: Wei Yongjun <weiyj.lk@gmail.com>, Ming Lei <tom.leiming@gmail.com>, "tang.junhui" <tang.junhui@zte.com.cn>, Mike Snitzer <snitzer@redhat.com>, Eric Biggers <ebiggers@google.com>, Heinz Mauelshagen <heinzm@redhat.com>, Douglas Anderson <dianders@chromium.org>, Masanari Iida <standby24x7@gmail.com>, Julia Lawall <Julia.Lawall@lip6.fr>, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, Mikko Rapeli <mikko.rapeli@iki.fi>, Ondrej Kozina <okozina@redhat.com>, Bart Van Assche <bart.vanassche@sandisk.com>, Joe Thornber <ejt@redhat.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Hi Linus,

The following changes since commit a25f0944ba9b1d8a6813fd6f1a86f1bd59ac25a6:

  Linux 4.9-rc5 (2016-11-13 10:32:32 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm tags/dm-4.10-changes

for you to fetch changes up to ef548c551e72dbbdcc6d9ed7c7b3b01083fea8e2:

  dm flakey: introduce "error_writes" feature (2016-12-13 15:01:31 -0500)

Please pull, thanks.
Mike

----------------------------------------------------------------
. various fixes and improvements to request-based DM and DM multipath

. some locking improvements in DM bufio

. add Kconfig option to disable the DM block manager's extra locking
  which mainly serves as a developer tool

. a few bug fixes to DM's persistent-data

. a couple changes to prepare for multipage biovec support in the block
  layer

. various improvements and cleanups in the DM core, DM cache, DM raid
  and DM crypt

. add ability to have DM crypt use keys from the kernel key retention
  service

. add a new "error_writes" feature to the DM flakey target, reads are
  left unchanged in this mode

----------------------------------------------------------------
Bart Van Assche (9):
      dm rq: fix a race condition in rq_completed()
      dm mpath: change return type of pg_init_all_paths() from int to void
      dm mpath: do not modify *__clone if blk_mq_alloc_request() fails
      dm table: an 'all_blk_mq' table must be loaded for a blk-mq DM device
      dm table: simplify dm_table_determine_type()
      dm: use blk_set_queue_dying() in __dm_destroy()
      dm rq: simplify use_blk_mq initialization
      dm ioctl: use offsetof() instead of open-coding it
      dm array: remove a dead assignment in populate_ablock_with_values()

Benjamin Marzinski (3):
      dm space map metadata: fix 'struct sm_metadata' leak on failed create
      dm space map metadata: skip useless memcpy in metadata_ll_init_index()
      dm space map: always set ev if sm_ll_mutate() succeeds

Douglas Anderson (1):
      dm bufio: avoid sleeping while holding the dm_bufio lock

Eric Biggers (1):
      dm verity: fix incorrect error message

Heinz Mauelshagen (4):
      dm raid: correct error messages on old metadata validation
      dm raid: don't allow "write behind" with raid4/5/6
      dm raid: fix discard support regression
      Documentation: dm raid: define data_offset status field

Joe Thornber (1):
      dm block manager: make block locking optional

Julia Lawall (1):
      dm crypt: constify crypt_iv_operations structures

Masanari Iida (1):
      dm raid: fix typos in Documentation/device-mapper/dm-raid.txt

Mike Snitzer (5):
      dm cache metadata: remove an extra newline in DMERR and code
      dm cache: add missing cache device name to DMERR in set_cache_mode()
      dm table: fix 'all_blk_mq' inconsistency when an empty table is loaded
      dm cache policy smq: use hash_32() instead of hash_32_generic()
      dm flakey: introduce "error_writes" feature

Mikko Rapeli (1):
      uapi dm-log-userspace.h: use __u32, __s32, __u64 and __s64 from linux/types.h

Mikulas Patocka (3):
      dm crypt: rename crypt_setkey_allcpus to crypt_setkey
      dm bufio: don't take the lock in dm_bufio_shrink_count
      dm bufio: drop the lock when doing GFP_NOIO allocation

Ming Lei (3):
      dm rq: replace 'bio->bi_vcnt == 1' with !bio_multiple_segments
      dm io: use bvec iterator helpers to implement .get_page and .next_page
      dm crypt: use bio_add_page()

Ondrej Kozina (3):
      dm crypt: mark key as invalid until properly loaded
      dm crypt: add ability to use keys from the kernel key retention service
      dm crypt: reject key strings containing whitespace chars

Wei Yongjun (1):
      dm flakey: return -EINVAL on interval bounds error in flakey_ctr()

tang.junhui (3):
      dm mpath: add m->hw_handler_name NULL pointer check in parse_hw_handler()
      dm mpath: add checks for priority group count to avoid invalid memory access
      dm mpath: use hw_handler_params if attached hw_handler is same as requested

 Documentation/device-mapper/dm-crypt.txt           |  25 ++-
 Documentation/device-mapper/dm-raid.txt            |  12 +-
 drivers/md/Kconfig                                 |  10 +-
 drivers/md/dm-bufio.c                              |  28 +--
 drivers/md/dm-cache-metadata.c                     |   3 +-
 drivers/md/dm-cache-policy-smq.c                   |   2 +-
 drivers/md/dm-cache-target.c                       |   3 +-
 drivers/md/dm-crypt.c                              | 214 +++++++++++++++++----
 drivers/md/dm-flakey.c                             |  53 ++++-
 drivers/md/dm-io.c                                 |  34 +++-
 drivers/md/dm-ioctl.c                              |   2 +-
 drivers/md/dm-mpath.c                              |  42 ++--
 drivers/md/dm-raid.c                               |  82 ++++----
 drivers/md/dm-rq.c                                 |  18 +-
 drivers/md/dm-table.c                              |  43 +++--
 drivers/md/dm-verity-target.c                      |   2 +-
 drivers/md/dm.c                                    |   4 +-
 drivers/md/persistent-data/dm-array.c              |   2 -
 drivers/md/persistent-data/dm-block-manager.c      |  19 +-
 drivers/md/persistent-data/dm-space-map-common.c   |   4 +-
 drivers/md/persistent-data/dm-space-map-metadata.c |  14 +-
 include/uapi/linux/dm-log-userspace.h              |  53 ++---
 22 files changed, 465 insertions(+), 204 deletions(-)
