From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH v3 14/17] multipathd: remove "wwid_changed" path
	attribute
Date: Sat, 30 Mar 2019 01:06:03 -0500
Message-ID: <1553925966-20958-15-git-send-email-bmarzins@redhat.com>
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

From: Martin Wilck <mwilck@suse.com>

This is now not needed any more.

Signed-off-by: Martin Wilck <mwilck@suse.com>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/structs.h | 1 -
 multipathd/main.c      | 6 ------
 2 files changed, 7 deletions(-)

diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index b794b0d..7879d76 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -280,7 +280,6 @@ struct path {
 	int fd;
 	int initialized;
 	int retriggers;
-	int wwid_changed;
 	unsigned int path_failures;
 	time_t dis_reinstate_time;
 	int disable_reinstate;
diff --git a/multipathd/main.c b/multipathd/main.c
index b3571d9..e4f95a0 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2001,12 +2001,6 @@ check_path (struct vectors * vecs, struct path * pp, int ticks)
 	if (newstate == PATH_REMOVED)
 		newstate = PATH_DOWN;
 
-	if (pp->wwid_changed) {
-		condlog(2, "%s: path wwid has changed. Refusing to use",
-			pp->dev);
-		newstate = PATH_DOWN;
-	}
-
 	if (newstate == PATH_WILD || newstate == PATH_UNCHECKED) {
 		condlog(2, "%s: unusable path (%s) - checker failed",
 			pp->dev, checker_state_name(newstate));
-- 
2.17.2
