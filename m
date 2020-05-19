From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH v3 1/6] libmultipath: make libmp_dm_init optional
Date: Tue, 19 May 2020 12:08:40 -0500
Message-ID: <1589908125-7456-2-git-send-email-bmarzins@redhat.com>
References: <1589908125-7456-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1589908125-7456-1-git-send-email-bmarzins@redhat.com>
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

Move dm_initialized out of libmp_dm_task_create(), and add
a function skip_libmp_dm_init() so that users of libmultipath can skip
initializing device-mapper. This is needed for other programs that
use libmultipath (or a library that depends on it) but want to control
how device-mapper is set up.

Also make dm_prereq a global function.

Reviewed-by: Martin Wilck <mwilck@suse.com>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/devmapper.c | 17 +++++++++++++----
 libmultipath/devmapper.h |  3 ++-
 2 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 13a1cf53..7ed494a1 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -33,6 +33,8 @@
 #define MAX_WAIT 5
 #define LOOPS_PER_SEC 5
 
+static pthread_once_t dm_initialized = PTHREAD_ONCE_INIT;
+
 static int dm_conf_verbosity;
 
 #ifdef LIBDM_API_DEFERRED
@@ -229,7 +231,7 @@ dm_tgt_prereq (unsigned int *ver)
 	return 1;
 }
 
-static int dm_prereq(unsigned int *v)
+int dm_prereq(unsigned int *v)
 {
 	if (dm_lib_prereq())
 		return 1;
@@ -243,7 +245,7 @@ void libmp_udev_set_sync_support(int on)
 	libmp_dm_udev_sync = !!on;
 }
 
-void libmp_dm_init(void)
+static void libmp_dm_init(void)
 {
 	struct config *conf;
 	int verbosity;
@@ -262,11 +264,18 @@ void libmp_dm_init(void)
 	dm_udev_set_sync_support(libmp_dm_udev_sync);
 }
 
+static void _do_skip_libmp_dm_init(void)
+{
+}
+
+void skip_libmp_dm_init(void)
+{
+	pthread_once(&dm_initialized, _do_skip_libmp_dm_init);
+}
+
 struct dm_task*
 libmp_dm_task_create(int task)
 {
-	static pthread_once_t dm_initialized = PTHREAD_ONCE_INIT;
-
 	pthread_once(&dm_initialized, libmp_dm_init);
 	return dm_task_create(task);
 }
diff --git a/libmultipath/devmapper.h b/libmultipath/devmapper.h
index 7557a86b..17fc9faf 100644
--- a/libmultipath/devmapper.h
+++ b/libmultipath/devmapper.h
@@ -28,7 +28,8 @@
 #define UUID_PREFIX_LEN (sizeof(UUID_PREFIX) - 1)
 
 void dm_init(int verbosity);
-void libmp_dm_init(void);
+int dm_prereq(unsigned int *v);
+void skip_libmp_dm_init(void);
 void libmp_udev_set_sync_support(int on);
 struct dm_task *libmp_dm_task_create(int task);
 int dm_drv_version (unsigned int * version);
-- 
2.17.2
