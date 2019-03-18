From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 2/3] multipathd: remove "wwid_changed" path
	attribute
Date: Mon, 18 Mar 2019 13:12:34 +0100
Message-ID: <20190318121235.8942-3-mwilck@suse.com>
References: <20190318121235.8942-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190318121235.8942-1-mwilck@suse.com>
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
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

This is now not needed any more.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/structs.h | 1 -
 multipathd/main.c      | 6 ------
 2 files changed, 7 deletions(-)

diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index b794b0dc..7879d763 100644
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
index bd26209d..7119894c 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2016,12 +2016,6 @@ check_path (struct vectors * vecs, struct path * pp, int ticks)
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
2.21.0
