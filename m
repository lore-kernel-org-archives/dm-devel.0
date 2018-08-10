From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm: check the sector size of underlying device
 when verifying start
Date: Fri, 10 Aug 2018 11:23:08 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1808101122300.16981@file01.intranet.prod.int.rdu2.redhat.com>
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
To: Mike Snitzer <msnitzer@redhat.com>, Ondrej Kozina <okozina@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

It was found out that these commands would fail:
# modprobe scsi_debug dev_size_mb=128 sector_size=512
# dmsetup create crypt0 --table "0 245752 crypt cipher_null-ecb - 0 /dev/sda 16385 1 sector_size:4096"
with the error
"device-mapper: table: 253:0: start=16385 not aligned to h/w logical block size 4096 of sda"

The logic incorrectly checks the starting sector offset on the underlying
device against the block size of the device that is being created.

This patch fixes it by checking the starting sector offset against the
block size of the underlying device, not the device that is being created.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org

---
 drivers/md/dm-table.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/drivers/md/dm-table.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-table.c	2018-08-10 15:18:31.410000000 +0200
+++ linux-2.6/drivers/md/dm-table.c	2018-08-10 15:18:31.410000000 +0200
@@ -356,7 +356,7 @@ static int device_area_is_invalid(struct
 	if (logical_block_size_sectors <= 1)
 		return 0;
 
-	if (start & (logical_block_size_sectors - 1)) {
+	if (start & (bdev_logical_block_size(dev->bdev) / 512 - 1)) {
 		DMWARN("%s: start=%llu not aligned to h/w "
 		       "logical block size %u of %s",
 		       dm_device_name(ti->table->md),
