From: sultan@kerneltoast.com
Subject: [PATCH] dm crypt: fix memory leak in dm_crypt_integrity_io_alloc() error path
Date: Sat, 16 Feb 2019 13:00:22 -0800
Message-ID: <20190216210022.29483-1-sultan@kerneltoast.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
Cc: Sultan Alsawaf <sultan@kerneltoast.com>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

From: Sultan Alsawaf <sultan@kerneltoast.com>

dm_crypt_integrity_io_alloc() allocates space for an integrity payload but
doesn't free it in the error path, leaking memory. Add a bio_integrity_free()
invocation upon error to fix the memory leak.

Signed-off-by: Sultan Alsawaf <sultan@kerneltoast.com>
---
 drivers/md/dm-crypt.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index dd538e6b2..f731e1fe0 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -939,8 +939,10 @@ static int dm_crypt_integrity_io_alloc(struct dm_crypt_io *io, struct bio *bio)
 
 	ret = bio_integrity_add_page(bio, virt_to_page(io->integrity_metadata),
 				     tag_len, offset_in_page(io->integrity_metadata));
-	if (unlikely(ret != tag_len))
+	if (unlikely(ret != tag_len)) {
+		bio_integrity_free(bio);
 		return -ENOMEM;
+	}
 
 	return 0;
 }
-- 
2.20.1
