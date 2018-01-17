From: Wei Yongjun <weiyongjun1@huawei.com>
Subject: [PATCH -next] dm crypt: fix error return code in crypt_ctr()
Date: Wed, 17 Jan 2018 11:24:26 +0000
Message-ID: <1516188266-143804-1-git-send-email-weiyongjun1@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Cc: Wei Yongjun <weiyongjun1@huawei.com>, dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

Fix to return error code -ENOMEM from the mempool_create_kmalloc_pool()
error handling case instead of 0, as done elsewhere in this function.

Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 drivers/md/dm-crypt.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 9fc12f5..45f3acf 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -2740,6 +2740,7 @@ static int crypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 			cc->tag_pool_max_sectors * cc->on_disk_tag_size);
 		if (!cc->tag_pool) {
 			ti->error = "Cannot allocate integrity tags mempool";
+			ret = -ENOMEM;
 			goto bad;
 		}
