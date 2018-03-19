From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 14/20] multipath -u: add
	DM_MULTIPATH_DEVICE_PATH=2 for "maybe"
Date: Mon, 19 Mar 2018 16:01:49 +0100
Message-ID: <20180319150155.5363-15-mwilck@suse.com>
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

Use DM_MULTIPATH_DEVICE_PATH="2" to indicate that this might be a
valid path, but we aren't certain. This happens with find_multipaths
"smart", when the first path to a device (or a single-path
device) is encountered, and the device is neither blacklisted,
nor marked failed, nor whitelisted in the wwids file.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipath/main.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/multipath/main.c b/multipath/main.c
index f93cad2abde0..9b53c13b3a78 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -350,14 +350,15 @@ out:
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
@@ -501,6 +502,9 @@ configure (struct config *conf, enum mpath_cmds cmd,
 		 * the refwwid, then the path is valid */
 		if (VECTOR_SIZE(curmp) != 0 || VECTOR_SIZE(pathvec) > 1)
 			r = 0;
+		else
+			/* Use r=2 as an indication for "maybe" */
+			r = 2;
 		goto print_valid;
 	}
 
@@ -519,7 +523,7 @@ configure (struct config *conf, enum mpath_cmds cmd,
 
 print_valid:
 	if (cmd == CMD_VALID_PATH)
-		print_cmd_valid(r);
+		r = print_cmd_valid(r);
 
 out:
 	if (refwwid)
-- 
2.16.1
