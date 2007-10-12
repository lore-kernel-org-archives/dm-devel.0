From: Alasdair G Kergon <agk@redhat.com>
Subject: [2.6.24 PATCH 14/25] dm: bio_list macro renaming
Date: Fri, 12 Oct 2007 18:19:28 +0100
Message-ID: <20071012171928.GZ24157@agk.fab.redhat.com>
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
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org, Jan Engelhardt <jengelh@linux01.gwdg.de>
List-Id: dm-devel.ids

From: Alasdair G Kergon <agk@redhat.com>

Remove BIO_LIST and DEFINE_BIO_LIST macros that gain us nothing
since contents are initialised to NULL.

Cc: Jan Engelhardt <jengelh@linux01.gwdg.de>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>

---
 drivers/md/dm-bio-list.h |    5 -----
 drivers/md/dm-delay.c    |    2 +-
 2 files changed, 1 insertion(+), 6 deletions(-)

Index: linux-2.6.23/drivers/md/dm-bio-list.h
===================================================================
--- linux-2.6.23.orig/drivers/md/dm-bio-list.h	2007-10-12 12:36:14.000000000 +0100
+++ linux-2.6.23/drivers/md/dm-bio-list.h	2007-10-12 13:18:13.000000000 +0100
@@ -21,11 +21,6 @@ static inline int bio_list_empty(const s
 	return bl->head == NULL;
 }
 
-#define BIO_LIST_INIT { .head = NULL, .tail = NULL }
-
-#define BIO_LIST(bl) \
-	struct bio_list bl = BIO_LIST_INIT
-
 static inline void bio_list_init(struct bio_list *bl)
 {
 	bl->head = bl->tail = NULL;
Index: linux-2.6.23/drivers/md/dm-delay.c
===================================================================
--- linux-2.6.23.orig/drivers/md/dm-delay.c	2007-10-12 13:15:34.000000000 +0100
+++ linux-2.6.23/drivers/md/dm-delay.c	2007-10-12 13:18:13.000000000 +0100
@@ -83,7 +83,7 @@ static struct bio *flush_delayed_bios(st
 	struct dm_delay_info *delayed, *next;
 	unsigned long next_expires = 0;
 	int start_timer = 0;
-	BIO_LIST(flush_bios);
+	struct bio_list flush_bios = { };
 
 	mutex_lock(&delayed_bios_lock);
 	list_for_each_entry_safe(delayed, next, &dc->delayed_bios, list) {
