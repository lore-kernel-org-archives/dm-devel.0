From: Christopher Lameter <cl@linux.com>
Subject: [PATCH] SLUB: Do not fallback to mininum order if __GFP_NORETRY is
 set
Date: Wed, 18 Apr 2018 09:45:39 -0500 (CDT)
Message-ID: <alpine.DEB.2.20.1804180944180.1062@nuc-kabylake>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Matthew Wilcox <willy@infradead.org>, Pekka Enberg <penberg@kernel.org>, linux-mm@kvack.org, dm-devel@redhat.com, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

Mikulas Patoka wants to ensure that no fallback to lower order happens. I
think __GFP_NORETRY should work correctly in that case too and not fall
back.



Allocating at a smaller order is a retry operation and should not
be attempted.

If the caller does not want retries then respect that.

GFP_NORETRY allows callers to ensure that only maximum order
allocations are attempted.

Signed-off-by: Christoph Lameter <cl@linux.com>

Index: linux/mm/slub.c
===================================================================
--- linux.orig/mm/slub.c
+++ linux/mm/slub.c
@@ -1598,7 +1598,7 @@ static struct page *allocate_slab(struct
 		alloc_gfp = (alloc_gfp | __GFP_NOMEMALLOC) & ~(__GFP_RECLAIM|__GFP_NOFAIL);

 	page = alloc_slab_page(s, alloc_gfp, node, oo);
-	if (unlikely(!page)) {
+	if (unlikely(!page) && !(flags & __GFP_NORETRY)) {
 		oo = s->min;
 		alloc_gfp = flags;
 		/*
