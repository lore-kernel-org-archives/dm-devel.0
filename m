From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 5/9] block: use revalidate_disk_size in
 set_capacity_revalidate_and_notify
Date: Tue,  1 Sep 2020 17:57:44 +0200
Message-ID: <20200901155748.2884-6-hch@lst.de>
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

Only virtio_blk and xen-blkfront set the revalidate argument to true,
and both do not implement the ->revalidate_disk method.  So switch
to the helper that just updates the size instead.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/genhd.c         | 7 +++----
 include/linux/genhd.h | 4 ++--
 2 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index a2c0ec694918e5..431d4081b50ec7 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -50,14 +50,13 @@ static void disk_release_events(struct gendisk *disk);
  * zero and will not be set to zero
  */
 void set_capacity_revalidate_and_notify(struct gendisk *disk, sector_t size,
-					bool revalidate)
+					bool update_bdev)
 {
 	sector_t capacity = get_capacity(disk);
 
 	set_capacity(disk, size);
-
-	if (revalidate)
-		revalidate_disk(disk);
+	if (update_bdev)
+		revalidate_disk_size(disk, true);
 
 	if (capacity != size && capacity != 0 && size != 0) {
 		char *envp[] = { "RESIZE=1", NULL };
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 8e9c9d3a493fae..c340b392452ce6 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -315,8 +315,8 @@ static inline int get_disk_ro(struct gendisk *disk)
 extern void disk_block_events(struct gendisk *disk);
 extern void disk_unblock_events(struct gendisk *disk);
 extern void disk_flush_events(struct gendisk *disk, unsigned int mask);
-extern void set_capacity_revalidate_and_notify(struct gendisk *disk,
-			sector_t size, bool revalidate);
+void set_capacity_revalidate_and_notify(struct gendisk *disk, sector_t size,
+		bool update_bdev);
 extern unsigned int disk_clear_events(struct gendisk *disk, unsigned int mask);
 
 /* drivers/char/random.c */
-- 
2.28.0
