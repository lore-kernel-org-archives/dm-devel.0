From: Martin Wilck <mwilck@suse.com>
Subject: [RFC PATCH 11/16] multipath: common code path for
	CMD_VALID_PATH
Date: Fri, 19 Jan 2018 01:29:11 +0100
Message-ID: <20180119002916.10323-12-mwilck@suse.com>
References: <20180119002916.10323-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180119002916.10323-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, dm-devel@redhat.com, Benjamin Marzinski <bmarzins@redhat.com>
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

Print the result message in one place only. This simplifies
future changes.
---
 multipath/main.c | 30 +++++++++++++++++++-----------
 1 file changed, 19 insertions(+), 11 deletions(-)

diff --git a/multipath/main.c b/multipath/main.c
index b7e5cf46fe0f..4b3d3a94b282 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -336,6 +336,17 @@ out:
 	return r;
 }
 
+static void print_cmd_valid(const char *devpath, int k)
+{
+	const char *msg[] = { "is", "is not" };
+
+	if (k < 0 || k >= sizeof(msg))
+		return;
+
+	printf("%s %s a valid multipath device path\n",
+	       devpath, msg[k]);
+}
+
 /*
  * Return value:
  *  -1: Retry
@@ -377,10 +388,7 @@ configure (struct config *conf, enum mpath_cmds cmd,
 	    cmd != CMD_REMOVE_WWID &&
 	    (filter_devnode(conf->blist_devnode,
 			    conf->elist_devnode, dev) > 0)) {
-		if (cmd == CMD_VALID_PATH)
-			printf("%s is not a valid multipath device path\n",
-			       devpath);
-		goto out;
+		goto print_valid;
 	}
 
 	/*
@@ -393,7 +401,7 @@ configure (struct config *conf, enum mpath_cmds cmd,
 		if (!refwwid) {
 			condlog(4, "%s: failed to get wwid", devpath);
 			if (failed == 2 && cmd == CMD_VALID_PATH)
-				printf("%s is not a valid multipath device path\n", devpath);
+				goto print_valid;
 			else
 				condlog(3, "scope is null");
 			goto out;
@@ -432,9 +440,7 @@ configure (struct config *conf, enum mpath_cmds cmd,
 				r = 0;
 			if (r == 0 ||
 			    !conf->find_multipaths || !conf->ignore_wwids) {
-				printf("%s %s a valid multipath device path\n",
-				       devpath, r == 0 ? "is" : "is not");
-				goto out;
+				goto print_valid;
 			}
 		}
 	}
@@ -477,9 +483,7 @@ configure (struct config *conf, enum mpath_cmds cmd,
 		 * the refwwid, then the path is valid */
 		if (VECTOR_SIZE(curmp) != 0 || VECTOR_SIZE(pathvec) > 1)
 			r = 0;
-		printf("%s %s a valid multipath device path\n",
-		       devpath, r == 0 ? "is" : "is not");
-		goto out;
+		goto print_valid;
 	}
 
 	if (cmd != CMD_CREATE && cmd != CMD_DRY_RUN) {
@@ -493,6 +497,10 @@ configure (struct config *conf, enum mpath_cmds cmd,
 	r = coalesce_paths(&vecs, NULL, refwwid,
 			   conf->force_reload, cmd);
 
+print_valid:
+	if (cmd == CMD_VALID_PATH)
+		print_cmd_valid(devpath, r);
+
 out:
 	if (refwwid)
 		FREE(refwwid);
-- 
2.15.1
