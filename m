From: Eric Biggers <ebiggers@google.com>
Subject: [PATCH] dm bufio: fix integer overflow when limiting maximum cache size
Date: Wed, 15 Nov 2017 16:38:09 -0800
Message-ID: <20171116003809.28767-1-ebiggers@google.com>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: dm-devel@redhat.com
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>, Sami Tolvanen <samitolvanen@google.com>, Will Drewry <wad@chromium.org>, Michael Halcrow <mhalcrow@google.com>, Eric Biggers <ebiggers@google.com>, stable@vger.kernel.org
List-Id: dm-devel.ids

The default max_cache_size_bytes for dm-bufio is meant to be the lesser
of 25% of the size of the vmalloc area and 2% of the size of lowmem.
However, on 32-bit systems the intermediate result in the expression

    (VMALLOC_END - VMALLOC_START) * DM_BUFIO_VMALLOC_PERCENT / 100

overflows, causing the wrong result to be computed.  For example, on a
32-bit system where the vmalloc area is 520093696 bytes, the result is
1174405 rather than the expected 130023424, which makes the maximum
cache size much too small (far less than 2% of lowmem).  This causes
severe performance problems for dm-verity users on affected systems.

Fix this by using mult_frac() to correctly multiply by a percentage.  Do
this for all places in dm-bufio that multiply by a percentage.  Also
replace (VMALLOC_END - VMALLOC_START) with VMALLOC_TOTAL, which contrary
to the comment is now defined in include/linux/vmalloc.h.

Fixes: 95d402f057f2 ("dm: add bufio")
Cc: <stable@vger.kernel.org> # v3.2+
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 drivers/md/dm-bufio.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index 33bb074d6941..b8ac591aaaa7 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -974,7 +974,8 @@ static void __get_memory_limit(struct dm_bufio_client *c,
 		buffers = c->minimum_buffers;
 
 	*limit_buffers = buffers;
-	*threshold_buffers = buffers * DM_BUFIO_WRITEBACK_PERCENT / 100;
+	*threshold_buffers = mult_frac(buffers,
+				       DM_BUFIO_WRITEBACK_PERCENT, 100);
 }
 
 /*
@@ -1910,19 +1911,15 @@ static int __init dm_bufio_init(void)
 	memset(&dm_bufio_caches, 0, sizeof dm_bufio_caches);
 	memset(&dm_bufio_cache_names, 0, sizeof dm_bufio_cache_names);
 
-	mem = (__u64)((totalram_pages - totalhigh_pages) *
-		      DM_BUFIO_MEMORY_PERCENT / 100) << PAGE_SHIFT;
+	mem = (__u64)mult_frac(totalram_pages - totalhigh_pages,
+			       DM_BUFIO_MEMORY_PERCENT, 100) << PAGE_SHIFT;
 
 	if (mem > ULONG_MAX)
 		mem = ULONG_MAX;
 
 #ifdef CONFIG_MMU
-	/*
-	 * Get the size of vmalloc space the same way as VMALLOC_TOTAL
-	 * in fs/proc/internal.h
-	 */
-	if (mem > (VMALLOC_END - VMALLOC_START) * DM_BUFIO_VMALLOC_PERCENT / 100)
-		mem = (VMALLOC_END - VMALLOC_START) * DM_BUFIO_VMALLOC_PERCENT / 100;
+	if (mem > mult_frac(VMALLOC_TOTAL, DM_BUFIO_VMALLOC_PERCENT, 100))
+		mem = mult_frac(VMALLOC_TOTAL, DM_BUFIO_VMALLOC_PERCENT, 100);
 #endif
 
 	dm_bufio_default_cache_size = mem;
-- 
2.15.0.448.gf294e3d99a-goog
