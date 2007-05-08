From: Alasdair G Kergon <agk@redhat.com>
Subject: [2.6.22 PATCH 22/26] dm: bio list helpers
Date: Tue, 8 May 2007 20:48:45 +0100
Message-ID: <20070508194845.GC24114@agk.fab.redhat.com>
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
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org, Heinz Mauelshagen <hjm@redhat.com>
List-Id: dm-devel.ids

From: Heinz Mauelshagen <hjm@redhat.com>

More bio_list helper functions for new targets (including dm-delay and
dm-loop) to manipulate lists of bios.

Signed-off-by: Heinz Mauelshagen <hjm@redhat.com>
Signed-off-by: Bryn Reeves <breeves@redhat.com>
Signed-off-by: Milan Broz <mbroz@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
---

 drivers/md/dm-bio-list.h |   26 ++++++++++++++++++++++++++
 1 files changed, 26 insertions(+)

Index: linux-2.6.21/drivers/md/dm-bio-list.h
===================================================================
--- linux-2.6.21.orig/drivers/md/dm-bio-list.h	2007-05-01 17:38:31.000000000 +0100
+++ linux-2.6.21/drivers/md/dm-bio-list.h	2007-05-01 17:40:55.000000000 +0100
@@ -8,17 +8,43 @@
 #define DM_BIO_LIST_H
 
 #include <linux/bio.h>
+#include <linux/prefetch.h>
 
 struct bio_list {
 	struct bio *head;
 	struct bio *tail;
 };
 
+static inline int bio_list_empty(const struct bio_list *bl)
+{
+	return bl->head == NULL;
+}
+
+#define BIO_LIST_INIT { .head = NULL, .tail = NULL }
+
+#define BIO_LIST(bl) \
+	struct bio_list bl = BIO_LIST_INIT
+
 static inline void bio_list_init(struct bio_list *bl)
 {
 	bl->head = bl->tail = NULL;
 }
 
+#define bio_list_for_each(bio, bl) \
+	for (bio = (bl)->head; bio && ({ prefetch(bio->bi_next); 1; }); \
+	     bio = bio->bi_next)
+
+static inline unsigned bio_list_size(const struct bio_list *bl)
+{
+	unsigned sz = 0;
+	struct bio *bio;
+
+	bio_list_for_each(bio, bl)
+		sz++;
+
+	return sz;
+}
+
 static inline void bio_list_add(struct bio_list *bl, struct bio *bio)
 {
 	bio->bi_next = NULL;
