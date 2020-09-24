From: mwilck@suse.com
Subject: [PATCH 14/23] libmultipath: add libmp_dm_exit()
Date: Thu, 24 Sep 2020 15:40:45 +0200
Message-ID: <20200924134054.14632-15-mwilck@suse.com>
References: <20200924134054.14632-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200924134054.14632-1-mwilck@suse.com>
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
Cc: lixiaokeng@huawei.com, dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

From: Martin Wilck <mwilck@suse.com>

This function prepares for calling dm_lib_exit() on program exit.
It undoes changes to libdm internals done by libmultipath.
It doesn't call dm_lib_exit(), as the caller may want to keep
libdm active.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/config.c    |  1 +
 libmultipath/config.h    |  2 ++
 libmultipath/devmapper.c | 10 ++++++++++
 libmultipath/devmapper.h |  1 +
 4 files changed, 14 insertions(+)

diff --git a/libmultipath/config.c b/libmultipath/config.c
index fbb66b3..8097838 100644
--- a/libmultipath/config.c
+++ b/libmultipath/config.c
@@ -65,6 +65,7 @@ int libmultipath_init(void)
 static void _libmultipath_exit(void)
 {
 	libmultipath_exit_called = true;
+	libmp_dm_exit();
 	udev_unref(udev);
 }
 
diff --git a/libmultipath/config.h b/libmultipath/config.h
index dac4e8f..fc614f0 100644
--- a/libmultipath/config.h
+++ b/libmultipath/config.h
@@ -270,6 +270,8 @@ int libmultipath_init(void);
  *
  * This function un-initializes libmultipath data structures.
  * It is recommended to call this function at program exit.
+ * If the application also calls dm_lib_exit(), it should do so
+ * after libmultipath_exit().
  *
  * Calls to libmultipath_init() after libmultipath_exit() will fail
  * (in other words, libmultipath can't be re-initialized).
diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 2e3ae8a..5a2e1e7 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -333,6 +333,16 @@ void libmp_udev_set_sync_support(int on)
 	libmp_dm_udev_sync = !!on;
 }
 
+void libmp_dm_exit(void)
+{
+	/* switch back to default libdm logging */
+	dm_log_init(NULL);
+#ifdef LIBDM_API_HOLD_CONTROL
+	/* make sure control fd is closed in dm_lib_release() */
+	dm_hold_control_dev(0);
+#endif
+}
+
 static void libmp_dm_init(void)
 {
 	struct config *conf;
diff --git a/libmultipath/devmapper.h b/libmultipath/devmapper.h
index 158057e..ecf2e66 100644
--- a/libmultipath/devmapper.h
+++ b/libmultipath/devmapper.h
@@ -35,6 +35,7 @@ enum {
 
 int dm_prereq(unsigned int *v);
 void skip_libmp_dm_init(void);
+void libmp_dm_exit(void);
 void libmp_udev_set_sync_support(int on);
 struct dm_task *libmp_dm_task_create(int task);
 int dm_simplecmd_flush (int, const char *, uint16_t);
-- 
2.28.0
