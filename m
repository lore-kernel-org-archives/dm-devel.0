From: Martin Wilck <mwilck@suse.com>
Subject: [RFC PATCH 13/16] multipath -u/-c: add "$DEV is maybe a
	valid path"
Date: Fri, 19 Jan 2018 01:29:13 +0100
Message-ID: <20180119002916.10323-14-mwilck@suse.com>
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

Use DM_MULTIPATH_DEVICE_PATH="2" to indicate that this might be a
valid path, but we aren't certain. This happens with find_multipaths
and ignore_wwids set, when the first path to a device (or a single-path
device) is encountered. In this case, multipath needs to return
with status 0 so that the udev IMPORT statement works.
---
 multipath/main.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/multipath/main.c b/multipath/main.c
index 2127daebcb8f..c65793d5a9e9 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -336,14 +336,15 @@ out:
 	return r;
 }
 
-static void print_cmd_valid(int k)
+static int print_cmd_valid(int k)
 {
-	int vals[] = { 1, 0 };
+	int vals[] = { 1, 0, 2 };
 
 	if (k < 0 || k >= sizeof(vals))
-		return;
+		return 1;
 
 	printf("DM_MULTIPATH_DEVICE_PATH=\"%d\"\n", vals[k]);
+	return k == 1;
 }
 
 /*
@@ -482,6 +483,9 @@ configure (struct config *conf, enum mpath_cmds cmd,
 		 * the refwwid, then the path is valid */
 		if (VECTOR_SIZE(curmp) != 0 || VECTOR_SIZE(pathvec) > 1)
 			r = 0;
+		else
+			/* Use r=2 as an indication for "maybe" */
+			r = 2;
 		goto print_valid;
 	}
 
@@ -498,7 +502,7 @@ configure (struct config *conf, enum mpath_cmds cmd,
 
 print_valid:
 	if (cmd == CMD_VALID_PATH)
-		print_cmd_valid(r);
+		r = print_cmd_valid(r);
 
 out:
 	if (refwwid)
-- 
2.15.1
