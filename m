From: Vivek Goyal <vgoyal@redhat.com>
Subject: [RFC PATCH 0/6] dax: Replace bdev_dax_pgoff() with
	dax_pgoff()
Date: Wed, 12 Feb 2020 12:07:27 -0500
Message-ID: <20200212170733.8092-1-vgoyal@redhat.com>
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
To: linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org, dan.j.williams@intel.com, hch@infradead.org
Cc: dm-devel@redhat.com, jack@suse.cz, vgoyal@redhat.com
List-Id: dm-devel.ids

Currently dax code assumes that there is always a block device
associated with it. And block device is passed around in few routines. I
am implementing DAX support for virtiofs and there is no block device
while we are using dax device. So I need dax code to move away from
this assumption that there is always a block device.

We seem to pass around block deivce only to calculate the partition
offset into dax device. bdev_dax_pgoff() does get_start_sect(bdev).

There are two proposed solutions to this problem.

- Get rid of kernel partition support for pmem devices.

- Caller stores offset into dax device and passes that in along with
  dax_device.

First solution was discussed recently in this thread.

https://lore.kernel.org/linux-fsdevel/20200107125159.GA15745@infradead.org/

I feel we already shipped partition support for dax block devices and
going back now will be painful and its easy to break users out there
which are using partitions.

Hence I thought of writing patches for second proposal and see how bad
it looks. To me patches are fairly small and don't break backward 
compatibility and seem like a good step in the direction of removing
dax assumptions about block device.

So I am posting this RFC patch series, which is just boot tested.

Any feedback or comments are welcome.

Thanks
Vivek
 

Vivek Goyal (6):
  dax: Define a helper dax_pgoff() which takes in dax_offset as argument
  dax,iomap,ext4,ext2,xfs: Save dax_offset in "struct iomap"
  fs/dax.c: Start using dax_pgoff() instead of bdev_dax_pgoff()
  dax, dm/md: Use dax_pgoff() instead of bdev_dax_pgoff()
  drivers/dax: Use dax_pgoff() instead of bdev_dax_pgoff()
  dax: Remove bdev_dax_pgoff() helper

 drivers/dax/super.c        | 11 +++++------
 drivers/md/dm-linear.c     |  9 ++++++---
 drivers/md/dm-log-writes.c |  9 ++++++---
 drivers/md/dm-stripe.c     |  8 +++++---
 fs/dax.c                   | 13 ++++++-------
 fs/ext2/inode.c            |  1 +
 fs/ext4/inode.c            |  1 +
 fs/xfs/xfs_iomap.c         |  2 ++
 include/linux/dax.h        |  2 +-
 include/linux/iomap.h      |  1 +
 10 files changed, 34 insertions(+), 23 deletions(-)

-- 
2.20.1
