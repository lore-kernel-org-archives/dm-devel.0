From: Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH v1 12/54] dm: limit the max bio size as BIO_MAX_PAGES * PAGE_SIZE
Date: Tue, 27 Dec 2016 23:56:01 +0800
Message-ID: <1482854250-13481-13-git-send-email-tom.leiming@gmail.com>
References: <1482854250-13481-1-git-send-email-tom.leiming@gmail.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1482854250-13481-1-git-send-email-tom.leiming@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>, linux-kernel@vger.kernel.org
Cc: linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Ming Lei <tom.leiming@gmail.com>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, "maintainer:DEVICE-MAPPER LVM" <dm-devel@redhat.com>, Shaohua Li <shli@kernel.org>, "open list:SOFTWARE RAID Multiple Disks
        SUPPORT" <linux-raid@vger.kernel.org>
List-Id: dm-devel.ids

For BIO based DM, some targets aren't ready for dealing with
bigger incoming bio than 1Mbyte, such as crypt target.

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 drivers/md/dm.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 3086da5664f3..6139bf7623f7 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -899,7 +899,16 @@ int dm_set_target_max_io_len(struct dm_target *ti, sector_t len)
 		return -EINVAL;
 	}
 
-	ti->max_io_len = (uint32_t) len;
+	/*
+	 * BIO based queue uses its own splitting. When multipage bvecs
+	 * is switched on, size of the incoming bio may be too big to
+	 * be handled in some targets, such as crypt.
+	 *
+	 * When these targets are ready for the big bio, we can remove
+	 * the limit.
+	 */
+	ti->max_io_len = min_t(uint32_t, len,
+			       (BIO_MAX_PAGES * PAGE_SIZE));
 
 	return 0;
 }
-- 
2.7.4

