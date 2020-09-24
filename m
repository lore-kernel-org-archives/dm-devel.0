From: mwilck@suse.com
Subject: [PATCH v2 17/21] libmultipath: add udev and logsink
	symbols
Date: Thu, 24 Sep 2020 15:37:12 +0200
Message-ID: <20200924133716.14120-18-mwilck@suse.com>
References: <20200924133716.14120-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200924133716.14120-1-mwilck@suse.com>
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

With these symbols added, applications using libmultipath don't
need to define global variables "udev" and "logsink" any more.
This comes at the cost of having to call an init function.
Currently, libmultipath_init() does nothing but initialize
"udev".

The linker's symbol lookup order still allows applications to use
their own "logsink" and "udev" variables, which will take precendence
over libmultipath's internal ones. In this case, calling
libmultipath_init() can be skipped, but like before,
udev should be initialized (using udev_new()) before making any
libmultipath calls.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/config.c             | 46 +++++++++++++++++++++++++++++++
 libmultipath/config.h             | 46 ++++++++++++++++++++++++++++++-
 libmultipath/debug.c              |  2 ++
 libmultipath/libmultipath.version |  8 ++++++
 4 files changed, 101 insertions(+), 1 deletion(-)

diff --git a/libmultipath/config.c b/libmultipath/config.c
index 01b77df..fbb66b3 100644
--- a/libmultipath/config.c
+++ b/libmultipath/config.c
@@ -27,6 +27,52 @@
 #include "mpath_cmd.h"
 #include "propsel.h"
 
+/*
+ * We don't support re-initialization after
+ * libmultipath_exit().
+ */
+static bool libmultipath_exit_called;
+static pthread_once_t _init_once = PTHREAD_ONCE_INIT;
+static pthread_once_t _exit_once = PTHREAD_ONCE_INIT;
+struct udev *udev;
+
+static void _udev_init(void)
+{
+	if (udev)
+		udev_ref(udev);
+	else
+		udev = udev_new();
+	if (!udev)
+		condlog(0, "%s: failed to initialize udev", __func__);
+}
+
+static void _libmultipath_init(void)
+{
+	_udev_init();
+}
+
+static bool _is_libmultipath_initialized(void)
+{
+	return !libmultipath_exit_called && !!udev;
+}
+
+int libmultipath_init(void)
+{
+	pthread_once(&_init_once, _libmultipath_init);
+	return !_is_libmultipath_initialized();
+}
+
+static void _libmultipath_exit(void)
+{
+	libmultipath_exit_called = true;
+	udev_unref(udev);
+}
+
+void libmultipath_exit(void)
+{
+	pthread_once(&_exit_once, _libmultipath_exit);
+}
+
 static struct config __internal_config;
 struct config *libmp_get_multipath_config(void)
 {
diff --git a/libmultipath/config.h b/libmultipath/config.h
index 5997b71..dac4e8f 100644
--- a/libmultipath/config.h
+++ b/libmultipath/config.h
@@ -232,7 +232,51 @@ struct config {
 	char *enable_foreign;
 };
 
-extern struct udev * udev;
+/**
+ * extern variable: udev
+ *
+ * A &struct udev instance used by libmultipath. libmultipath expects
+ * a valid, initialized &struct udev in this variable.
+ * An application can define this variable itself, in which case
+ * the applications's instance will take precedence.
+ * The application can initialize and destroy this variable by
+ * calling libmultipath_init() and libmultipath_exit(), respectively,
+ * whether or not it defines the variable itself.
+ * An application can initialize udev with udev_new() before calling
+ * libmultipath_init(), e.g. if it has to make libudev calls before
+ * libmultipath calls. If an application wants to keep using the
+ * udev variable after calling libmultipath_exit(), it should have taken
+ * an additional reference on it beforehand. This is the case e.g.
+ * after initiazing udev with udev_new().
+ */
+extern struct udev *udev;
+
+/**
+ * libmultipath_init() - library initialization
+ *
+ * This function initializes libmultipath data structures.
+ * It is light-weight; some other initializations, like device-mapper
+ * initialization, are done lazily when the respective functionality
+ * is required.
+ *
+ * Clean up by libmultipath_exit() when the program terminates.
+ * It is an error to call libmultipath_init() after libmultipath_exit().
+ * Return: 0 on success, 1 on failure.
+ */
+int libmultipath_init(void);
+
+/**
+ * libmultipath_exit() - library un-initialization
+ *
+ * This function un-initializes libmultipath data structures.
+ * It is recommended to call this function at program exit.
+ *
+ * Calls to libmultipath_init() after libmultipath_exit() will fail
+ * (in other words, libmultipath can't be re-initialized).
+ * Any other libmultipath calls after libmultipath_exit() may cause
+ * undefined behavior.
+ */
+void libmultipath_exit(void);
 
 int find_hwe (const struct _vector *hwtable,
 	      const char * vendor, const char * product, const char *revision,
diff --git a/libmultipath/debug.c b/libmultipath/debug.c
index 4128cb9..b3a1de9 100644
--- a/libmultipath/debug.c
+++ b/libmultipath/debug.c
@@ -15,6 +15,8 @@
 #include "defaults.h"
 #include "debug.h"
 
+int logsink;
+
 void dlog (int sink, int prio, const char * fmt, ...)
 {
 	va_list ap;
diff --git a/libmultipath/libmultipath.version b/libmultipath/libmultipath.version
index 81bcc9d..2e531ef 100644
--- a/libmultipath/libmultipath.version
+++ b/libmultipath/libmultipath.version
@@ -228,3 +228,11 @@ global:
 	init_config;
 	uninit_config;
 } LIBMULTIPATH_0.8.4.2;
+
+LIBMULTIPATH_0.8.4.4 {
+global:
+	udev;
+	logsink;
+	libmultipath_init;
+	libmultipath_exit;
+} LIBMULTIPATH_0.8.4.3;
-- 
2.28.0
