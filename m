From: mwilck@suse.com
Subject: [PATCH 18/35] libmultipath: uevent: use static linkage
	where possible
Date: Thu,  9 Jul 2020 12:16:03 +0200
Message-ID: <20200709101620.6786-19-mwilck@suse.com>
References: <20200709101620.6786-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200709101620.6786-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

From: Martin Wilck <mwilck@suse.com>

Most of the symbols in uevent.c can be converted to static linkage.
alloc_uevent() and uevent_get_wwid() are called in the unit test
and added to the header file.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/uevent.c | 45 ++++++++++++++++++++-----------------------
 libmultipath/uevent.h |  2 ++
 tests/uevent.c        |  4 ----
 3 files changed, 23 insertions(+), 28 deletions(-)

diff --git a/libmultipath/uevent.c b/libmultipath/uevent.c
index 6a3f8bd..d74389e 100644
--- a/libmultipath/uevent.c
+++ b/libmultipath/uevent.c
@@ -60,14 +60,14 @@
 
 typedef int (uev_trigger)(struct uevent *, void * trigger_data);
 
-LIST_HEAD(uevq);
-pthread_mutex_t uevq_lock = PTHREAD_MUTEX_INITIALIZER;
-pthread_mutex_t *uevq_lockp = &uevq_lock;
-pthread_cond_t uev_cond = PTHREAD_COND_INITIALIZER;
-pthread_cond_t *uev_condp = &uev_cond;
-uev_trigger *my_uev_trigger;
-void * my_trigger_data;
-int servicing_uev;
+static LIST_HEAD(uevq);
+static pthread_mutex_t uevq_lock = PTHREAD_MUTEX_INITIALIZER;
+static pthread_mutex_t *uevq_lockp = &uevq_lock;
+static pthread_cond_t uev_cond = PTHREAD_COND_INITIALIZER;
+static pthread_cond_t *uev_condp = &uev_cond;
+static uev_trigger *my_uev_trigger;
+static void *my_trigger_data;
+static int servicing_uev;
 
 int is_uevent_busy(void)
 {
@@ -91,8 +91,7 @@ struct uevent * alloc_uevent (void)
 	return uev;
 }
 
-void
-uevq_cleanup(struct list_head *tmpq)
+static void uevq_cleanup(struct list_head *tmpq)
 {
 	struct uevent *uev, *tmp;
 
@@ -172,8 +171,7 @@ uevent_get_wwid(struct uevent *uev)
 		uev->wwid = val;
 }
 
-bool
-uevent_need_merge(void)
+static bool uevent_need_merge(void)
 {
 	struct config * conf;
 	bool need_merge = false;
@@ -186,8 +184,7 @@ uevent_need_merge(void)
 	return need_merge;
 }
 
-bool
-uevent_can_discard(struct uevent *uev)
+static bool uevent_can_discard(struct uevent *uev)
 {
 	int invalid = 0;
 	struct config * conf;
@@ -212,7 +209,7 @@ uevent_can_discard(struct uevent *uev)
 	return false;
 }
 
-bool
+static bool
 uevent_can_filter(struct uevent *earlier, struct uevent *later)
 {
 
@@ -246,7 +243,7 @@ uevent_can_filter(struct uevent *earlier, struct uevent *later)
 	return false;
 }
 
-bool
+static bool
 merge_need_stop(struct uevent *earlier, struct uevent *later)
 {
 	/*
@@ -283,7 +280,7 @@ merge_need_stop(struct uevent *earlier, struct uevent *later)
 	return false;
 }
 
-bool
+static bool
 uevent_can_merge(struct uevent *earlier, struct uevent *later)
 {
 	/* merge paths uevents
@@ -302,7 +299,7 @@ uevent_can_merge(struct uevent *earlier, struct uevent *later)
 	return false;
 }
 
-void
+static void
 uevent_prepare(struct list_head *tmpq)
 {
 	struct uevent *uev, *tmp;
@@ -322,7 +319,7 @@ uevent_prepare(struct list_head *tmpq)
 	}
 }
 
-void
+static void
 uevent_filter(struct uevent *later, struct list_head *tmpq)
 {
 	struct uevent *earlier, *tmp;
@@ -345,7 +342,7 @@ uevent_filter(struct uevent *later, struct list_head *tmpq)
 	}
 }
 
-void
+static void
 uevent_merge(struct uevent *later, struct list_head *tmpq)
 {
 	struct uevent *earlier, *tmp;
@@ -366,7 +363,7 @@ uevent_merge(struct uevent *later, struct list_head *tmpq)
 	}
 }
 
-void
+static void
 merge_uevq(struct list_head *tmpq)
 {
 	struct uevent *later;
@@ -379,7 +376,7 @@ merge_uevq(struct list_head *tmpq)
 	}
 }
 
-void
+static void
 service_uevq(struct list_head *tmpq)
 {
 	struct uevent *uev, *tmp;
@@ -450,7 +447,7 @@ int uevent_dispatch(int (*uev_trigger)(struct uevent *, void * trigger_data),
 	return 0;
 }
 
-struct uevent *uevent_from_udev_device(struct udev_device *dev)
+static struct uevent *uevent_from_udev_device(struct udev_device *dev)
 {
 	struct uevent *uev;
 	int i = 0;
@@ -512,7 +509,7 @@ struct uevent *uevent_from_udev_device(struct udev_device *dev)
 	return uev;
 }
 
-bool uevent_burst(struct timeval *start_time, int events)
+static bool uevent_burst(struct timeval *start_time, int events)
 {
 	struct timeval diff_time, end_time;
 	unsigned long speed;
diff --git a/libmultipath/uevent.h b/libmultipath/uevent.h
index 4956bfc..9a5b213 100644
--- a/libmultipath/uevent.h
+++ b/libmultipath/uevent.h
@@ -24,6 +24,7 @@ struct uevent {
 	char *envp[HOTPLUG_NUM_ENVP];
 };
 
+struct uevent *alloc_uevent(void);
 int is_uevent_busy(void);
 
 int uevent_listen(struct udev *udev);
@@ -36,5 +37,6 @@ char *uevent_get_dm_name(const struct uevent *uev);
 char *uevent_get_dm_path(const struct uevent *uev);
 char *uevent_get_dm_action(const struct uevent *uev);
 bool uevent_is_mpath(const struct uevent *uev);
+void uevent_get_wwid(struct uevent *uev);
 
 #endif /* _UEVENT_H */
diff --git a/tests/uevent.c b/tests/uevent.c
index f4afd9b..9ffcd2d 100644
--- a/tests/uevent.c
+++ b/tests/uevent.c
@@ -27,10 +27,6 @@
 
 #include "globals.c"
 
-/* Private prototypes missing in uevent.h */
-struct uevent * alloc_uevent(void);
-void uevent_get_wwid(struct uevent *uev);
-
 /* Stringify helpers */
 #define _str_(x) #x
 #define str(x) _str_(x)
-- 
2.26.2
