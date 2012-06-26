From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 3 of 4] MD:  Move macros from raid1*.h to raid1*.c
Date: Tue, 26 Jun 2012 03:54:02 -0500
Message-ID: <1340700842.19015.22.camel@f16>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, dm-devel@redhat.com
Cc: jbrassow@redhat.com, neilb@suse.de, agk@redhat.com
List-Id: dm-devel.ids

MD RAID1/RAID10: Move some macros from .h file to .c file

There are three macros (IO_BLOCKED,IO_MADE_GOOD,BIO_SPECIAL) which are defined
in both raid1.h and raid10.h.  They are only used in there respective .c files.
However, if we wish to make RAID10 accessible to the device-mapper RAID
target (dm-raid.c), then we need to move these macros into the .c files where
they are used so that they do not conflict with each other.

The macros from the two files are identical and could be moved into md.h, but
I chose to leave the duplication and have them remain in the personality
files.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-upstream/drivers/md/raid1.c
===================================================================
--- linux-upstream.orig/drivers/md/raid1.c
+++ linux-upstream/drivers/md/raid1.c
@@ -46,6 +46,20 @@
  */
 #define	NR_RAID1_BIOS 256
 
+/* when we get a read error on a read-only array, we redirect to another
+ * device without failing the first device, or trying to over-write to
+ * correct the read error.  To keep track of bad blocks on a per-bio
+ * level, we store IO_BLOCKED in the appropriate 'bios' pointer
+ */
+#define IO_BLOCKED ((struct bio *)1)
+/* When we successfully write to a known bad-block, we need to remove the
+ * bad-block marking which must be done from process context.  So we record
+ * the success by setting devs[n].bio to IO_MADE_GOOD
+ */
+#define IO_MADE_GOOD ((struct bio *)2)
+
+#define BIO_SPECIAL(bio) ((unsigned long)bio <= 2)
+
 /* When there are this many requests queue to be written by
  * the raid1 thread, we become 'congested' to provide back-pressure
  * for writeback.
Index: linux-upstream/drivers/md/raid1.h
===================================================================
--- linux-upstream.orig/drivers/md/raid1.h
+++ linux-upstream/drivers/md/raid1.h
@@ -135,20 +135,6 @@ struct r1bio {
 	/* DO NOT PUT ANY NEW FIELDS HERE - bios array is contiguously alloced*/
 };
 
-/* when we get a read error on a read-only array, we redirect to another
- * device without failing the first device, or trying to over-write to
- * correct the read error.  To keep track of bad blocks on a per-bio
- * level, we store IO_BLOCKED in the appropriate 'bios' pointer
- */
-#define IO_BLOCKED ((struct bio *)1)
-/* When we successfully write to a known bad-block, we need to remove the
- * bad-block marking which must be done from process context.  So we record
- * the success by setting bios[n] to IO_MADE_GOOD
- */
-#define IO_MADE_GOOD ((struct bio *)2)
-
-#define BIO_SPECIAL(bio) ((unsigned long)bio <= 2)
-
 /* bits for r1bio.state */
 #define	R1BIO_Uptodate	0
 #define	R1BIO_IsSync	1
Index: linux-upstream/drivers/md/raid10.c
===================================================================
--- linux-upstream.orig/drivers/md/raid10.c
+++ linux-upstream/drivers/md/raid10.c
@@ -60,7 +60,21 @@
  */
 #define	NR_RAID10_BIOS 256
 
-/* When there are this many requests queue to be written by
+/* when we get a read error on a read-only array, we redirect to another
+ * device without failing the first device, or trying to over-write to
+ * correct the read error.  To keep track of bad blocks on a per-bio
+ * level, we store IO_BLOCKED in the appropriate 'bios' pointer
+ */
+#define IO_BLOCKED ((struct bio *)1)
+/* When we successfully write to a known bad-block, we need to remove the
+ * bad-block marking which must be done from process context.  So we record
+ * the success by setting devs[n].bio to IO_MADE_GOOD
+ */
+#define IO_MADE_GOOD ((struct bio *)2)
+
+#define BIO_SPECIAL(bio) ((unsigned long)bio <= 2)
+
+/* When there are this many requests queued to be written by
  * the raid10 thread, we become 'congested' to provide back-pressure
  * for writeback.
  */
Index: linux-upstream/drivers/md/raid10.h
===================================================================
--- linux-upstream.orig/drivers/md/raid10.h
+++ linux-upstream/drivers/md/raid10.h
@@ -123,20 +123,6 @@ struct r10bio {
 	} devs[0];
 };
 
-/* when we get a read error on a read-only array, we redirect to another
- * device without failing the first device, or trying to over-write to
- * correct the read error.  To keep track of bad blocks on a per-bio
- * level, we store IO_BLOCKED in the appropriate 'bios' pointer
- */
-#define IO_BLOCKED ((struct bio*)1)
-/* When we successfully write to a known bad-block, we need to remove the
- * bad-block marking which must be done from process context.  So we record
- * the success by setting devs[n].bio to IO_MADE_GOOD
- */
-#define IO_MADE_GOOD ((struct bio *)2)
-
-#define BIO_SPECIAL(bio) ((unsigned long)bio <= 2)
-
 /* bits for r10bio.state */
 enum r10bio_state {
 	R10BIO_Uptodate,


