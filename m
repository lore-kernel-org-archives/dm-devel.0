From: hare@suse.de (Hannes Reinecke)
Subject: [PATCH] libdevmapper prints garbage on shutdown
Date: Wed, 30 Apr 2008 11:03:39 +0200
Message-ID: <20080430090339.726D618C6FF@pentland.suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
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
To: Christophe Varoqui <christophe.varoqui@free.fr>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids


This patch fixes 2 logging bugs:
  o multipath command prints unexpected log message like
    "libdevmapper: libdm-common.c(303): Created /dev/mapper/<mapname>"
  o multipathd doesn't log messages like "--------shut down------"
    during the exit path

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

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 multipath/main.c  |   10 +++++++++-
 multipathd/main.c |   10 ++++++++--
 2 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/multipath/main.c b/multipath/main.c
index 0f4b2d2..b6ea6fd 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -429,9 +429,17 @@ main (int argc, char *argv[])
 	
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
diff --git a/multipathd/main.c b/multipathd/main.c
index 50e7441..385521c 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1373,8 +1373,6 @@ child (void * param)
 	vecs->lock = NULL;
 	FREE(vecs);
 	vecs = NULL;
-	free_config(conf);
-	conf = NULL;
 
 	condlog(2, "--------shut down-------");
 
@@ -1384,6 +1382,14 @@ child (void * param)
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
-- 
1.5.2.4
