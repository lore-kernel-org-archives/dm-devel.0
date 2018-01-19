From: Martin Wilck <mwilck@suse.com>
Subject: [RFC PATCH 05/16] multipath -u -i: change logic for
	find_multipaths
Date: Fri, 19 Jan 2018 01:29:05 +0100
Message-ID: <20180119002916.10323-6-mwilck@suse.com>
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

Previously, if find_multipaths was set, files listed in the wwids file
weren't set to be multipathed by "multipath -u -i" unless they also
met the "find_multpaths" criteria (at least two paths, or existing map with
this WWID). Now we classify all paths in the WWIDs file as multipath members.

The rationale for this patch is to match the logic that multipathd applies
when "-n" is not given.
---
 multipath/main.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/multipath/main.c b/multipath/main.c
index 21cc45145dbb..b7e5cf46fe0f 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -423,16 +423,19 @@ configure (struct config *conf, enum mpath_cmds cmd,
 		 * set, you need to actually check if there are two available
 		 * paths to determine if this path should be multipathed. To
 		 * do this, we put off the check until after discovering all
-		 * the paths */
-		if (cmd == CMD_VALID_PATH &&
-		    (!conf->find_multipaths || !conf->ignore_wwids)) {
-			if (conf->ignore_wwids ||
+		 * the paths.
+		 * Paths listed in the wwids file are always considered valid.
+		 */
+		if (cmd == CMD_VALID_PATH) {
+			if ((!conf->find_multipaths && conf->ignore_wwids) ||
 			    check_wwids_file(refwwid, 0) == 0)
 				r = 0;
-
-			printf("%s %s a valid multipath device path\n",
-			       devpath, r == 0 ? "is" : "is not");
-			goto out;
+			if (r == 0 ||
+			    !conf->find_multipaths || !conf->ignore_wwids) {
+				printf("%s %s a valid multipath device path\n",
+				       devpath, r == 0 ? "is" : "is not");
+				goto out;
+			}
 		}
 	}
 
-- 
2.15.1
