From: Zdenek Kabelac <zkabelac@redhat.com>
Subject: [PATCH] Add missing del_gendisk to error path
Date: Wed, 23 Sep 2009 14:37:26 +0200
Message-ID: <4ABA1686.1000906@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, Milan Broz <mbroz@redhat.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Add missing del_gendisk() to error path when creation of workqueue fails.
Otherwice there is a resource leak and following warning is shown:

WARNING: at fs/sysfs/dir.c:487 sysfs_add_one+0xc5/0x160()
sysfs: cannot create duplicate filename '/devices/virtual/block/dm-0'

Signed-off-by: Zdenek Kabelac <zkabelac@redhat.com>

---
 drivers/md/dm.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index b4845b1..bf5961d 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1819,6 +1819,7 @@ static struct mapped_device *alloc_dev(int minor)
 bad_bdev:
 	destroy_workqueue(md->wq);
 bad_thread:
+	del_gendisk(md->disk);
 	put_disk(md->disk);
 bad_disk:
 	blk_cleanup_queue(md->queue);
