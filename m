From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 1/5] multipathd: document return values for
	check_path()
Date: Tue, 17 Dec 2013 08:04:04 +0100
Message-ID: <1387263848-73945-2-git-send-email-hare@suse.de>
References: <1387263848-73945-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1387263848-73945-1-git-send-email-hare@suse.de>
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
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

check_path() should return '1' if the path has been checked,
and '0' otherwise. So fixup missing return values and document
it properly.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 multipathd/main.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index fd70b70..bf34a76 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1107,6 +1107,9 @@ int update_path_groups(struct multipath *mpp, struct vectors *vecs, int refresh)
 	return 0;
 }
 
+/*
+ * Returns '1' if the path has been checked, '0' otherwise
+ */
 int
 check_path (struct vectors * vecs, struct path * pp)
 {
@@ -1131,7 +1134,7 @@ check_path (struct vectors * vecs, struct path * pp)
 	if (newstate == PATH_REMOVED) {
 		condlog(2, "%s: remove path (checker)", pp->dev);
 		ev_remove_path(pp, vecs);
-		return;
+		return 0;
 	}
 	if (newstate == PATH_UP)
 		newstate = get_state(pp, 1);
@@ -1152,7 +1155,7 @@ check_path (struct vectors * vecs, struct path * pp)
 				pp->tick = 1;
 			}
 		}
-		return;
+		return 0;
 	}
 	/*
 	 * Async IO in flight. Keep the previous path state
-- 
1.7.12.4
