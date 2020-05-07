From: Zhen Lei <thunder.leizhen@huawei.com>
Subject: [PATCH v2 03/10] block: add sectors_to_npage()/npage_to_sectors() helpers
Date: Thu, 7 May 2020 15:50:53 +0800
Message-ID: <20200507075100.1779-4-thunder.leizhen@huawei.com>
References: <20200507075100.1779-1-thunder.leizhen@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20200507075100.1779-1-thunder.leizhen@huawei.com>
Sender: linux-block-owner@vger.kernel.org
To: Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>, Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>, Matthew Wilcox <willy@infradead.org>, Jens Axboe <axboe@kernel.dk>, Coly Li <colyli@suse.de>, Kent Overstreet <kent.overstreet@gmail.com>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, linux-block <linux-block@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>, dm-devel <dm-devel@redhat.com>, Song Liu <song@kernel.org>, linux-raid <linux-raid@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Cc: Zhen Lei <thunder.leizhen@huawei.com>
List-Id: dm-devel.ids

Provide the conversion of "number of sectors"/"sector number" and
"number of pages"/"page number".

Suggested-by: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
---
 include/linux/blkdev.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 934f31fc15cd..5d8daaffc38b 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -910,6 +910,8 @@ static inline struct request_queue *bdev_get_queue(struct block_device *bdev)
 #define SECTOR_SIZE		(1 << SECTOR_SHIFT)
 #endif
 #define PAGE_SECTORS		(PAGE_SIZE / SECTOR_SIZE)
+#define sectors_to_npage(nr)	((nr) / PAGE_SECTORS)
+#define npage_to_sectors(nr)	((nr) * PAGE_SECTORS)
 
 /*
  * blk_rq_pos()			: the current sector
-- 
2.26.0.106.g9fadedd
