From: Kent Overstreet <koverstreet@google.com>
Subject: [PATCH v2 18/26] raid1: use bio_copy_data()
Date: Mon, 15 Oct 2012 13:09:21 -0700
Message-ID: <1350331769-14856-48-git-send-email-koverstreet@google.com>
References: <1350331769-14856-1-git-send-email-koverstreet@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1350331769-14856-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com
Cc: Kent Overstreet <koverstreet@google.com>, tj@kernel.org, axboe@kernel.dk, neilb@suse.de
List-Id: dm-devel.ids

This doesn't really delete any code _yet_, but once immutable bvecs are
done we can just delete the rest of the code in that loop.

Signed-off-by: Kent Overstreet <koverstreet@google.com>
CC: Jens Axboe <axboe@kernel.dk>
CC: NeilBrown <neilb@suse.de>
---
 drivers/md/raid1.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index b1072da..6cd1fb2 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1895,10 +1895,9 @@ static int process_checks(struct r1bio *r1_bio)
 			else
 				bi->bv_len = size;
 			size -= PAGE_SIZE;
-			memcpy(page_address(bi->bv_page),
-			       page_address(pbio->bi_io_vec[j].bv_page),
-			       PAGE_SIZE);
 		}
+
+		bio_copy_data(sbio, pbio);
 	}
 	return 0;
 }
-- 
1.7.12
