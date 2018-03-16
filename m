From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 1/3] multipathd: fix waiter thread cancelling
Date: Fri, 16 Mar 2018 16:31:05 -0500
Message-ID: <1521235867-29476-2-git-send-email-bmarzins@redhat.com>
References: <1521235867-29476-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1521235867-29476-1-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

multipathd was sending a signal to the per-device waiter thread after
cancelling it.  Since these threads are detached, there is a window
where a new thread could have started with the old thread id between the
cancel and the signalling, causing the signal to be delivered to the
wrong thread. Simply reversing the order doesn't fix the issue, since
the waiter threads exit immediately if they receive a signal, again
opening a window for the cancel to be delivered to the wrong thread.

To fix this, multipathd does reverse the order, so that it signals the
thread first (it needs to signal the thread, since the dm_task_run ioctl
isn't a cancellation point) and then cancels it. However it does this
while holding a new mutex.

The waiter thread can only exit without being cancelled for two reasons.
1. When it fails in update_multipath, which removes the device while
   holding the vecs lock.
2. If it receives a SIGUSR2 signal while waiting for a dm event.

Case 1 can never race with another thread removing the device, since
removing a device always happens while holding the vecs lock.  This
means that if the device exists to be removed, then the waiter thread
can't exit this way during the removal.

Case 2 is now solved by grabbing the new mutex after failing
dm_task_run(). With the mutex held, the thread checks if it has been
cancelled. If it wasn't cancelled, the thread continues.

The reason that this uses a new mutex, instead of the vecs lock, is that
using the vecs lock would keep the thread from ending until the vecs
lock was released.  Normally, this isn't a problem. But during
reconfigure, the waiter threads for all devices are stopped, and new
ones started, all while holding the vecs lock.  For systems with a large
number of multipath devices, this will cause multipathd do have double
its already large number of waiter threads during reconfigure, all locked
into memory.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/waiter.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/multipathd/waiter.c b/multipathd/waiter.c
index cb9708b..e894294 100644
--- a/multipathd/waiter.c
+++ b/multipathd/waiter.c
@@ -23,6 +23,7 @@
 #include "waiter.h"
 
 pthread_attr_t waiter_attr;
+struct mutex_lock waiter_lock = { .mutex = PTHREAD_MUTEX_INITIALIZER };
 
 static struct event_thread *alloc_waiter (void)
 {
@@ -59,8 +60,12 @@ void stop_waiter_thread (struct multipath *mpp, struct vectors *vecs)
 		mpp->waiter);
 	thread = mpp->waiter;
 	mpp->waiter = (pthread_t)0;
-	pthread_cancel(thread);
+	pthread_cleanup_push(cleanup_lock, &waiter_lock);
+	lock(&waiter_lock);
+	pthread_testcancel();
 	pthread_kill(thread, SIGUSR2);
+	pthread_cancel(thread);
+	lock_cleanup_pop(&waiter_lock);
 }
 
 /*
@@ -114,8 +119,13 @@ static int waiteventloop (struct event_thread *waiter)
 	dm_task_destroy(waiter->dmt);
 	waiter->dmt = NULL;
 
-	if (!r)	/* wait interrupted by signal */
-		return -1;
+	if (!r)	{ /* wait interrupted by signal. check for cancellation */
+		pthread_cleanup_push(cleanup_lock, &waiter_lock);
+		lock(&waiter_lock);
+		pthread_testcancel();
+		lock_cleanup_pop(&waiter_lock);
+		return 1; /* If we weren't cancelled, just reschedule */
+	}
 
 	waiter->event_nr++;
 
-- 
2.7.4
