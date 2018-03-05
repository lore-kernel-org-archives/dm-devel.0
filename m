From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 19/23] multipath: use foreign API
Date: Tue,  6 Mar 2018 00:15:03 +0100
Message-ID: <20180305231507.10386-20-mwilck@suse.com>
References: <20180305231507.10386-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180305231507.10386-1-mwilck@suse.com>
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
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

Use the "foreign" code to print information about multipath maps
owned by foreign libraries in print mode (multipath -ll, -l).

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipath/main.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/multipath/main.c b/multipath/main.c
index a0c750e6f623..4fae49ee4325 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -59,6 +59,7 @@
 #include "wwids.h"
 #include "uxsock.h"
 #include "mpath_cmd.h"
+#include "foreign.h"
 
 int logsink;
 struct udev *udev;
@@ -257,6 +258,14 @@ get_dm_mpvec (enum mpath_cmds cmd, vector curmp, vector pathvec, char * refwwid)
 		if (cmd == CMD_CREATE)
 			reinstate_paths(mpp);
 	}
+
+	if (cmd == CMD_LIST_SHORT || cmd == CMD_LIST_LONG) {
+		struct config *conf = get_multipath_config();
+
+		print_foreign_topology(conf->verbosity);
+		put_multipath_config(conf);
+	}
+
 	return 0;
 }
 
@@ -460,6 +469,7 @@ configure (struct config *conf, enum mpath_cmds cmd,
 		print_all_paths(pathvec, 1);
 
 	get_path_layout(pathvec, 0);
+	foreign_path_layout();
 
 	if (get_dm_mpvec(cmd, curmp, pathvec, refwwid))
 		goto out;
@@ -817,6 +827,8 @@ main (int argc, char *argv[])
 		condlog(0, "failed to initialize prioritizers");
 		goto out;
 	}
+	/* Failing here is non-fatal */
+	init_foreign(conf->multipath_dir);
 	if (cmd == CMD_USABLE_PATHS) {
 		r = check_usable_paths(conf, dev, dev_type);
 		goto out;
@@ -892,6 +904,7 @@ out:
 	dm_lib_release();
 	dm_lib_exit();
 
+	cleanup_foreign();
 	cleanup_prio();
 	cleanup_checkers();
 
-- 
2.16.1
