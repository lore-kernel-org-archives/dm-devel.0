From: Alasdair G Kergon <agk@redhat.com>
Subject: [2.6.23 PATCH 02/18] dm: bio_list prefetch removal
Date: Wed, 11 Jul 2007 21:57:01 +0100
Message-ID: <20070711205701.GT24114@agk.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>
List-Id: dm-devel.ids

From: Alasdair G Kergon <agk@redhat.com>

Remove dubious prefetch from bio_list_for_each() macro.

Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>

---
 drivers/md/dm-bio-list.h |    4 +---
 1 files changed, 1 insertion(+), 3 deletions(-)

Index: linux/drivers/md/dm-bio-list.h
===================================================================
--- linux.orig/drivers/md/dm-bio-list.h	2007-07-11 21:37:36.000000000 +0100
+++ linux/drivers/md/dm-bio-list.h	2007-07-11 21:37:37.000000000 +0100
@@ -8,7 +8,6 @@
 #define DM_BIO_LIST_H
 
 #include <linux/bio.h>
-#include <linux/prefetch.h>
 
 struct bio_list {
 	struct bio *head;
@@ -31,8 +30,7 @@ static inline void bio_list_init(struct 
 }
 
 #define bio_list_for_each(bio, bl) \
-	for (bio = (bl)->head; bio && ({ prefetch(bio->bi_next); 1; }); \
-	     bio = bio->bi_next)
+	for (bio = (bl)->head; bio; bio = bio->bi_next)
 
 static inline unsigned bio_list_size(const struct bio_list *bl)
 {
