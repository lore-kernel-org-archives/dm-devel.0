From: Milan Broz <mbroz@redhat.com>
Subject: [PATCH] dm table: Reject unconfigured device
Date: Tue, 29 Mar 2011 19:19:32 +0200
Message-ID: <1301419172-10489-1-git-send-email-mbroz@redhat.com>
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
To: dm-devel@redhat.com
Cc: Milan Broz <mbroz@redhat.com>, zkabelac@redhat.com
List-Id: dm-devel.ids

Some block devices exist but have request function undefined
(e.g. loop device without backing file).

Because we are allowing  devices with zero size
(offline device in multipath, see commit
2cd54d9bedb79a97f014e86c0da393416b264eb3, there should be
additional check if device is initialised.

This patch adds check that block device has request function
defined, otherwise it rejects mapped area as invalid.

Reproducer is trivial: dm-mirror on unbound loop device
(no backing file on loop devices)

dmsetup create x --table "0 8 mirror core 2 8 sync 2 /dev/loop0 0 /dev/loop1 0"

and mirror resync will immediatelly cause OOps.

BUG: unable to handle kernel NULL pointer dereference at   (null)
 ? generic_make_request+0x2bd/0x590
 ? kmem_cache_alloc+0xad/0x190
 submit_bio+0x53/0xe0
 ? bio_add_page+0x3b/0x50
 dispatch_io+0x1ca/0x210 [dm_mod]
 ? read_callback+0x0/0xd0 [dm_mirror]
 dm_io+0xbb/0x290 [dm_mod]
 do_mirror+0x1e0/0x748 [dm_mirror]

Signed-off-by: Milan Broz <mbroz@redhat.com>
Reported-by: Zdenek Kabelac <zkabelac@redhat.com>
---
 drivers/md/dm-table.c |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 38e4eb1..12caa66 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -361,6 +361,7 @@ static void close_dev(struct dm_dev_internal *d, struct mapped_device *md)
 static int device_area_is_invalid(struct dm_target *ti, struct dm_dev *dev,
 				  sector_t start, sector_t len, void *data)
 {
+	struct request_queue *q;
 	struct queue_limits *limits = data;
 	struct block_device *bdev = dev->bdev;
 	sector_t dev_size =
@@ -369,6 +370,22 @@ static int device_area_is_invalid(struct dm_target *ti, struct dm_dev *dev,
 		limits->logical_block_size >> SECTOR_SHIFT;
 	char b[BDEVNAME_SIZE];
 
+	/*
+	 * Some devices exist but have not yet request function defined
+	 * (e.g. loop with not bounded backing file)
+	 * Do not allow using such devices.
+	 */
+	q = bdev_get_queue(bdev);
+	if (!q || !q->make_request_fn) {
+		DMWARN("%s: %s is not yet initialised: "
+		       "start=%llu, len=%llu, dev_size=%llu",
+		       dm_device_name(ti->table->md), bdevname(bdev, b),
+		       (unsigned long long)start,
+		       (unsigned long long)len,
+		       (unsigned long long)dev_size);
+		return 1;
+	}
+
 	if (!dev_size)
 		return 0;
 
-- 
1.7.4.1
