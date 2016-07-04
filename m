From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 25/26] multipathd: use userspace RCU to access
	configuration
Date: Mon,  4 Jul 2016 09:08:45 +0200
Message-ID: <1467616126-10036-26-git-send-email-hare@suse.de>
References: <1467616126-10036-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1467616126-10036-1-git-send-email-hare@suse.de>
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
Cc: Hannes Reinecke <hare@suse.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

As the configuration is accessed from various threads at
various points in time any configuration change is tricky.
To avoid any race conditions this patch encapsulates any
configuration accesses via RCU, which will avoid any races
during reconfiguration.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 libmultipath/config.h |  2 ++
 libmultipath/waiter.c |  3 +++
 mpathpersist/main.c   |  4 ++++
 multipath/main.c      |  4 ++++
 multipathd/Makefile   |  2 +-
 multipathd/main.c     | 42 +++++++++++++++++++++++++++++++++---------
 6 files changed, 47 insertions(+), 10 deletions(-)

diff --git a/libmultipath/config.h b/libmultipath/config.h
index 8db35dd..a41207a 100644
--- a/libmultipath/config.h
+++ b/libmultipath/config.h
@@ -3,6 +3,7 @@
 
 #include <sys/types.h>
 #include <stdint.h>
+#include <urcu.h>
 
 #define ORIGIN_DEFAULT 0
 #define ORIGIN_CONFIG  1
@@ -96,6 +97,7 @@ struct mpentry {
 };
 
 struct config {
+	struct rcu_head rcu;
 	int verbosity;
 	int pgpolicy_flag;
 	int pgpolicy;
diff --git a/libmultipath/waiter.c b/libmultipath/waiter.c
index 219876b..34c0110 100644
--- a/libmultipath/waiter.c
+++ b/libmultipath/waiter.c
@@ -9,6 +9,7 @@
 #include <sys/mman.h>
 #include <pthread.h>
 #include <signal.h>
+#include <urcu.h>
 
 #include "vector.h"
 #include "memory.h"
@@ -41,6 +42,7 @@ void free_waiter (void *data)
 	if (wp->dmt)
 		dm_task_destroy(wp->dmt);
 
+	rcu_unregister_thread();
 	FREE(wp);
 }
 
@@ -167,6 +169,7 @@ void *waitevent (void *et)
 	waiter = (struct event_thread *)et;
 	pthread_cleanup_push(free_waiter, et);
 
+	rcu_register_thread();
 	while (1) {
 		r = waiteventloop(waiter);
 
diff --git a/mpathpersist/main.c b/mpathpersist/main.c
index e4fb39c..5fb831e 100644
--- a/mpathpersist/main.c
+++ b/mpathpersist/main.c
@@ -53,6 +53,10 @@ void put_multipath_config(struct config *conf)
 	/* Noop for now */
 }
 
+void rcu_register_thread_memb(void) {}
+
+void rcu_unregister_thread_memb(void) {}
+
 int main (int argc, char * argv[])
 {
 	int fd, c, res;
diff --git a/multipath/main.c b/multipath/main.c
index 2ed3003..719d935 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -73,6 +73,10 @@ void put_multipath_config(struct config *conf)
 	/* Noop for now */
 }
 
+void rcu_register_thread_memb(void) {}
+
+void rcu_unregister_thread_memb(void) {}
+
 static int
 filter_pathvec (vector pathvec, char * refwwid)
 {
diff --git a/multipathd/Makefile b/multipathd/Makefile
index 9b0210f..ec977f3 100644
--- a/multipathd/Makefile
+++ b/multipathd/Makefile
@@ -9,7 +9,7 @@ CFLAGS += -I$(multipathdir) -I$(mpathpersistdir) -I$(mpathcmddir)
 ifdef SYSTEMD
 	CFLAGS += -DUSE_SYSTEMD=$(SYSTEMD)
 endif
-LDFLAGS += -lpthread -ldevmapper -lreadline
+LDFLAGS += -lurcu -lpthread -ldevmapper -lreadline
 ifdef SYSTEMD
 	ifeq ($(shell test $(SYSTEMD) -gt 209 && echo 1), 1)
 		LDFLAGS += -lsystemd
diff --git a/multipathd/main.c b/multipathd/main.c
index cae4bf8..77fa2dc 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -17,6 +17,7 @@
 #include <limits.h>
 #include <linux/oom.h>
 #include <libudev.h>
+#include <urcu.h>
 #ifdef USE_SYSTEMD
 #include <systemd/sd-daemon.h>
 #endif
@@ -206,12 +207,13 @@ int set_config_state(enum daemon_status state)
 
 struct config *get_multipath_config(void)
 {
-	return multipath_conf;
+	rcu_read_lock();
+	return rcu_dereference(multipath_conf);
 }
 
 void put_multipath_config(struct config *conf)
 {
-	/* Noop for now */
+	rcu_read_unlock();
 }
 
 static int
@@ -1124,23 +1126,33 @@ out:
 	return r;
 }
 
