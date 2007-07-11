From: Alasdair G Kergon <agk@redhat.com>
Subject: [2.6.23 PATCH 01/18] dm: bio_list macro renaming
Date: Wed, 11 Jul 2007 21:56:35 +0100
Message-ID: <20070711205635.GS24114@agk.fab.redhat.com>
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
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org, Jan Engelhardt <jengelh@linux01.gwdg.de>
List-Id: dm-devel.ids

From: Alasdair G Kergon <agk@redhat.com>

Rename BIO_LIST() macro to DEFINE_BIO_LIST(), named similarly to
DEFINE_SPINLOCK().

Cc: Jan Engelhardt <jengelh@linux01.gwdg.de>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>

---
 drivers/md/dm-bio-list.h |    2 +-
 drivers/md/dm-delay.c    |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

Index: linux/drivers/md/dm-bio-list.h
===================================================================
--- linux.orig/drivers/md/dm-bio-list.h	2007-07-11 21:37:33.000000000 +0100
+++ linux/drivers/md/dm-bio-list.h	2007-07-11 21:37:36.000000000 +0100
@@ -22,7 +22,7 @@ static inline int bio_list_empty(const s
 
 #define BIO_LIST_INIT { .head = NULL, .tail = NULL }
 
-#define BIO_LIST(bl) \
+#define DEFINE_BIO_LIST(bl) \
 	struct bio_list bl = BIO_LIST_INIT
 
 static inline void bio_list_init(struct bio_list *bl)
Index: linux/drivers/md/dm-delay.c
===================================================================
--- linux.orig/drivers/md/dm-delay.c	2007-07-11 21:37:33.000000000 +0100
+++ linux/drivers/md/dm-delay.c	2007-07-11 21:37:36.000000000 +0100
@@ -83,7 +83,7 @@ static struct bio *flush_delayed_bios(st
 	struct delay_info *delayed, *next;
 	unsigned long next_expires = 0;
 	int start_timer = 0;
-	BIO_LIST(flush_bios);
+	DEFINE_BIO_LIST(flush_bios);
 
 	mutex_lock(&delayed_bios_lock);
 	list_for_each_entry_safe(delayed, next, &dc->delayed_bios, list) {
