From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH v3 08/17] libmutipath: continue to use old state
	on PATH_PENDING
Date: Sat, 30 Mar 2019 01:05:57 -0500
Message-ID: <1553925966-20958-9-git-send-email-bmarzins@redhat.com>
References: <1553925966-20958-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1553925966-20958-1-git-send-email-bmarzins@redhat.com>
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
Cc: device-mapper development <dm-devel@redhat.com>, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

When pathinfo() sets pp->state to PATH_PENDING, it can cause problems
with path checking.  It should act more like check_path(). When
check_path() sees a new state of PATH_PENDING, it doesn't update the
path state at all, so a path's old state is normally never PATH_PENDING.

As and example of the problems of setting a path to PATH_PENDING, If
check_path() sets a path's state to PATH_UP, then a call to pathinfo()
sets the state to PATH_PENDING, and then another call the check_path()
sets the state to PATH_DOWN, multipathd won't fail the path in the
kernel. Also, if a path's state is PATH_PENDING, and nr_active is
recalculated, that path will count as down, even if the state was
previously PATH_UP. If a path already has a state of PATH_WILD or
PATH_UNCHECKED, changing it to PATH_PENDING won't hurt anything, and it
will help anyone who sees it know what's actually happening. But
otherwise, pathinfo() should leave the previous state alone.

Reviewed-by: Martin Wilck <mwilck@suse.com>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/discovery.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index b08cb2d..28c00e5 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -1946,8 +1946,11 @@ int pathinfo(struct path *pp, struct config *conf, int mask)
 
 	if (mask & DI_CHECKER) {
 		if (path_state == PATH_UP) {
-			pp->chkrstate = pp->state = get_state(pp, conf, 0,
-							      path_state);
+			int newstate = get_state(pp, conf, 0, path_state);
+			if (newstate != PATH_PENDING ||
+			    pp->state == PATH_UNCHECKED ||
+			    pp->state == PATH_WILD)
+				pp->chkrstate = pp->state = newstate;
 			if (pp->state == PATH_TIMEOUT)
 				pp->state = PATH_DOWN;
 			if (pp->state == PATH_UP && !pp->size) {
-- 
2.17.2
