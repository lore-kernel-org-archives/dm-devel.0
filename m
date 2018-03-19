From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 12/20] multipath -u: common code path for
	result message
Date: Mon, 19 Mar 2018 16:01:47 +0100
Message-ID: <20180319150155.5363-13-mwilck@suse.com>
References: <20180319150155.5363-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180319150155.5363-1-mwilck@suse.com>
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
Cc: Martin Wilck <mwilck@suse.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

Print the result message in one place only. This simplifies
future changes. multipath -c is also affected.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipath/main.c | 30 +++++++++++++++++++-----------
 1 file changed, 19 insertions(+), 11 deletions(-)

diff --git a/multipath/main.c b/multipath/main.c
index 566404e56ef4..ea4a3d44493a 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -350,6 +350,17 @@ out:
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
@@ -391,10 +402,7 @@ configure (struct config *conf, enum mpath_cmds cmd,
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
@@ -407,7 +415,7 @@ configure (struct config *conf, enum mpath_cmds cmd,
 		if (!refwwid) {
 			condlog(4, "%s: failed to get wwid", devpath);
 			if (failed == 2 && cmd == CMD_VALID_PATH)
-				printf("%s is not a valid multipath device path\n", devpath);
+				goto print_valid;
 			else
 				condlog(3, "scope is null");
 			goto out;
@@ -450,9 +458,7 @@ configure (struct config *conf, enum mpath_cmds cmd,
 				r = 0;
 			if (r == 0 ||
 			    !find_multipaths_on(conf) || !ignore_wwids(conf)) {
-				printf("%s %s a valid multipath device path\n",
-				       devpath, r == 0 ? "is" : "is not");
-				goto out;
+				goto print_valid;
 			}
 		}
 	}
@@ -496,9 +502,7 @@ configure (struct config *conf, enum mpath_cmds cmd,
 		 * the refwwid, then the path is valid */
 		if (VECTOR_SIZE(curmp) != 0 || VECTOR_SIZE(pathvec) > 1)
 			r = 0;
-		printf("%s %s a valid multipath device path\n",
-		       devpath, r == 0 ? "is" : "is not");
-		goto out;
+		goto print_valid;
 	}
 
 	if (cmd != CMD_CREATE && cmd != CMD_DRY_RUN) {
@@ -514,6 +518,10 @@ configure (struct config *conf, enum mpath_cmds cmd,
 	r = coalesce_paths(&vecs, NULL, refwwid,
 			   conf->force_reload, refwwid != NULL, cmd);
 
+print_valid:
+	if (cmd == CMD_VALID_PATH)
+		print_cmd_valid(devpath, r);
+
 out:
 	if (refwwid)
 		FREE(refwwid);
-- 
2.16.1
