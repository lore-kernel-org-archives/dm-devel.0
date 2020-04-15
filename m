From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm-writecache: use explicit cache flushing
Date: Wed, 15 Apr 2020 10:50:50 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.2003310811430.18457@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <msnitzer@redhat.com>
Cc: dm-devel@redhat.com, David Teigland <teigland@redhat.com>
List-Id: dm-devel.ids

Flushing each cache line explicity has better performance than using 
non-temporal stores (for transfers larger than 512 bytes).

This patch improves throughput of the dm-writecache driver:

block size      512             1024            2048            4096
movnti          496 MB/s        642 MB/s        725 MB/s        744 MB/s
clflushopt      373 MB/s        688 MB/s        1.1 GB/s        1.2 GB/s

Note that movnti (used by memcpy_flushcache) has better performance in 
multithreaded access, that's why it may be better to make this change in 
the dm-writecache driver rather than changing memcpy_flushcache.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-writecache.c |   18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

Index: linux-2.6/drivers/md/dm-writecache.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-writecache.c
+++ linux-2.6/drivers/md/dm-writecache.c
@@ -1140,7 +1140,16 @@ static void bio_copy_block(struct dm_wri
 			}
 		} else {
 			flush_dcache_page(bio_page(bio));
-			memcpy_flushcache(data, buf, size);
+#if defined(CONFIG_X86)
+			if (static_cpu_has(X86_FEATURE_CLFLUSHOPT) && likely(size > 512) && likely(boot_cpu_data.x86_clflush_size == 64)) {
+				unsigned long i;
+				for (i = 0; i < size; i += 64) {
+					memcpy(data + i, buf + i, 64);
+					clflushopt(data + i);
+				}
+			} else
+#endif
+				memcpy_flushcache(data, buf, size);
 		}
 
 		bvec_kunmap_irq(buf, &flags);
