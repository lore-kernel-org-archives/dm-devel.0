From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: Re: 2.6.28.2 & dm-snapshot or kcopyd Oops
Date: Fri, 13 Feb 2009 02:31:42 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0902130229040.2110@hs20-bc2-1.build.redhat.com>
References: <200901231836184950432@163.com>,
	<Pine.LNX.4.64.0901231514590.9877@hs20-bc2-1.build.redhat.com>,
	<200901301800149019891@163.com>,
	<Pine.LNX.4.64.0901301533390.5744@hs20-bc2-1.build.redhat.com>,
	<200901311416111648168@163.com>,
	<Pine.LNX.4.64.0902031505180.28433@hs20-bc2-1.build.redhat.com>,
	<200902051113011850587@163.com>,
	<Pine.LNX.4.64.0902051749150.5515@hs20-bc2-1.build.redhat.com>,
	<Pine.LNX.4.64.0902052218040.5380@hs20-bc2-1.build.redhat.com>,
	<200902061924107769776@163.com>,
	<Pine.LNX.4.64.0902061815440.11986@hs20-bc2-1.build.redhat.com>,
	<200902072041046488539@163.com>,
	<Pine.LNX.4.64.0902090311340.28754@hs20-bc2-1.build.redhat.com>,
	<200902101305353713189@163.com>,
	<Pine.LNX.4.64.0902101832050.386@hs20-bc2-1.build.redhat.com>,
	<Pine.LNX.4.64.0902110552550.20020@hs20-bc2-1.build.redhat.com>
	<200902121131140773281@163.com>
	<Pine.LNX.4.64.0902130138400.26381@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0902130138400.26381@hs20-bc2-1.build.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jacky Kim <jcy_2008@163.com>
Cc: device-mapper development <dm-devel@redhat.com>, Alasdair G Kergon <agk@redhat.com>, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

On Fri, 13 Feb 2009, Mikulas Patocka wrote:

> Hi
> 
> Few more questions:
> - do you write to the snapshots?
> - do you create/delete snapshots while the crash happens?
> - do all the snapshots have the same chunk size?
> - how many snapshots do you have?

another question: do you resize the origin device? or the snapshots?

One more test patch. (the code looks so terrible that I am thinking about 
submitting you a patch that erases this logic all and reimplements it).

Mikulas

---
 drivers/md/dm-exception-store.c |    2 +
 drivers/md/dm-snap.c            |   52 ++++++++++++++++++++++++++++++++++------
 2 files changed, 47 insertions(+), 7 deletions(-)

Index: linux-2.6.28-clean/drivers/md/dm-snap.c
===================================================================
--- linux-2.6.28-clean.orig/drivers/md/dm-snap.c	2009-02-13 07:49:49.000000000 +0100
+++ linux-2.6.28-clean/drivers/md/dm-snap.c	2009-02-13 08:26:54.000000000 +0100
@@ -90,6 +90,8 @@ struct dm_snap_pending_exception {
 	int started;
 
 	struct list_head list_all;
+
+	int magic;
 };
 
 /*
@@ -378,10 +380,13 @@ static struct dm_snap_pending_exception 
 
 	atomic_inc(&s->pending_exceptions_count);
 	pe->snap = s;
+	pe->primary_pe = NULL;
+	pe->magic = 0x12345678;
 
 	spin_lock(&pending_spinlock);
 	list_for_each_entry(pe2, &pending_all, list_all) {
 		BUG_ON(pe2 == pe);
+		BUG_ON(pe2->primary_pe == pe);
 	}
 	list_add(&pe->list_all, &pending_all);
 	spin_unlock(&pending_spinlock);
@@ -400,13 +405,21 @@ static void free_pending_exception(struc
 
 	spin_lock(&pending_spinlock);
 	list_for_each_entry(pe2, &pending_all, list_all) {
+		if (pe2->primary_pe == pe && pe2 != pe) {
+			printk(KERN_ALERT "Freeing referenced exception, pe %p, pe->magic %x, pe2 %p, pe2->magic %x, pe2->primary_pe, %p, pe->ref_count %d\n", pe, pe->magic, pe2, pe2->magic, pe2->primary_pe, atomic_read(&pe->ref_count));
+			BUG();
+		}
+	}
+	list_for_each_entry(pe2, &pending_all, list_all) {
 		if (pe2 == pe) goto found;
 	}
+	printk(KERN_ALERT "Freeing free exception pe %p, magic %x, pe->primary_pe %p, pe->ref_count %d\n", pe, pe->magic, pe->primary_pe, atomic_read(&pe->ref_count));
 	BUG();
 	found:
 	list_del(&pe->list_all);
 	spin_unlock(&pending_spinlock);
 
+	pe->magic = 0x90abcdef;
 	mempool_free(pe, s->pending_pool);
 	smp_mb__before_atomic_dec();
 	atomic_dec(&s->pending_exceptions_count);
@@ -862,6 +875,13 @@ static struct bio *put_pending_exception
 
 	primary_pe = pe->primary_pe;
 
+	if (primary_pe) {
+		if (atomic_read(&primary_pe->ref_count) <= 0 || primary_pe->magic != 0x12345678) {
+			printk(KERN_ALERT "Bad ref count, pe %p, pe->magic %x, primary_pe %p, primary_pe->magic %x, primary_pe->ref_count %d\n", pe, pe->magic, pe->primary_pe, primary_pe->magic, atomic_read(&primary_pe->ref_count));
+			BUG();
+		}
+	}
+
 	/*
 	 * If this pe is involved in a write to the origin and
 	 * it is the last sibling to complete then release
@@ -1313,11 +1333,19 @@ static int __origin_write(struct list_he
 			 * Either every pe here has same
 			 * primary_pe or none has one yet.
 			 */
