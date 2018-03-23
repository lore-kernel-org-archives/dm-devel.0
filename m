From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 1/2] multipathd: register threads that use rcu
	calls
Date: Fri, 23 Mar 2018 15:00:45 -0500
Message-ID: <1521835246-29080-2-git-send-email-bmarzins@redhat.com>
References: <1521835246-29080-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1521835246-29080-1-git-send-email-bmarzins@redhat.com>
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

All calls to condlog() are rcu reader side calls, so any thread that
uses condlog() must register itself. The only threads that are exempt
are log_thread, since it never calls condlog (or any other function that
calls get_multipath_config) and mpath_pr_event_handler_fn, which is only
called by mpath_persist, which disables the rcu handling.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/checkers/rbd.c | 7 +++++--
 libmultipath/checkers/tur.c | 9 ++++++---
 multipathd/main.c           | 7 +++++--
 3 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/libmultipath/checkers/rbd.c b/libmultipath/checkers/rbd.c
index b1d99b4..4ff54f4 100644
--- a/libmultipath/checkers/rbd.c
+++ b/libmultipath/checkers/rbd.c
@@ -19,6 +19,7 @@
 #include <sys/ioctl.h>
 #include <sys/time.h>
 #include <sys/wait.h>
+#include <urcu.h>
 
 #include "rados/librados.h"
 
@@ -517,6 +518,7 @@ static void cleanup_func(void *data)
 	pthread_spin_unlock(&ct->hldr_lock);
 	if (!holders)
 		cleanup_context(ct);
+	rcu_unregister_thread();
 }
 
 static void *rbd_thread(void *ctx)
@@ -524,11 +526,12 @@ static void *rbd_thread(void *ctx)
 	struct rbd_checker_context *ct = ctx;
 	int state;
 
+	/* This thread can be canceled, so setup clean up */
+	rbd_thread_cleanup_push(ct)
+	rcu_register_thread();
 	condlog(3, "rbd%d: thread starting up", ct->rbd_bus_id);
 
 	ct->message[0] = '\0';
-	/* This thread can be canceled, so setup clean up */
-	rbd_thread_cleanup_push(ct)
 
 	/* checker start up */
 	pthread_mutex_lock(&ct->lock);
diff --git a/libmultipath/checkers/tur.c b/libmultipath/checkers/tur.c
index 9155960..eb3348d 100644
--- a/libmultipath/checkers/tur.c
+++ b/libmultipath/checkers/tur.c
@@ -15,6 +15,7 @@
 #include <errno.h>
 #include <sys/time.h>
 #include <pthread.h>
+#include <urcu.h>
 #include <urcu/uatomic.h>
 
 #include "checkers.h"
@@ -220,6 +221,7 @@ static void cleanup_func(void *data)
 	holders = uatomic_sub_return(&ct->holders, 1);
 	if (!holders)
 		cleanup_context(ct);
+	rcu_unregister_thread();
 }
 
 static void copy_msg_to_tcc(void *ct_p, const char *msg)
@@ -237,11 +239,12 @@ static void *tur_thread(void *ctx)
 	int state, running;
 	char devt[32];
 
-	condlog(3, "%s: tur checker starting up",
-		tur_devt(devt, sizeof(devt), ct));
-
 	/* This thread can be canceled, so setup clean up */
 	tur_thread_cleanup_push(ct);
+	rcu_register_thread();
+
+	condlog(3, "%s: tur checker starting up",
+		tur_devt(devt, sizeof(devt), ct));
 
 	/* TUR checker start up */
 	pthread_mutex_lock(&ct->lock);
diff --git a/multipathd/main.c b/multipathd/main.c
index 3ae0442..eccb046 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -3041,12 +3041,13 @@ void *  mpath_pr_event_handler_fn (void * pathp )
 	struct prout_param_descriptor *param;
 	struct prin_resp *resp;
 
+	rcu_register_thread();
 	mpp = pp->mpp;
 
 	resp = mpath_alloc_prin_response(MPATH_PRIN_RKEY_SA);
 	if (!resp){
 		condlog(0,"%s Alloc failed for prin response", pp->dev);
-		return NULL;
+		goto out;
 	}
 
 	ret = prin_do_scsi_ioctl(pp->dev, MPATH_PRIN_RKEY_SA, resp, 0);
@@ -3104,7 +3105,9 @@ void *  mpath_pr_event_handler_fn (void * pathp )
 
 	free(param);
 out:
-	free(resp);
+	if (resp)
+		free(resp);
+	rcu_unregister_thread();
 	return NULL;
 }
 
-- 
2.7.4
