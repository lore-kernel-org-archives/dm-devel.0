From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v4 14/20] multipath -u: add
	DM_MULTIPATH_DEVICE_PATH=2 for "maybe"
Date: Wed,  4 Apr 2018 18:16:21 +0200
Message-ID: <20180404161627.6244-15-mwilck@suse.com>
References: <20180404161627.6244-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180404161627.6244-1-mwilck@suse.com>
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
Cc: Julian Andres Klode <julian.klode@canonical.com>, dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

Use DM_MULTIPATH_DEVICE_PATH="2" to indicate that this might be a
valid path, but we aren't certain. This happens with find_multipaths
"smart", when the first path to a device (or a single-path
device) is encountered, and the device is neither blacklisted,
nor marked failed, nor whitelisted in the wwids file.

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipath/main.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/multipath/main.c b/multipath/main.c
index 942caf4..f62e18a 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -353,7 +353,7 @@ out:
 static int print_cmd_valid(int k, const vector pathvec,
 			   struct config *conf)
 {
-	static const int vals[] = { 1, 0 };
+	static const int vals[] = { 1, 0, 2 };
 
 	if (k < 0 || k >= sizeof(vals))
 		return 1;
@@ -504,6 +504,9 @@ configure (struct config *conf, enum mpath_cmds cmd,
 		 * the refwwid, then the path is valid */
 		if (VECTOR_SIZE(curmp) != 0 || VECTOR_SIZE(pathvec) > 1)
 			r = 0;
+		else
+			/* Use r=2 as an indication for "maybe" */
+			r = 2;
 		goto print_valid;
 	}
 
-- 
2.16.1
