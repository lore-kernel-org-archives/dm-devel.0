From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm-kcopyd: Introduce gfp flags for alloc_pl
Date: Wed, 25 May 2011 12:47:03 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1105251245560.21920@hs20-bc2-1.build.redhat.com>
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

dm-kcopyd: Introduce gfp flags for alloc_pl

It will be used in further patches.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-kcopyd.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

Index: linux-2.6.39-fast/drivers/md/dm-kcopyd.c
===================================================================
--- linux-2.6.39-fast.orig/drivers/md/dm-kcopyd.c	2011-05-24 22:14:45.000000000 +0200
+++ linux-2.6.39-fast/drivers/md/dm-kcopyd.c	2011-05-25 13:19:02.000000000 +0200
@@ -70,15 +70,15 @@ static void wake(struct dm_kcopyd_client
 	queue_work(kc->kcopyd_wq, &kc->kcopyd_work);
 }
 
-static struct page_list *alloc_pl(void)
+static struct page_list *alloc_pl(gfp_t gfp)
 {
 	struct page_list *pl;
 
-	pl = kmalloc(sizeof(*pl), GFP_KERNEL);
+	pl = kmalloc(sizeof(*pl), gfp);
 	if (!pl)
 		return NULL;
 
-	pl->page = alloc_page(GFP_KERNEL);
+	pl->page = alloc_page(gfp);
 	if (!pl->page) {
 		kfree(pl);
 		return NULL;
@@ -143,7 +143,7 @@ static int client_alloc_pages(struct dm_
 	struct page_list *pl = NULL, *next;
 
 	for (i = 0; i < nr; i++) {
-		next = alloc_pl();
+		next = alloc_pl(GFP_KERNEL);
 		if (!next) {
 			if (pl)
 				drop_pages(pl);
