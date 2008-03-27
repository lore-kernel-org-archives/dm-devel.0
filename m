From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [PATCH] multipath-tools: fix freeing log verbosity
 config before use
Date: Wed, 26 Mar 2008 19:03:08 -0500 (EST)
Message-ID: <20080326.190308.48535190.k-ueda@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi Christophe,

This patch fixes 2 logging bugs:
  o multipath command prints unexpected log message like
    "libdevmapper: libdm-common.c(303): Created /dev/mapper/<mapname>"
  o multipathd doesn't log messages like "--------shut down------"
    during the exit path

Please apply.


What is the problem:
  o multipath command and multipathd register dm_write_log() using
    dm_log_init() and it can be called from libdevmapper codes like
    dm_lib_release().
  o dm_write_log() references the global "conf" to find the verbosity,
    but it is freed before dm_lib_release() calls dm_write_log().
  o So dm_write_log() reads garbage value like big vervosity.


What does the patch do:
  o multipath command sets NULL to "conf" after freeing it.
    This prevents dm_write_log() from reading garbage data.
  o multipath command and multipathd free "conf" after all logging
    are completed, because the logging functions reference it
    to find the verbosity.

Thanks,
Kiyoshi Ueda

diff -rupN git-20080326/multipath/main.c log-fix/multipath/main.c
--- git-20080326/multipath/main.c	2008-03-26 18:03:17.000000000 -0400
+++ log-fix/multipath/main.c	2008-03-26 18:42:21.000000000 -0400
@@ -421,9 +421,17 @@ main (int argc, char *argv[])
 	
 out:
 	sysfs_cleanup();
-	free_config(conf);
 	dm_lib_release();
 	dm_lib_exit();
+
+	/*
+	 * Freeing config must be done after dm_lib_exit(), because
+	 * the logging function (dm_write_log()), which is called there,
+	 * references the config.
+	 */
+	free_config(conf);
+	conf = NULL;
+
 #ifdef _DEBUG_
 	dbg_free_final(NULL);
 #endif
diff -rupN git-20080326/multipathd/main.c log-fix/multipathd/main.c
--- git-20080326/multipathd/main.c	2008-03-26 18:03:16.000000000 -0400
+++ log-fix/multipathd/main.c	2008-03-26 18:43:16.000000000 -0400
@@ -1365,8 +1365,6 @@ child (void * param)
 	vecs->lock = NULL;
 	FREE(vecs);
 	vecs = NULL;
-	free_config(conf);
-	conf = NULL;
 
 	condlog(2, "--------shut down-------");
 
@@ -1376,6 +1374,14 @@ child (void * param)
 	dm_lib_release();
 	dm_lib_exit();
 
+	/*
+	 * Freeing config must be done after condlog() and dm_lib_exit(),
+	 * because logging functions like dlog() and dm_write_log()
+	 * reference the config.
+	 */
+	free_config(conf);
+	conf = NULL;
+
 #ifdef _DEBUG_
 	dbg_free_final(NULL);
 #endif