+static void *rcu_unregister(void *param)
+{
+	rcu_unregister_thread();
+	return NULL;
+}
+
 static void *
 ueventloop (void * ap)
 {
 	struct udev *udev = ap;
 
+	pthread_cleanup_push(rcu_unregister, NULL);
+	rcu_register_thread();
 	if (uevent_listen(udev))
 		condlog(0, "error starting uevent listener");
-
+	pthread_cleanup_pop(1);
 	return NULL;
 }
 
 static void *
 uevqloop (void * ap)
 {
+	pthread_cleanup_push(rcu_unregister, NULL);
+	rcu_register_thread();
 	if (uevent_dispatch(&uev_trigger, ap))
 		condlog(0, "error starting uevent dispatcher");
-
+	pthread_cleanup_pop(1);
 	return NULL;
 }
 static void *
@@ -1150,7 +1162,8 @@ uxlsnrloop (void * ap)
 		condlog(1, "Failed to init uxsock listener");
 		return NULL;
 	}
-
+	pthread_cleanup_push(rcu_unregister, NULL);
+	rcu_register_thread();
 	set_handler_callback(LIST+PATHS, cli_list_paths);
 	set_handler_callback(LIST+PATHS+FMT, cli_list_paths_fmt);
 	set_handler_callback(LIST+PATHS+RAW+FMT, cli_list_paths_raw);
@@ -1200,7 +1213,7 @@ uxlsnrloop (void * ap)
 
 	umask(077);
 	uxsock_listen(&uxsock_trigger, ap);
-
+	pthread_cleanup_pop(1);
 	return NULL;
 }
 
@@ -1713,6 +1726,8 @@ checkerloop (void *ap)
 	struct timeval last_time;
 	struct config *conf;
 
+	pthread_cleanup_push(rcu_unregister, NULL);
+	rcu_register_thread();
 	mlockall(MCL_CURRENT | MCL_FUTURE);
 	vecs = (struct vectors *)ap;
 	condlog(2, "path checkers start up");
@@ -1844,6 +1859,7 @@ checkerloop (void *ap)
 			}
 		}
 	}
+	pthread_cleanup_pop(1);
 	return NULL;
 }
 
@@ -1947,6 +1963,13 @@ need_to_delay_reconfig(struct vectors * vecs)
 	return 0;
 }
 
+void rcu_free_config(struct rcu_head *head)
+{
+	struct config *conf = container_of(head, struct config, rcu);
+
+	free_config(conf);
+}
+
 int
 reconfigure (struct vectors * vecs)
 {
@@ -1979,12 +2002,12 @@ reconfigure (struct vectors * vecs)
 		conf->ignore_new_devs = ignore_new_devs;
 	uxsock_timeout = conf->uxsock_timeout;
 
-	old = multipath_conf;
-	multipath_conf = conf;
+	old = rcu_dereference(multipath_conf);
+	rcu_assign_pointer(multipath_conf, conf);
+	call_rcu(&old->rcu, rcu_free_config);
 
 	configure(vecs, 1);
 
-	free_config(old);
 
 	return 0;
 }
@@ -2177,6 +2200,7 @@ child (void * param)
 
 	mlockall(MCL_CURRENT | MCL_FUTURE);
 	signal_init();
+	rcu_init();
 
 	setup_thread_attr(&misc_attr, 64 * 1024, 1);
 	setup_thread_attr(&uevent_attr, DEFAULT_UEVENT_STACKSIZE * 1024, 1);
-- 
2.6.6
