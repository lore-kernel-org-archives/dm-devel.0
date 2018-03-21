From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] Fix slab name "biovec-(1<<(21-12))"
Date: Wed, 21 Mar 2018 12:49:29 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1803211248020.26409@file01.intranet.prod.int.rdu2.redhat.com>
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
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

I'm getting a slab named "biovec-(1<<(21-12))". It is caused by unintended
expansion of the macro BIO_MAX_PAGES. This patch renames it to biovec-max.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org	# v4.14+

---
 block/bio.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6/block/bio.c
===================================================================
--- linux-2.6.orig/block/bio.c	2018-02-14 20:23:35.648255000 +0100
+++ linux-2.6/block/bio.c	2018-03-14 14:51:35.539999000 +0100
@@ -43,9 +43,9 @@
  * break badly! cannot be bigger than what you can fit into an
  * unsigned short
  */
-#define BV(x) { .nr_vecs = x, .name = "biovec-"__stringify(x) }
+#define BV(x, n) { .nr_vecs = x, .name = "biovec-"#n }
 static struct biovec_slab bvec_slabs[BVEC_POOL_NR] __read_mostly = {
-	BV(1), BV(4), BV(16), BV(64), BV(128), BV(BIO_MAX_PAGES),
+	BV(1, 1), BV(4, 4), BV(16, 16), BV(64, 64), BV(128, 128), BV(BIO_MAX_PAGES, max),
 };
 #undef BV
 
