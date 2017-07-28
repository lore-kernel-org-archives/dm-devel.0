From: Mike Snitzer <snitzer@redhat.com>
Subject: [git pull] device mapper fixes for 4.13-rc3
Date: Fri, 28 Jul 2017 12:04:14 -0400
Message-ID: <20170728160414.GA12967@redhat.com>
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
Cc: Damien Le Moal <damien.lemoal@wdc.com>, Heinz Mauelshagen <heinzm@redhat.com>, NeilBrown <neilb@suse.com>, Vivek Goyal <vgoyal@redhat.com>, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, Alasdair G Kergon <agk@redhat.com>, Dan Carpenter <dan.carpenter@oracle.com>
List-Id: dm-devel.ids

Hi Linus,

The following changes since commit 5771a8c08880cdca3bfb4a3fc6d309d6bba20877:

  Linux v4.13-rc1 (2017-07-15 15:22:10 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-4.13/dm-fixes

for you to fetch changes up to 273752c9ff03eb83856601b2a3458218bb949e46:

  dm, dax: Make sure dm_dax_flush() is called if device supports it (2017-07-26 15:55:44 -0400)

Please pull, thanks.
Mike

----------------------------------------------------------------
- A few DM integrity fixes that improve performance.  One that address
  inefficiencies in the on-disk journal device layout.  Another that
  makes use of the block layer's on-stack plugging when writing the
  journal.

- A dm-bufio fix for the blk_status_t conversion that went in during the
  merge window.

- A few DM raid fixes that address correctness when suspending the
  device and a validation fix for validation that occurs during device
  activation.

- A couple DM zoned target fixes.  Important one being the fix to not
  use GFP_KERNEL in the IO path due to concerns about deadlock in
  low-memory conditions (e.g. swap over a DM zoned device, etc).

- A DM DAX device fix to make sure dm_dax_flush() is called if the
  underlying DAX device is operating as a write cache.

----------------------------------------------------------------
Damien Le Moal (1):
      dm zoned: use GFP_NOIO in I/O path

Dan Carpenter (1):
      dm bufio: fix error code in dm_bufio_write_dirty_buffers()

Heinz Mauelshagen (4):
      dm raid: remove WARN_ON() in raid10_md_layout_to_format()
      dm raid: fix activation check in validate_raid_redundancy()
      dm raid: avoid mddev->suspended access
      dm raid: bump target version

Mikulas Patocka (5):
      dm integrity: fix inefficient allocation of journal space
      dm integrity: use plugging when writing the journal
      dm integrity: WARN_ON if variables representing journal usage get out of sync
      dm integrity: test for corrupted disk format during table load
      dm zoned: remove test for impossible REQ_OP_FLUSH conditions

NeilBrown (1):
      dm verity fec: fix GFP flags used with mempool_alloc()

Vivek Goyal (1):
      dm, dax: Make sure dm_dax_flush() is called if device supports it

 Documentation/device-mapper/dm-raid.txt |  1 +
 drivers/dax/super.c                     |  6 ++++++
 drivers/md/dm-bufio.c                   |  3 +--
 drivers/md/dm-integrity.c               | 22 +++++++++++++++++----
 drivers/md/dm-raid.c                    | 29 +++++++++++++++------------
 drivers/md/dm-table.c                   | 35 +++++++++++++++++++++++++++++++++
 drivers/md/dm-verity-fec.c              | 21 +++++---------------
 drivers/md/dm-zoned-metadata.c          | 12 +++++------
 drivers/md/dm-zoned-reclaim.c           |  2 +-
 drivers/md/dm-zoned-target.c            |  8 ++++----
 include/linux/dax.h                     |  1 +
 11 files changed, 94 insertions(+), 46 deletions(-)
