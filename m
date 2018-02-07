From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 7/7] multipath: print sysfs state in fast list
	mode
Date: Wed,  7 Feb 2018 16:49:47 -0600
Message-ID: <1518043787-7066-8-git-send-email-bmarzins@redhat.com>
References: <1518043787-7066-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1518043787-7066-1-git-send-email-bmarzins@redhat.com>
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
Cc: Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

commit b123e711ea2a4b471a98ff5e26815df3773636b5 "libmultipath: cleanup
orphan device states" stopped multipathd from showing old state for
orphan paths by checking if pp->mpp was set, and only printing the state
if it was.   Unfortunately, when "multipath -l" is run, pp->mpp isn't
set. While the checker state isn't checked and shouldn't be printed with
"-l", the sysfs state can be, and was before b123e711. This patch sets
pp->mpp in fast list mode, so that the sysfs state gets printed.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipath/main.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/multipath/main.c b/multipath/main.c
index bffe065..1799fd5 100644
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
@@ -164,6 +164,10 @@ update_paths (struct multipath * mpp)
 			continue;
 
 		vector_foreach_slot (pgp->paths, pp, j) {
+			if (quick) {
+				pp->mpp = mpp;
+				continue;
+			}
 			if (!strlen(pp->dev)) {
 				if (devt2devname(pp->dev, FILE_NAME_SIZE,
 						 pp->dev_t)) {
@@ -238,8 +242,7 @@ get_dm_mpvec (enum mpath_cmds cmd, vector curmp, vector pathvec, char * refwwid)
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
