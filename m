From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 11/14] mm: use SWP_SYNCHRONOUS_IO more intelligently
Date: Mon, 20 Jul 2020 09:51:45 +0200
Message-ID: <20200720075148.172156-12-hch@lst.de>
References: <20200720075148.172156-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20200720075148.172156-1-hch@lst.de>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Song Liu <song@kernel.org>, Hans de Goede <hdegoede@redhat.com>, Richard Weinberger <richard@nod.at>, linux-mtd@lists.infradead.org, dm-devel@redhat.com, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, drbd-dev@lists.linbit.com, linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org
List-Id: dm-devel.ids

There is no point in trying to call bdev_read_page if SWP_SYNCHRONOUS_IO
is not set, as the device won't support it.  Also there is no point in
trying a bio submission if bdev_read_page failed.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 mm/page_io.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/mm/page_io.c b/mm/page_io.c
index ccda7679008851..63b44b8221af0f 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -403,8 +403,11 @@ int swap_readpage(struct page *page, bool synchronous)
 		goto out;
 	}
 
-	ret = bdev_read_page(sis->bdev, swap_page_sector(page), page);
-	if (!ret) {
+	if (sis->flags & SWP_SYNCHRONOUS_IO) {
+		ret = bdev_read_page(sis->bdev, swap_page_sector(page), page);
+		if (ret)
+			goto out;
+
 		if (trylock_page(page)) {
 			swap_slot_free_notify(page);
 			unlock_page(page);
-- 
2.27.0
