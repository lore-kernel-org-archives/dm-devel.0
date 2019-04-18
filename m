From: Peng Wang <rocking@whu.edu.cn>
Subject: [PATCH] dm: initialize md->dax_dev only with CONFIG_DAX_DRIVER enabled
Date: Thu, 18 Apr 2019 21:59:19 +0800
Message-ID: <20190418135919.10754-1-rocking@whu.edu.cn>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com
Cc: linux-kernel@vger.kernel.org, Peng Wang <rocking@whu.edu.cn>
List-Id: dm-devel.ids

md->dax_dev is NULL default and there is no need to process it
without CONFIG_DAX_DRIVER configured.

Signed-off-by: Peng Wang <rocking@whu.edu.cn>
---
 drivers/md/dm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 043f0761e4a0..418a51cf194c 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1972,8 +1972,8 @@ static struct mapped_device *alloc_dev(int minor)
 		dax_dev = alloc_dax(md, md->disk->disk_name, &dm_dax_ops);
 		if (!dax_dev)
 			goto bad;
+		md->dax_dev = dax_dev;
 	}
-	md->dax_dev = dax_dev;
 
 	add_disk_no_queue_reg(md->disk);
 	format_dev_t(md->name, MKDEV(_major, minor));
-- 
2.19.1
