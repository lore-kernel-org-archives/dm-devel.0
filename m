From: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH 0/7] Fix DM DAX handling
Date: Thu, 24 May 2018 20:55:11 -0600
Message-ID: <20180525025518.11405-1-ross.zwisler@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Toshi Kani <toshi.kani-ZPxbGqLxI0U@public.gmane.org>, Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
List-Id: dm-devel.ids

This series fixes a few issues that I found with DM's handling of DAX
devices.  Here are some of the issues I found:

 * We can create a dm-stripe or dm-linear device which is made up of an
   fsdax PMEM namespace and a raw PMEM namespace but which can hold a
   filesystem mounted with the -o dax mount option.  DAX operations to
   the raw PMEM namespace part lack struct page and can fail in
   interesting/unexpected ways when doing things like fork(), examining
   memory with gdb, etc.

 * We can create a dm-stripe or dm-linear device which is made up of an
   fsdax PMEM namespace and a BRD ramdisk which can hold a filesystem
   mounted with the -o dax mount option.  All I/O to this filesystem
   will fail.

 * In DM you can't transition a dm target which could possibly support
   DAX (mode DM_TYPE_DAX_BIO_BASED) to one which can't support DAX
   (mode DM_TYPE_BIO_BASED), even if you never use DAX.

The first 2 patches in this series are prep work from Darrick and Dave
which improve bdev_dax_supported().  The last 5 problems fix the above
mentioned problems in DM.  I feel that this series simplifies the
handling of DAX devices in DM, and the last 5 DM-related patches have a
net code reduction of 50 lines.


Darrick J. Wong (1):
  fs: allow per-device dax status checking for filesystems

Dave Jiang (1):
  dax: change bdev_dax_supported() to support boolean returns

Ross Zwisler (5):
  dm: fix test for DAX device support
  dm: prevent DAX mounts if not supported
  dm: remove DM_TYPE_DAX_BIO_BASED dm_queue_mode
  dm-snap: remove unnecessary direct_access() stub
  dm-error: remove unnecessary direct_access() stub

 drivers/dax/super.c           | 44 +++++++++++++++++++++----------------------
 drivers/md/dm-ioctl.c         | 16 ++++++----------
 drivers/md/dm-snap.c          |  8 --------
 drivers/md/dm-table.c         | 29 +++++++++++-----------------
 drivers/md/dm-target.c        |  7 -------
 drivers/md/dm.c               |  7 ++-----
 fs/ext2/super.c               |  3 +--
 fs/ext4/super.c               |  3 +--
 fs/xfs/xfs_ioctl.c            |  3 ++-
 fs/xfs/xfs_iops.c             | 30 ++++++++++++++++++++++++-----
 fs/xfs/xfs_super.c            | 10 ++++++++--
 include/linux/dax.h           | 12 ++++--------
 include/linux/device-mapper.h |  8 ++++++--
 13 files changed, 88 insertions(+), 92 deletions(-)

-- 
2.14.3
