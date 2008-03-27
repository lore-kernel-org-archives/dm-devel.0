From: Alasdair G Kergon <agk@redhat.com>
Subject: [2.6.25-rc8] dm io: write error bits form long not int
Date: Thu, 27 Mar 2008 18:57:55 +0000
Message-ID: <20080327185755.GL24157@agk.fab.redhat.com>
References: <20080327185315.GA26288@agk.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20080327185315.GA26288@agk.fab.redhat.com>
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
Cc: dm-devel@redhat.com, Heiko Carstens <heiko.carstens@de.ibm.com>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

From: Alasdair G Kergon <agk@redhat.com>

write_err is an unsigned long used with set_bit() so should not
be passed around as unsigned int.

http://bugzilla.kernel.org/show_bug.cgi?id=10271

Signed-off-by: Alasdair G Kergon <agk@redhat.com>
---
 drivers/md/dm-io.c    |    2 +-
 drivers/md/dm-raid1.c |    4 ++--
 drivers/md/dm-snap.c  |    2 +-
 drivers/md/kcopyd.c   |   10 +++++-----
 drivers/md/kcopyd.h   |    4 ++--
 5 files changed, 11 insertions(+), 11 deletions(-)

Index: linux-2.6.25-rc7/drivers/md/dm-io.c
===================================================================
--- linux-2.6.25-rc7.orig/drivers/md/dm-io.c	2008-03-27 17:51:22.000000000 +0000
+++ linux-2.6.25-rc7/drivers/md/dm-io.c	2008-03-27 17:51:30.000000000 +0000
@@ -114,7 +114,7 @@ static void dec_count(struct io *io, uns
 			wake_up_process(io->sleeper);
 
 		else {
-			int r = io->error;
+			unsigned long r = io->error;
 			io_notify_fn fn = io->callback;
 			void *context = io->context;
 
Index: linux-2.6.25-rc7/drivers/md/dm-raid1.c
===================================================================
--- linux-2.6.25-rc7.orig/drivers/md/dm-raid1.c	2008-03-27 17:51:22.000000000 +0000
+++ linux-2.6.25-rc7/drivers/md/dm-raid1.c	2008-03-27 17:51:30.000000000 +0000
@@ -753,7 +753,7 @@ out:
  * are in the no-sync state.  We have to recover these by
  * recopying from the default mirror to all the others.
  *---------------------------------------------------------------*/
-static void recovery_complete(int read_err, unsigned int write_err,
+static void recovery_complete(int read_err, unsigned long write_err,
 			      void *context)
 {
 	struct region *reg = (struct region *)context;
@@ -767,7 +767,7 @@ static void recovery_complete(int read_e
 	}
 
 	if (write_err) {
-		DMERR_LIMIT("Write error during recovery (error = 0x%x)",
+		DMERR_LIMIT("Write error during recovery (error = 0x%lx)",
 			    write_err);
 		/*
 		 * Bits correspond to devices (excluding default mirror).
Index: linux-2.6.25-rc7/drivers/md/dm-snap.c
===================================================================
--- linux-2.6.25-rc7.orig/drivers/md/dm-snap.c	2008-03-27 17:51:22.000000000 +0000
+++ linux-2.6.25-rc7/drivers/md/dm-snap.c	2008-03-27 17:51:30.000000000 +0000
@@ -804,7 +804,7 @@ static void commit_callback(void *contex
  * Called when the copy I/O has finished.  kcopyd actually runs
  * this code so don't block.
  */
-static void copy_callback(int read_err, unsigned int write_err, void *context)
+static void copy_callback(int read_err, unsigned long write_err, void *context)
 {
 	struct dm_snap_pending_exception *pe = context;
 	struct dm_snapshot *s = pe->snap;
Index: linux-2.6.25-rc7/drivers/md/kcopyd.c
===================================================================
--- linux-2.6.25-rc7.orig/drivers/md/kcopyd.c	2008-03-27 17:51:22.000000000 +0000
+++ linux-2.6.25-rc7/drivers/md/kcopyd.c	2008-03-27 17:51:30.000000000 +0000
@@ -169,7 +169,7 @@ struct kcopyd_job {
 	 * Error state of the job.
 	 */
 	int read_err;
-	unsigned int write_err;
+	unsigned long write_err;
 
 	/*
 	 * Either READ or WRITE
@@ -293,7 +293,7 @@ static int run_complete_job(struct kcopy
 {
 	void *context = job->context;
 	int read_err = job->read_err;
-	unsigned int write_err = job->write_err;
+	unsigned long write_err = job->write_err;
 	kcopyd_notify_fn fn = job->fn;
 	struct kcopyd_client *kc = job->kc;
 
@@ -396,7 +396,7 @@ static int process_jobs(struct list_head
 		if (r < 0) {
 			/* error this rogue job */
 			if (job->rw == WRITE)
-				job->write_err = (unsigned int) -1;
+				job->write_err = (unsigned long) -1L;
 			else
 				job->read_err = 1;
 			push(&_complete_jobs, job);
@@ -448,8 +448,8 @@ static void dispatch_job(struct kcopyd_j
 }
 
 #define SUB_JOB_SIZE 128
-static void segment_complete(int read_err,
-			     unsigned int write_err, void *context)
+static void segment_complete(int read_err, unsigned long write_err,
+			     void *context)
 {
 	/* FIXME: tidy this function */
 	sector_t progress = 0;
Index: linux-2.6.25-rc7/drivers/md/kcopyd.h
===================================================================
--- linux-2.6.25-rc7.orig/drivers/md/kcopyd.h	2008-03-27 17:51:22.000000000 +0000
+++ linux-2.6.25-rc7/drivers/md/kcopyd.h	2008-03-27 17:51:30.000000000 +0000
@@ -32,8 +32,8 @@ void kcopyd_client_destroy(struct kcopyd
  * read_err is a boolean,
  * write_err is a bitset, with 1 bit for each destination region
  */
-typedef void (*kcopyd_notify_fn)(int read_err,
-				 unsigned int write_err, void *context);
+typedef void (*kcopyd_notify_fn)(int read_err, unsigned long write_err,
+				 void *context);
 
 int kcopyd_copy(struct kcopyd_client *kc, struct io_region *from,
 		unsigned int num_dests, struct io_region *dests,
