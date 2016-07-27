From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 2/7] libmultipath: Declare more functions 'static'
Date: Wed, 27 Jul 2016 14:12:44 -0700
Message-ID: <ba11eee9-3643-1a35-8e09-b160c8f05f60@sandisk.com>
References: <bbd91f1e-a995-29d7-03cd-3e779249ec15@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <bbd91f1e-a995-29d7-03cd-3e779249ec15@sandisk.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@gmail.com>
Cc: device-mapper development <dm-devel@redhat.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
---
 libmultipath/waiter.c | 8 ++++----
 libmultipath/waiter.h | 4 ----
 2 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/libmultipath/waiter.c b/libmultipath/waiter.c
index 06995b6..4079b13 100644
--- a/libmultipath/waiter.c
+++ b/libmultipath/waiter.c
@@ -24,7 +24,7 @@
 
 pthread_attr_t waiter_attr;
 
-struct event_thread *alloc_waiter (void)
+static struct event_thread *alloc_waiter (void)
 {
 
 	struct event_thread *wp;
@@ -35,7 +35,7 @@ struct event_thread *alloc_waiter (void)
 	return wp;
 }
 
-void free_waiter (void *data)
+static void free_waiter (void *data)
 {
 	struct event_thread *wp = (struct event_thread *)data;
 
@@ -67,7 +67,7 @@ void stop_waiter_thread (struct multipath *mpp, struct vectors *vecs)
  * returns the reschedule delay
  * negative means *stop*
  */
-int waiteventloop (struct event_thread *waiter)
+static int waiteventloop (struct event_thread *waiter)
 {
 	sigset_t set, oldset;
 	int event_nr;
@@ -159,7 +159,7 @@ int waiteventloop (struct event_thread *waiter)
 	return -1; /* never reach there */
 }
 
-void *waitevent (void *et)
+static void *waitevent (void *et)
 {
 	int r;
 	struct event_thread *waiter;
diff --git a/libmultipath/waiter.h b/libmultipath/waiter.h
index a1f57fb..0cfae46 100644
--- a/libmultipath/waiter.h
+++ b/libmultipath/waiter.h
@@ -11,11 +11,7 @@ struct event_thread {
 	struct vectors *vecs;
 };
 
-struct event_thread * alloc_waiter (void);
-void free_waiter (void *data);
 void stop_waiter_thread (struct multipath *mpp, struct vectors *vecs);
 int start_waiter_thread (struct multipath *mpp, struct vectors *vecs);
-int waiteventloop (struct event_thread *waiter);
-void *waitevent (void *et);
 
 #endif /* _WAITER_H */
-- 
2.9.2
