From: Mike Snitzer <snitzer@redhat.com>
Subject: [git pull] device mapper changes for 4.15
Date: Mon, 13 Nov 2017 12:28:52 -0500
Message-ID: <20171113172851.GA32332@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
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
Cc: Damien Le Moal <damien.lemoal@wdc.com>, Mike Snitzer <snitzer@redhat.com>, Heinz Mauelshagen <heinzm@redhat.com>, Joe Thornber <ejt@redhat.com>, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, Elena Reshetova <elena.reshetova@intel.com>, Hou Tao <houtao1@huawei.com>, =?iso-8859-1?B?Suly6W15?= Lefaure <jeremy.lefaure@lse.epita.fr>, Ross Zwisler <ross.zwisler@linux.intel.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Hi Linus,

The following changes since commit bb176f67090ca54869fc1262c913aa69d2ede070:

  Linux 4.14-rc6 (2017-10-23 06:49:47 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git =
tags/for-4.15/dm

for you to fetch changes up to ef7afb3656854de04fe03b0b9b4f3722b5722d8d:

  dm cache: lift common migration preparation code to alloc_migration() (20=
17-11-10 15:45:07 -0500)

Please pull, thanks!
Mike

----------------------------------------------------------------
- A few conversions from atomic_t to ref_count_t

- A DM core fix for a race during device destruction that could result
  in a BUG_ON.

- A stable@ fix for a DM cache race condition that could lead to data
  corruption when operating in writeback mode (writethrough is default)

- Various DM cache cleanups and improvements

- Add DAX support to the DM log-writes target

- A fix for the DM zoned target's ability to deal with the last zone of
  the drive being smaller than all others.

- A stable@ DM crypt and DM integrity fix for a negative check that was
  to restrictive (prevented slab debug with XFS ontop of DM crypt from
  working).

- A DM raid target fix for a panic that can occur when forcing a raid to
  sync.

----------------------------------------------------------------
Damien Le Moal (1):
      dm zoned: ignore last smaller runt zone

Elena Reshetova (3):
      dm: convert dm_dev_internal.count from atomic_t to refcount_t
      dm: convert table_device.count from atomic_t to refcount_t
      dm cache: convert dm_cache_metadata.ref_count from atomic_t to refcou=
nt_t

Heinz Mauelshagen (1):
      dm raid: fix panic when attempting to force a raid to sync

Hou Tao (1):
      dm: fix race between dm_get_from_kobject() and __dm_destroy()

Joe Thornber (7):
      dm cache: fix race condition in the writeback mode overwrite_bio opti=
misation
      dm cache policy smq: handle races with queuing background_work
      dm cache policy smq: take origin idle status into account when queuin=
g writebacks
      dm cache background tracker: limit amount of background work that may=
 be issued at once
      dm cache policy smq: change max background work from 10240 to 4096 bl=
ocks
      dm cache policy smq: allocate cache blocks in order
      dm cache: remove usused deferred_cells member from struct cache

J=E9r=E9my Lefaure (1):
      dm space map metadata: use ARRAY_SIZE

Mike Snitzer (6):
      dm cache: pass cache structure to mode functions
      dm cache: submit writethrough writes in parallel to origin and cache
      dm cache: remove all obsolete writethrough-specific code
      dm cache: simplify get_per_bio_data() by removing data_size argument
      dm: small cleanup in dm_get_md()
      dm cache: lift common migration preparation code to alloc_migration()

Mikulas Patocka (3):
      dm: allocate struct mapped_device with kvzalloc
      dm crypt: allow unaligned bv_offset
      dm integrity: allow unaligned bv_offset

Ross Zwisler (2):
      dm log writes: add support for inline data buffers
      dm log writes: add support for DAX

 drivers/md/dm-cache-background-tracker.c           |  18 +-
 drivers/md/dm-cache-metadata.c                     |   9 +-
 drivers/md/dm-cache-policy-smq.c                   |  42 ++-
 drivers/md/dm-cache-target.c                       | 326 +++++++++--------=
----
 drivers/md/dm-core.h                               |   3 +-
 drivers/md/dm-crypt.c                              |   4 +-
 drivers/md/dm-integrity.c                          |   2 +-
 drivers/md/dm-log-writes.c                         | 175 ++++++++++-
 drivers/md/dm-raid.c                               |  21 +-
 drivers/md/dm-table.c                              |   6 +-
 drivers/md/dm-zoned-target.c                       |  13 +-
 drivers/md/dm.c                                    |  45 +--
 drivers/md/dm.h                                    |   3 +-
 drivers/md/persistent-data/dm-space-map-metadata.c |   3 +-
 14 files changed, 408 insertions(+), 262 deletions(-)
