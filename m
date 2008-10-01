From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 2/7] block: Fix double put in
	blk_integrity_unregister
Date: Wed,  1 Oct 2008 03:38:38 -0400
Message-ID: <1222846723-18213-3-git-send-email-martin.petersen@oracle.com>
References: <1222846723-18213-1-git-send-email-martin.petersen@oracle.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1222846723-18213-1-git-send-email-martin.petersen@oracle.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: jens.axboe@oracle.com, neilb@suse.de, agk@sourceware.org
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: dm-devel.ids

 - kobject_del already puts the parent.

 - Set integrity profile to NULL to prevent stale data.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 block/blk-integrity.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/block/blk-integrity.c b/block/blk-integrity.c
index 69023da..e3817a0 100644
--- a/block/blk-integrity.c
+++ b/block/blk-integrity.c
@@ -376,7 +376,7 @@ void blk_integrity_unregister(struct gendisk *disk)
 
 	kobject_uevent(&bi->kobj, KOBJ_REMOVE);
 	kobject_del(&bi->kobj);
-	kobject_put(&disk_to_dev(disk)->kobj);
 	kmem_cache_free(integrity_cachep, bi);
+	disk->integrity = NULL;
 }
 EXPORT_SYMBOL(blk_integrity_unregister);
-- 
1.6.0.2
