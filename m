From: mwilck@suse.com
Subject: [PATCH 19/23] multipathd: move cleanup_{prio, checkers,
	foreign} to libmultipath_exit
Date: Thu, 24 Sep 2020 15:40:50 +0200
Message-ID: <20200924134054.14632-20-mwilck@suse.com>
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

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmpathpersist/mpath_persist.c   | 2 --
 libmultipath/config.c             | 4 ++++
 libmultipath/libmultipath.version | 5 +----
 multipathd/main.c                 | 3 ---
 4 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/libmpathpersist/mpath_persist.c b/libmpathpersist/mpath_persist.c
index 873b419..af56a95 100644
--- a/libmpathpersist/mpath_persist.c
+++ b/libmpathpersist/mpath_persist.c
@@ -78,8 +78,6 @@ mpath_lib_init (void)
 
 static void libmpathpersist_cleanup(void)
 {
-	cleanup_prio();
-	cleanup_checkers();
 	libmultipath_exit();
 	dm_lib_exit();
 }
diff --git a/libmultipath/config.c b/libmultipath/config.c
index 8097838..f115ac2 100644
--- a/libmultipath/config.c
+++ b/libmultipath/config.c
@@ -26,6 +26,7 @@
 #include "devmapper.h"
 #include "mpath_cmd.h"
 #include "propsel.h"
+#include "foreign.h"
 
 /*
  * We don't support re-initialization after
@@ -65,6 +66,9 @@ int libmultipath_init(void)
 static void _libmultipath_exit(void)
 {
 	libmultipath_exit_called = true;
+	cleanup_foreign();
+	cleanup_checkers();
+	cleanup_prio();
 	libmp_dm_exit();
 	udev_unref(udev);
 }
diff --git a/libmultipath/libmultipath.version b/libmultipath/libmultipath.version
index 9abdb22..80f1950 100644
--- a/libmultipath/libmultipath.version
+++ b/libmultipath/libmultipath.version
@@ -1,4 +1,4 @@
-LIBMULTIPATH_0.8.4.5 {
+LIBMULTIPATH_0.8.4.6 {
 global:
 	/* symbols referenced by multipath and multipathd */
 	add_foreign;
@@ -18,10 +18,7 @@ global:
 	checker_name;
 	checker_state_name;
 	check_foreign;
-	cleanup_checkers;
-	cleanup_foreign;
 	cleanup_lock;
-	cleanup_prio;
 	close_fd;
 	coalesce_paths;
 	convert_dev;
diff --git a/multipathd/main.c b/multipathd/main.c
index e7b479a..efed56e 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -3027,9 +3027,6 @@ static void cleanup_child(void)
 {
 	cleanup_threads();
 	cleanup_vecs();
-	cleanup_foreign();
-	cleanup_checkers();
-	cleanup_prio();
 	if (poll_dmevents)
 		cleanup_dmevent_waiter();
 
-- 
2.28.0
