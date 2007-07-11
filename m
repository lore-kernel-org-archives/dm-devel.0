From: Alasdair G Kergon <agk@redhat.com>
Subject: [2.6.23 PATCH 04/18] dm delay: cleanup
Date: Wed, 11 Jul 2007 21:57:54 +0100
Message-ID: <20070711205754.GV24114@agk.fab.redhat.com>
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
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

From: Alasdair G Kergon <agk@redhat.com>

Use setup_timer().
Replace semaphore with mutex.

Signed-off-by: Alasdair G Kergon <agk@redhat.com>

---
 drivers/md/dm-delay.c |   12 +++++-------
 1 files changed, 5 insertions(+), 7 deletions(-)

Index: linux/drivers/md/dm-delay.c
===================================================================
--- linux.orig/drivers/md/dm-delay.c	2007-07-11 21:37:38.000000000 +0100
+++ linux/drivers/md/dm-delay.c	2007-07-11 21:37:39.000000000 +0100
@@ -20,7 +20,7 @@
 
 struct delay_c {
 	struct timer_list delay_timer;
-	struct semaphore timer_lock;
+	struct mutex timer_lock;
 	struct work_struct flush_expired_bios;
 	struct list_head delayed_bios;
 	atomic_t may_delay;
@@ -58,12 +58,12 @@ static void handle_delayed_timer(unsigne
 
 static void queue_timeout(struct delay_c *dc, unsigned long expires)
 {
-	down(&dc->timer_lock);
+	mutex_lock(&dc->timer_lock);
 
 	if (!timer_pending(&dc->delay_timer) || expires < dc->delay_timer.expires)
 		mod_timer(&dc->delay_timer, expires);
 
-	up(&dc->timer_lock);
+	mutex_unlock(&dc->timer_lock);
 }
 
 static void flush_bios(struct bio *bio)
@@ -193,13 +193,11 @@ out:
 		goto bad;
 	}
 
-	init_timer(&dc->delay_timer);
-	dc->delay_timer.function = handle_delayed_timer;
-	dc->delay_timer.data = (unsigned long)dc;
+	setup_timer(&dc->delay_timer, handle_delayed_timer, (unsigned long)dc);
 
 	INIT_WORK(&dc->flush_expired_bios, flush_expired_bios);
 	INIT_LIST_HEAD(&dc->delayed_bios);
-	init_MUTEX(&dc->timer_lock);
+	mutex_init(&dc->timer_lock);
 	atomic_set(&dc->may_delay, 1);
 
 	ti->private = dc;
