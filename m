From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 1/14] barriers
Date: Mon, 23 Feb 2009 14:19:19 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0902231418580.23293@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Introduce a function that adds a bio to the head of the list.

It will be needed for barriers.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-bio-list.h |   10 ++++++++++
 1 file changed, 10 insertions(+)

Index: linux-2.6.29-rc1-devel/drivers/md/dm-bio-list.h
===================================================================
--- linux-2.6.29-rc1-devel.orig/drivers/md/dm-bio-list.h	2009-01-19 02:03:49.000000000 +0100
+++ linux-2.6.29-rc1-devel/drivers/md/dm-bio-list.h	2009-01-19 02:05:01.000000000 +0100
@@ -52,6 +52,16 @@ static inline void bio_list_add(struct b
 	bl->tail = bio;
 }
 
+static inline void bio_list_add_head(struct bio_list *bl, struct bio *bio)
+{
+	bio->bi_next = bl->head;
+
+	bl->head = bio;
+
+	if (!bl->tail)
+		bl->tail = bio;
+}
+
 static inline void bio_list_merge(struct bio_list *bl, struct bio_list *bl2)
 {
 	if (!bl2->head)
