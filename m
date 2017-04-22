From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v2 for-4.12] block: fix blk_integrity_register to use
 template's interval_exp if not 0
Date: Sat, 22 Apr 2017 17:22:09 -0400
Message-ID: <20170422212209.GA49088@redhat.com>
References: <20170421222815.45663-1-snitzer@redhat.com>
 <yq1o9vpjs9f.fsf@oracle.com>
 <20170422151043.GA22651@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170422151043.GA22651@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: dm-devel@redhat.com, linux-block@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids

When registering an integrity profile: if the template's interval_exp is
not 0 use it, otherwise use the ilog2() of logical block size of the
provided gendisk.

This fixes a long-standing DM linear target bug where it cannot pass
integrity data to the underlying device if its logical block size
conflicts with the underlying device's logical block size.

Cc: stable@vger.kernel.org
Reported-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 block/blk-integrity.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Jens, please feel free to pick this up for 4.12 and I'll just make the
dm-integrity commit Depends-on it once you've staged it.

diff --git a/block/blk-integrity.c b/block/blk-integrity.c
index 9f0ff5b..d6e1b9a 100644
--- a/block/blk-integrity.c
+++ b/block/blk-integrity.c
@@ -412,7 +412,8 @@ void blk_integrity_register(struct gendisk *disk, struct blk_integrity *template
 
 	bi->flags = BLK_INTEGRITY_VERIFY | BLK_INTEGRITY_GENERATE |
 		template->flags;
-	bi->interval_exp = ilog2(queue_logical_block_size(disk->queue));
+	bi->interval_exp = template->interval_exp ? :
+		ilog2(queue_logical_block_size(disk->queue));
 	bi->profile = template->profile ? template->profile : &nop_profile;
 	bi->tuple_size = template->tuple_size;
 	bi->tag_size = template->tag_size;
-- 
2.10.1
