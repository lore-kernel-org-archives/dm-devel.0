From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH v2 2/3] libmutipath: don't close fd on
	dm_lib_release
Date: Wed, 25 Mar 2020 23:22:47 -0500
Message-ID: <1585196568-23714-2-git-send-email-bmarzins@redhat.com>
References: <1585196568-23714-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1585196568-23714-1-git-send-email-bmarzins@redhat.com>
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
Cc: device-mapper development <dm-devel@redhat.com>, Martin Wilck <Martin.Wilck@suse.com>
List-Id: dm-devel.ids

If dm_hold_control_open() isn't set, when dm_lib_release() is called, it
will close the control fd. The control fd will get re-opened on the next
dm_task_run() call, but if there is a dm_task_run() call already
in progress in another thread, it can fail. Since many of the
device-mapper callouts happen with the vecs lock held, this wasn't too
noticeable, but there is code that calls dm_task_run() without the
vecs lock held, notably the dmevent waiter code.

Since, as Martin pointed out, dm_hold_control_open() hasn't always
existed in libdevmapper, check if it's supported on compilation,
and update the version requirements if so.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/Makefile    | 4 ++++
 libmultipath/devmapper.c | 7 ++++++-
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/libmultipath/Makefile b/libmultipath/Makefile
index e5651e49..ad690a49 100644
--- a/libmultipath/Makefile
+++ b/libmultipath/Makefile
@@ -36,6 +36,10 @@ ifneq ($(call check_func,dm_task_deferred_remove,/usr/include/libdevmapper.h),0)
 	CFLAGS += -DLIBDM_API_DEFERRED
 endif
 
+ifneq ($(call check_func,dm_hold_control_dev,/usr/include/libdevmapper.h),0)
+	CFLAGS += -DLIBDM_API_HOLD_CONTROL
+endif
+
 OBJS = memory.o parser.o vector.o devmapper.o callout.o \
 	hwtable.o blacklist.o util.o dmparser.o config.o \
 	structs.o discovery.o propsel.o dict.o \
diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index bed8ddc6..13a1cf53 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -108,7 +108,9 @@ dm_lib_prereq (void)
 {
 	char version[64];
 	int v[3];
-#if defined(LIBDM_API_DEFERRED)
+#if defined(LIBDM_API_HOLD_CONTROL)
+	int minv[3] = {1, 2, 111};
+#elif defined(LIBDM_API_DEFERRED)
 	int minv[3] = {1, 2, 89};
 #elif defined(DM_SUBSYSTEM_UDEV_FLAG0)
 	int minv[3] = {1, 2, 82};
@@ -254,6 +256,9 @@ void libmp_dm_init(void)
 	memcpy(conf->version, version, sizeof(version));
 	put_multipath_config(conf);
 	dm_init(verbosity);
+#ifdef LIBDM_API_HOLD_CONTROL
+	dm_hold_control_dev(1);
+#endif
 	dm_udev_set_sync_support(libmp_dm_udev_sync);
 }
 
-- 
2.17.2
