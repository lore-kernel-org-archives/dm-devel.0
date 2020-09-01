From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/9] block: don't clear bd_invalidated in
 check_disk_size_change
Date: Tue,  1 Sep 2020 17:57:41 +0200
Message-ID: <20200901155748.2884-3-hch@lst.de>
References: <20200901155748.2884-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <20200901155748.2884-1-hch@lst.de>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
 <mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
 <mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Errors-To: virtualization-bounces@lists.linux-foundation.org
Sender: "Virtualization" <virtualization-bounces@lists.linux-foundation.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-raid@vger.kernel.org, linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, Josef Bacik <josef@toxicpanda.com>, linux-block@vger.kernel.org, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>, nbd@other.debian.org, virtualization@lists.linux-foundation.org, ceph-devel@vger.kernel.org
List-Id: dm-devel.ids

bd_invalidated is set by check_disk_change or in add_disk to initiate a
partition scan.  Move it from check_disk_size_change which is called
from both revalidate_disk() and bdev_disk_changed() to only the latter,
as that is what is called from the block device open code (and nbd) to
deal with the bd_invalidated event.  revalidate_disk() on the other hand
is mostly used to propagate a size update from the gendisk to the block
device, which is entirely unrelated.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/block_dev.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index 08158bb2e76c85..2760292045c082 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1302,7 +1302,6 @@ static void check_disk_size_change(struct gendisk *disk,
 		}
 		i_size_write(bdev->bd_inode, disk_size);
 	}
-	bdev->bd_invalidated = 0;
 	spin_unlock(&bdev->bd_size_lock);
 
 	if (bdev_size > disk_size) {
@@ -1391,6 +1390,8 @@ int bdev_disk_changed(struct block_device *bdev, bool invalidate)
 
 	lockdep_assert_held(&bdev->bd_mutex);
 
+	bdev->bd_invalidated = 0;
+
 rescan:
 	ret = blk_drop_partitions(bdev);
 	if (ret)
-- 
2.28.0
