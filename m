From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 10/11] multipathd: add path when transitioned
	from 'blocked' state
Date: Fri, 13 Dec 2013 13:14:13 +0100
Message-ID: <1386936854-8399-11-git-send-email-hare@suse.de>
References: <1386936854-8399-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1386936854-8399-1-git-send-email-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

When a path is discovered in 'blocked' state it won't be added
to the path list as we cannot get the path uuid.
And any further check will fail here as the uuid won't be
recovered. So add a check in checkerloop() to re-add the
path if it gets out of a 'blocked' state.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 multipathd/main.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 7058147..cc5cf67 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1111,9 +1111,6 @@ check_path (struct vectors * vecs, struct path * pp)
 	int chkr_new_path_up = 0;
 	int oldchkrstate = pp->chkrstate;
 
-	if (!pp->mpp)
-		return;
-
 	if (pp->tick && --pp->tick)
 		return; /* don't check this path yet */
 
@@ -1139,6 +1136,17 @@ check_path (struct vectors * vecs, struct path * pp)
 		pathinfo(pp, conf->hwtable, 0);
 		return;
 	}
+	if (!pp->mpp) {
+		if (!strlen(pp->wwid) &&
+		    (newstate == PATH_UP || newstate == PATH_GHOST)) {
+			condlog(2, "%s: add missing path", pp->dev);
+			if (pathinfo(pp, conf->hwtable, DI_ALL) == 0) {
+				ev_add_path(pp, vecs);
+				pp->tick = 1;
+			}
+		}
+		return;
+	}
 	/*
 	 * Async IO in flight. Keep the previous path state
 	 * and reschedule as soon as possible
-- 
1.8.1.4
