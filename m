From: Tejun Heo <tj@kernel.org>
Subject: [PATCHSET] block: clean up bdev claim/release handling
Date: Mon,  1 Nov 2010 17:15:24 +0100
Message-ID: <1288628129-12811-1-git-send-email-tj__48820.139541249$1288628469$gmane$org@kernel.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: axboe@kernel.dk, hch@infradead.org, linux-kernel@vger.kernel.org, petero2@telia.com, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, jack@suse.cz, akpm@linux-foundatio
List-Id: dm-devel.ids

bdev exclusive access handling is somewhat clumsy.  The primary
interface is bd_claim() and bd_release() but there also are
open_bdev_exclusive(), close_bdev_exclusive() and bd_claim_by_disk()
and bd_release_from_disk().

Gaining exclusive access as a separate step from open itself also has
the inherent problem that the block layer doesn't know whether the
current open attempt is for an exclusive access or not.  The action of
open itself may affect the existing exclusive access but there's no
way to prevent it.

This patchset simplifies the claim/release handling by folding it into
blkdev_get/put() and making others simple wrappers around them.  This
simplifies code and removes strange corner cases like the
non-atomicity of exclusive open described above.

There are five patches in this series.

 0001-mtd-fix-bdev-exclusive-open-bugs-in-block2mtd-add_de.patch
 0002-btrfs-close_bdev_exclusive-should-use-the-same-flags.patch
 0003-block-simplify-holder-symlink-handling.patch
 0004-block-make-blkdev_get-put-handle-exclusive-access.patch
 0005-block-reorganize-claim-release-implementation.patch

0001-0002 are fixes regarding exclusive bdev opens.  0003 simplifies
holder/slave symlink handling.  0004 folds bdev claim/release into
blkdev_get/put().  0005 reorganizes implementation a bit.

Cleaning up claim/release handling enables implementation of in-kernel
disk event polling which be posted soon.  Although this patchset
touches various files including drivers and filesystems, the changes
there are mostly trivial and I think it would be best to route these
through the block tree.

This patchset is on top of 2.6.37-rc1 and available in the following
git tree.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git cleanup-bd_claim

This patchset reduces about 400 lines of code.

Thanks.

 block/ioctl.c                   |    5 
 drivers/block/drbd/drbd_int.h   |    2 
 drivers/block/drbd/drbd_main.c  |    7 
 drivers/block/drbd/drbd_nl.c    |  103 ++-----
 drivers/block/pktcdvd.c         |   22 -
 drivers/char/raw.c              |   14 
 drivers/md/dm-table.c           |   20 -
 drivers/md/md.c                 |   16 -
 drivers/mtd/devices/block2mtd.c |   10 
 drivers/s390/block/dasd_genhd.c |    2 
 fs/block_dev.c                  |  576 +++++++++-------------------------------
 fs/btrfs/volumes.c              |   14 
 fs/ext3/super.c                 |   12 
 fs/ext4/super.c                 |   12 
 fs/gfs2/ops_fstype.c            |    4 
 fs/jfs/jfs_logmgr.c             |   17 -
 fs/logfs/dev_bdev.c             |    4 
 fs/nilfs2/super.c               |    4 
 fs/ocfs2/cluster/heartbeat.c    |    2 
 fs/partitions/check.c           |    2 
 fs/reiserfs/journal.c           |   17 -
 fs/super.c                      |   14 
 fs/xfs/linux-2.6/xfs_super.c    |    2 
 include/linux/fs.h              |   22 -
 kernel/power/swap.c             |    5 
 mm/swapfile.c                   |    7 
 26 files changed, 260 insertions(+), 655 deletions(-)

--
tejun
