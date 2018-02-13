From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH v3 7/7] multipath: print sysfs state in fast list
	mode
Date: Mon, 12 Feb 2018 21:42:14 -0600
Message-ID: <1518493334-18170-8-git-send-email-bmarzins@redhat.com>
References: <1518493334-18170-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1518493334-18170-1-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

commit b123e711ea2a4b471a98ff5e26815df3773636b5 "libmultipath: cleanup
orphan device states" stopped multipathd from showing old state for
orphan paths by checking if pp->mpp was set, and only printing the state
if it was.   Unfortunately, when "multipath -l" is run, pp->mpp isn't
set. While the checker state isn't checked and shouldn't be printed with
"-l", the sysfs state can be, and was before b123e711. This patch sets
pp->mpp in fast list mode, so that the sysfs state gets printed. It
also verifies that the path exists in sysfs, and if not, marks it as
faulty.

Reviewed-by: Martin Wilck <mwilck@suse.com>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipath/main.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/multipath/main.c b/multipath/main.c
index bffe065..d2415a9 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -149,7 +149,7 @@ usage (char * progname)
 }
 
 static int
-update_paths (struct multipath * mpp)
+update_paths (struct multipath * mpp, int quick)
 {
 	int i, j;
 	struct pathgroup * pgp;
@@ -171,9 +171,12 @@ update_paths (struct multipath * mpp)
 					 * path is not in sysfs anymore
 					 */
 					pp->chkrstate = pp->state = PATH_DOWN;
+					pp->offline = 1;
 					continue;
 				}
 				pp->mpp = mpp;
+				if (quick)
+					continue;
 				conf = get_multipath_config();
 				if (pathinfo(pp, conf, DI_ALL))
 					pp->state = PATH_UNCHECKED;
@@ -181,6 +184,8 @@ update_paths (struct multipath * mpp)
 				continue;
 			}
 			pp->mpp = mpp;
+			if (quick)
+				continue;
 			if (pp->state == PATH_UNCHECKED ||
 			    pp->state == PATH_WILD) {
 				conf = get_multipath_config();
@@ -238,8 +243,7 @@ get_dm_mpvec (enum mpath_cmds cmd, vector curmp, vector pathvec, char * refwwid)
 		 * If not in "fast list mode", we need to fetch information
 		 * about them
 		 */
-		if (cmd != CMD_LIST_SHORT)
-			update_paths(mpp);
+		update_paths(mpp, (cmd == CMD_LIST_SHORT));
 
 		if (cmd == CMD_LIST_LONG)
 			mpp->bestpg = select_path_group(mpp);
-- 
2.7.4
