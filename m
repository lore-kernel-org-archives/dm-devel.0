From: Wei Yongjun <weiyongjun1@huawei.com>
Subject: [PATCH -next] dm: remove unused variable 'md'
Date: Thu, 2 Jul 2020 18:39:28 +0800
Message-ID: <20200702103928.67693-1-weiyongjun1@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Hulk Robot <hulkci@huawei.com>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Christoph Hellwig <hch@lst.de>
Cc: Wei Yongjun <weiyongjun1@huawei.com>, dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

After commit 5a6c35f9af41 ("block: remove direct_make_request"),
'md' is never used and gcc report build warning:

drivers/md/dm.c:1296:24: warning: unused variable 'md' [-Wunused-variable]
 1296 |  struct mapped_device *md = io->md;
      |                        ^~

Removing it to avoid build warning.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 drivers/md/dm.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index a8d83d76fa9f..a02842afe358 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1293,7 +1293,6 @@ static blk_qc_t __map_bio(struct dm_target_io *tio)
 	sector_t sector;
 	struct bio *clone = &tio->clone;
 	struct dm_io *io = tio->io;
-	struct mapped_device *md = io->md;
 	struct dm_target *ti = tio->ti;
 	blk_qc_t ret = BLK_QC_T_NONE;
 
