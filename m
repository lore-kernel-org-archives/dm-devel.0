From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm-kcopyd: alloc pages from the main page
	allocator
Date: Wed, 25 May 2011 12:48:00 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1105251247040.21920@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
To: dm-devel@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

dm-kcopyd: alloc pages from the main page allocator.

This patch changes dm-kcopyd so that it allocates pages with page
allocator with __GFP_NOWARN | __GFP_NORETRY flags (so that it can fail
in case of memory pressure). If the allocation fails, dm-kcopyd
allocates pages from its own reserve.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-kcopyd.c |   55 +++++++++++++++++++++++++++++--------------------
 1 file changed, 33 insertions(+), 22 deletions(-)

Index: linux-2.6.39-fast/drivers/md/dm-kcopyd.c
===================================================================
--- linux-2.6.39-fast.orig/drivers/md/dm-kcopyd.c	2011-05-25 17:56:03.000000000 +0200
+++ linux-2.6.39-fast/drivers/md/dm-kcopyd.c	2011-05-25 18:29:11.000000000 +0200
@@ -93,34 +93,45 @@ static void free_pl(struct page_list *pl
 	kfree(pl);
 }
 
+static void kcopyd_put_pages(struct dm_kcopyd_client *kc, struct page_list *pl)
+{
+	do {
+		struct page_list *next = pl->next;
+		if (kc->nr_free_pages < kc->nr_pages) {
+			pl->next = kc->pages;
+			kc->pages = pl;
+			kc->nr_free_pages++;
+		} else {
+			free_pl(pl);
+		}
+		pl = next;
+	} while (pl);
+}
+
 static int kcopyd_get_pages(struct dm_kcopyd_client *kc,
 			    unsigned int nr, struct page_list **pages)
 {
 	struct page_list *pl;
 
-	if (kc->nr_free_pages < nr)
-		return -ENOMEM;
-
-	kc->nr_free_pages -= nr;
-	for (*pages = pl = kc->pages; --nr; pl = pl->next)
-		;
-
-	kc->pages = pl->next;
-	pl->next = NULL;
-
+	*pages = NULL;
+	do {
+		pl = alloc_pl(__GFP_NOWARN | __GFP_NORETRY);
+		if (unlikely(!pl)) {
+			pl = kc->pages;
+			if (unlikely(!pl))
+				goto not_enough_memory;
+			kc->pages = pl->next;
+			kc->nr_free_pages--;
+		}
+		pl->next = *pages;
+		*pages = pl;
+	} while (--nr);
 	return 0;
-}
 
-static void kcopyd_put_pages(struct dm_kcopyd_client *kc, struct page_list *pl)
-{
-	struct page_list *cursor;
-
-	for (cursor = pl; cursor->next; cursor = cursor->next)
-		kc->nr_free_pages++;
-
-	kc->nr_free_pages++;
-	cursor->next = kc->pages;
-	kc->pages = pl;
+not_enough_memory:
+	if (*pages)
+		kcopyd_put_pages(kc, *pages);
+	return -ENOMEM;
 }
 
 /*
@@ -153,8 +164,8 @@ static int client_alloc_pages(struct dm_
 		pl = next;
 	}
 
-	kcopyd_put_pages(kc, pl);
 	kc->nr_pages += nr;
+	kcopyd_put_pages(kc, pl);
 	return 0;
 }
 
