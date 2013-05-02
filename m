From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH 08/16] Avoid race between ueventloop and uevqloop
Date: Thu,  2 May 2013 16:46:29 -0500
Message-ID: <1367531197-8987-9-git-send-email-bmarzins@redhat.com>
References: <1367531197-8987-1-git-send-email-bmarzins@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1367531197-8987-1-git-send-email-bmarzins@redhat.com>
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
Cc: Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

ueventloop sets up uevq_lockp and uev_condp, which uevqloop uses.
If uevqloop accesses these structures before ueventloop has
initialized them, it will not wake up to process uevents. This patch
statically initializes these structures so they will always be
initialized. Also, since calling LIST_HEAD(uevq) initializes it,
there is no reason to call INIT_LIST_HEAD on it later.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/uevent.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/libmultipath/uevent.c b/libmultipath/uevent.c
index bc74d38..0643e14 100644
--- a/libmultipath/uevent.c
+++ b/libmultipath/uevent.c
@@ -53,8 +53,10 @@ typedef int (uev_trigger)(struct uevent *, void * trigger_data);
 
 pthread_t uevq_thr;
 LIST_HEAD(uevq);
-pthread_mutex_t uevq_lock, *uevq_lockp = &uevq_lock;
-pthread_cond_t  uev_cond,  *uev_condp  = &uev_cond;
+pthread_mutex_t uevq_lock = PTHREAD_MUTEX_INITIALIZER;
+pthread_mutex_t *uevq_lockp = &uevq_lock;
+pthread_cond_t uev_cond = PTHREAD_COND_INITIALIZER;
+pthread_cond_t *uev_condp = &uev_cond;
 uev_trigger *my_uev_trigger;
 void * my_trigger_data;
 int servicing_uev;
@@ -409,10 +411,6 @@ int uevent_listen(void)
 	 * thereby not getting to empty the socket's receive buffer queue
 	 * often enough.
 	 */
-	INIT_LIST_HEAD(&uevq);
-
-	pthread_mutex_init(uevq_lockp, NULL);
-	pthread_cond_init(uev_condp, NULL);
 	pthread_cleanup_push(uevq_stop, NULL);
 
 	monitor = udev_monitor_new_from_netlink(conf->udev, "udev");
@@ -525,8 +523,6 @@ out:
 	if (need_failback)
 		err = failback_listen();
 	pthread_cleanup_pop(1);
-	pthread_mutex_destroy(uevq_lockp);
-	pthread_cond_destroy(uev_condp);
 	return err;
 }
 
-- 
1.8.2
