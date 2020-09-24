From: mwilck@suse.com
Subject: [PATCH v2 14/21] libmpathpersist: allow using
	libmultipath {get, put}_multipath_config
Date: Thu, 24 Sep 2020 15:37:09 +0200
Message-ID: <20200924133716.14120-15-mwilck@suse.com>
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

Provide an alternative init function libmpathpersist_init() which
avoids allocating a new struct config, simply using libmultipath's
internal implementation.

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmpathpersist/libmpathpersist.version |  6 ++++
 libmpathpersist/mpath_persist.c         | 42 +++++++++++++++++++++----
 libmpathpersist/mpath_persist.h         | 28 +++++++++++++++++
 3 files changed, 70 insertions(+), 6 deletions(-)

diff --git a/libmpathpersist/libmpathpersist.version b/libmpathpersist/libmpathpersist.version
index 1bb8212..e81e625 100644
--- a/libmpathpersist/libmpathpersist.version
+++ b/libmpathpersist/libmpathpersist.version
@@ -18,3 +18,9 @@ global:
 
 local: *;
 };
+
+LIBMPATHPERSIST_0.8.4.1 {
+global:
+	libmpathpersist_init;
+	libmpathpersist_exit;
+} LIBMPATHPERSIST_0.8.4.0;
diff --git a/libmpathpersist/mpath_persist.c b/libmpathpersist/mpath_persist.c
index 39055ed..a529a38 100644
--- a/libmpathpersist/mpath_persist.c
+++ b/libmpathpersist/mpath_persist.c
@@ -37,6 +37,27 @@
 
 extern struct udev *udev;
 
+static void adapt_config(struct config *conf)
+{
+	conf->force_sync = 1;
+	set_max_fds(conf->max_fds);
+}
+
+int libmpathpersist_init(void)
+{
+	struct config *conf;
+	int rc = 0;
+
+	if (init_config(DEFAULT_CONFIGFILE)) {
+		condlog(0, "Failed to initialize multipath config.");
+		return 1;
+	}
+	conf = libmp_get_multipath_config();
+	adapt_config(conf);
+	libmp_put_multipath_config(conf);
+	return rc;
+}
+
 struct config *
 mpath_lib_init (void)
 {
@@ -47,20 +68,29 @@ mpath_lib_init (void)
 		condlog(0, "Failed to initialize multipath config.");
 		return NULL;
 	}
-	conf->force_sync = 1;
-	set_max_fds(conf->max_fds);
-
+	adapt_config(conf);
 	return conf;
 }
 
-int
-mpath_lib_exit (struct config *conf)
+static void libmpathpersist_cleanup(void)
 {
 	dm_lib_exit();
 	cleanup_prio();
 	cleanup_checkers();
+}
+
+int
+mpath_lib_exit (struct config *conf)
+{
+	libmpathpersist_cleanup();
 	free_config(conf);
-	conf = NULL;
+	return 0;
+}
+
+int libmpathpersist_exit(void)
+{
+	libmpathpersist_cleanup();
+	uninit_config();
 	return 0;
 }
 
diff --git a/libmpathpersist/mpath_persist.h b/libmpathpersist/mpath_persist.h
index 7cf4faf..91606ef 100644
--- a/libmpathpersist/mpath_persist.h
+++ b/libmpathpersist/mpath_persist.h
@@ -175,6 +175,22 @@ struct prout_param_descriptor {		/* PROUT parameter descriptor */
  * DESCRIPTION :
  *	Initialize device mapper multipath configuration. This function must be invoked first
  *	before performing reservation management functions.
+ *	Either this function or mpath_lib_init() may be used.
+ *	Use this function to work with libmultipath's internal "struct config".
+ *	Call libmpathpersist_exit() for cleanup.
+ * RESTRICTIONS:
+ *
+ * RETURNS: 0->Success, 1->Failed.
+ */
+extern int libmpathpersist_init (void);
+
+/*
+ * DESCRIPTION :
+ *	Initialize device mapper multipath configuration. This function must be invoked first
+ *	before performing reservation management functions.
+ *	Either this function or libmpathpersist_init() may be used.
+ *	Use this function to work with an application-specific "struct config".
+ *	Call mpath_lib_exit() for cleanup.
  * RESTRICTIONS:
  *
  * RETURNS: struct config ->Success, NULL->Failed.
@@ -186,12 +202,24 @@ extern struct config * mpath_lib_init (void);
  * DESCRIPTION :
  *	Release device mapper multipath configuration. This function must be invoked after
  *	performing reservation management functions.
+ *	Use this after initialization with mpath_lib_init().
  * RESTRICTIONS:
  *
  * RETURNS: 0->Success, 1->Failed.
  */
 extern int mpath_lib_exit (struct config *conf);
 
+/*
+ * DESCRIPTION :
+ *	Release device mapper multipath configuration. This function must be invoked after
+ *	performing reservation management functions.
+ *	Use this after initialization with libmpathpersist_init().
+ * RESTRICTIONS:
+ *
+ * RETURNS: 0->Success, 1->Failed.
+ */
+extern int libmpathpersist_exit (void);
+
 
 /*
  * DESCRIPTION :
-- 
2.28.0
