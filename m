From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] shrinker: fix a bug when callback returns -1
Date: Mon, 29 Aug 2011 15:36:48 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1108291534140.19003@hs20-bc2-1.build.redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Dave Chinner <dchinner@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>, dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

Hi

This patch fixes a lockup when shrinker callback returns -1.

BTW. shouldn't the value returned by callback be long instead of int? On 
64-bit architectures, there may be more than 2^32 entries allocated.

Mikulas

---

shrinker: fix a bug when callback returns -1

Shrinker callback can return -1 if it is at a risk of deadlock.
However, this is not tested at some places.

If do_shrinker_shrink returns -1 here
"max_pass = do_shrinker_shrink(shrinker, shrink, 0)",
it is converted to an unsigned long integer. This may result in excessive
total_scan value and a lockup due to code looping too much in
"while (total_scan >= batch_size)" cycle.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 mm/vmscan.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

Index: linux-3.1-rc3-fast/mm/vmscan.c
===================================================================
--- linux-3.1-rc3-fast.orig/mm/vmscan.c	2011-08-29 20:34:27.000000000 +0200
+++ linux-3.1-rc3-fast/mm/vmscan.c	2011-08-29 20:37:38.000000000 +0200
@@ -250,6 +250,7 @@ unsigned long shrink_slab(struct shrink_
 		unsigned long long delta;
 		unsigned long total_scan;
 		unsigned long max_pass;
+		int sr;
 		int shrink_ret = 0;
 		long nr;
 		long new_nr;
@@ -266,7 +267,10 @@ unsigned long shrink_slab(struct shrink_
 		} while (cmpxchg(&shrinker->nr, nr, 0) != nr);
 
 		total_scan = nr;
-		max_pass = do_shrinker_shrink(shrinker, shrink, 0);
+		sr = do_shrinker_shrink(shrinker, shrink, 0);
+		if (sr == -1)
+			continue;
+		max_pass = sr;
 		delta = (4 * nr_pages_scanned) / shrinker->seeks;
 		delta *= max_pass;
 		do_div(delta, lru_pages + 1);
@@ -309,6 +313,8 @@ unsigned long shrink_slab(struct shrink_
 			int nr_before;
 
 			nr_before = do_shrinker_shrink(shrinker, shrink, 0);
+			if (nr_before == -1)
+				break;
 			shrink_ret = do_shrinker_shrink(shrinker, shrink,
 							batch_size);
 			if (shrink_ret == -1)
