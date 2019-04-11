From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 2/4] Revert "Set priority to '0' for PATH_BLOCKED
	or PATH_DOWN"
Date: Thu, 11 Apr 2019 12:49:21 +0200
Message-ID: <20190411104923.13470-3-mwilck@suse.com>
References: <20190411104923.13470-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190411104923.13470-1-mwilck@suse.com>
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

This reverts commit ce8d707c4235860373238dea6491a77a931d4c9f.

In check_path(), we don't touch path priority if a path is down.
But when pathinfo(DI_CHECKER) is called in down state, we reset
the priority to 0. This is inconsistent.

Commit ce8d707 was about maps being rejected during multipath startup
because of undefined priorities. Since commit 94036e3 "libmultipath:
don't reject maps with undefined prio", such maps aren't rejected
any more, thus we can skip resetting the priority to 0.

Note that when we calculate path group priorities, the prio of
paths which are not UP or GHOST are ignored anyway, so this
change will not cause changes wrt PG priorities or PG ordering.

Signed-off-by: Martin Wilck <mwilck@suse.com>
Cc: Hannes Reinecke <hare@suse.de>
---
 libmultipath/discovery.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 744cf2cc..7a17911d 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -1982,9 +1982,6 @@ int pathinfo(struct path *pp, struct config *conf, int mask)
 		} else {
 			condlog(3, "%s: path inaccessible", pp->dev);
 			pp->chkrstate = pp->state = path_state;
-			if (path_state == PATH_PENDING ||
-			    path_state == PATH_DOWN)
-				pp->priority = 0;
 		}
 	}
 
-- 
2.21.0