-			if (pe->primary_pe)
+			if (pe->primary_pe) {
 				primary_pe = pe->primary_pe;
-			else {
+				if (atomic_read(&primary_pe->ref_count) <= 0 || primary_pe->magic != 0x12345678) {
+					printk(KERN_ALERT "Bad ref count, pe %p, pe->magic %x, primary_pe %p, primary_pe->magic %x, primary_pe->ref_count %d\n", pe, pe->magic, primary_pe, primary_pe->magic, atomic_read(&primary_pe->ref_count));
+					BUG();
+				}
+			} else {
 				primary_pe = pe;
 				first = 1;
+				if (atomic_read(&primary_pe->ref_count) <= 0 || primary_pe->magic != 0x12345678) {
+					printk(KERN_ALERT "Bad ref count, pe %p, pe->magic %x, primary_pe %p, primary_pe->magic %x, primary_pe->ref_count %d\n", pe, pe->magic, pe->primary_pe, primary_pe->magic, atomic_read(&primary_pe->ref_count));
+					BUG();
+				}
 			}
 
 			bio_list_add(&primary_pe->origin_bios, bio);
@@ -1327,6 +1355,10 @@ static int __origin_write(struct list_he
 
 		if (!pe->primary_pe) {
 			pe->primary_pe = primary_pe;
+			if (atomic_read(&primary_pe->ref_count) <= 0 || primary_pe->magic != 0x12345678) {
+				printk(KERN_ALERT "Bad ref count, pe %p, pe->magic %x, primary_pe %p, primary_pe->magic %x, primary_pe->ref_count %d\n", pe, pe->magic, primary_pe, primary_pe->magic, atomic_read(&primary_pe->ref_count));
+				BUG();
+			}
 			get_pending_exception(primary_pe);
 		}
 
@@ -1350,11 +1382,17 @@ static int __origin_write(struct list_he
 	 * us here to remove the primary_pe and submit any origin_bios.
 	 */
 
-	if (first && atomic_dec_and_test(&primary_pe->ref_count)) {
-		flush_bios(bio_list_get(&primary_pe->origin_bios));
-		free_pending_exception(primary_pe);
-		/* If we got here, pe_queue is necessarily empty. */
-		return r;
+	if (first) {
+		if (atomic_read(&primary_pe->ref_count) <= 0 || primary_pe->magic != 0x12345678) {
+			printk(KERN_ALERT "Bad ref count, primary_pe %p, primary_pe->magic %x, primary_pe->primary_pe %p, primary_pe->ref_count %d\n", primary_pe, primary_pe->magic, primary_pe->primary_pe, atomic_read(&primary_pe->ref_count));
+			BUG();
+		}
+		if (atomic_dec_and_test(&primary_pe->ref_count)) {
+			flush_bios(bio_list_get(&primary_pe->origin_bios));
+			free_pending_exception(primary_pe);
+			/* If we got here, pe_queue is necessarily empty. */
+			return r;
+		}
 	}
 
 	/*
Index: linux-2.6.28-clean/drivers/md/dm-exception-store.c
===================================================================
--- linux-2.6.28-clean.orig/drivers/md/dm-exception-store.c	2009-02-13 08:20:45.000000000 +0100
+++ linux-2.6.28-clean/drivers/md/dm-exception-store.c	2009-02-13 08:20:50.000000000 +0100
@@ -621,6 +621,8 @@ struct dm_snap_pending_exception {
 	int started;
 
 	struct list_head list_all;
+
+	int magic;
 };
 
 static DEFINE_SPINLOCK(callback_spinlock);
