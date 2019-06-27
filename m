From: Fuqian Huang <huangfq.daxian@gmail.com>
Subject: [PATCH 29/87] md: dm-integrity: replace kmalloc and memset with kzalloc
Date: Fri, 28 Jun 2019 01:38:14 +0800
Message-ID: <20190627173814.3361-1-huangfq.daxian@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
Cc: Fuqian Huang <huangfq.daxian@gmail.com>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

kmalloc + memset(0) -> kzalloc

Signed-off-by: Fuqian Huang <huangfq.daxian@gmail.com>
---
 drivers/md/dm-integrity.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index 44e76cda087a..f5db89b28757 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -3358,7 +3358,7 @@ static int create_journal(struct dm_integrity_c *ic, char **error)
 				goto bad;
 			}
 
-			crypt_iv = kmalloc(ivsize, GFP_KERNEL);
+			crypt_iv = kzalloc(ivsize, GFP_KERNEL);
 			if (!crypt_iv) {
 				*error = "Could not allocate iv";
 				r = -ENOMEM;
@@ -3387,7 +3387,6 @@ static int create_journal(struct dm_integrity_c *ic, char **error)
 				sg_set_buf(&sg[i], va, PAGE_SIZE);
 			}
 			sg_set_buf(&sg[i], &ic->commit_ids, sizeof ic->commit_ids);
-			memset(crypt_iv, 0x00, ivsize);
 
 			skcipher_request_set_crypt(req, sg, sg,
 						   PAGE_SIZE * ic->journal_pages + sizeof ic->commit_ids, crypt_iv);
-- 
2.11.0
