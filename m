From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 2/2] multipathd: Avoid that a deadlock is
 triggered sporadically during shutdown
Date: Fri, 14 Oct 2016 08:35:47 -0700
Message-ID: <5832949e-aa89-ebf2-11e1-67bbb4d050bf@sandisk.com>
References: <a7920385-9f76-d029-48dd-31ebcb06a212@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <a7920385-9f76-d029-48dd-31ebcb06a212@sandisk.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

pthread_cond_wait() is a thread cancellation point. If a thread that
is waiting in pthread_cond_wait() is canceled it is possible that the
mutex is re-acquired before the first cancellation cleanup handler
is called. In this case the cleanup handler is uevq_stop() and that
function locks uevq_lock. Avoid that calling uevq_stop() results in
a deadlock due to an attempt to lock a non-recursive mutex recursively.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
---
 libmultipath/uevent.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmultipath/uevent.c b/libmultipath/uevent.c
index 6247898..85fd2fb 100644
--- a/libmultipath/uevent.c
+++ b/libmultipath/uevent.c
@@ -52,7 +52,7 @@ typedef int (uev_trigger)(struct uevent *, void * trigger_data);
 
 pthread_t uevq_thr;
 LIST_HEAD(uevq);
-pthread_mutex_t uevq_lock = PTHREAD_MUTEX_INITIALIZER;
+pthread_mutex_t uevq_lock = PTHREAD_RECURSIVE_MUTEX_INITIALIZER_NP;
 pthread_mutex_t *uevq_lockp = &uevq_lock;
 pthread_cond_t uev_cond = PTHREAD_COND_INITIALIZER;
 pthread_cond_t *uev_condp = &uev_cond;
-- 
2.10.0
