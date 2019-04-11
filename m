From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 4/4] libmultipath: get_prio(): don't reset prio
	for inaccessible paths
Date: Thu, 11 Apr 2019 12:49:23 +0200
Message-ID: <20190411104923.13470-5-mwilck@suse.com>
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

pathinfo() doesn't call get_prio() if a path is down, now keeping the old
priority value. But if a path becomes inaccessible between the state check
and the get_prio() call, retrieving the priority will likely fail, and the
path priority will be reset to PRIO_UNDEF. This makes it timing-dependent
how the priority of a failed path is treated. Fix that by checking the path
state in get_prio() if an error occurs, and not touching pp->priority if
the path is in inaccessible state. A checker_check() call would be too
much here, but a quick path_offline() check seems appropriate.

Keep the previous behavior for the case where getting the priority fails
although the path is apparently healthy. This is presumably a very rare
condition, in which it seems actually wrong to preserve the old prio value.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/discovery.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 7a17911d..7d638c20 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -1625,8 +1625,17 @@ get_prio (struct path * pp)
 	old_prio = pp->priority;
 	pp->priority = prio_getprio(p, pp, checker_timeout);
 	if (pp->priority < 0) {
-		condlog(3, "%s: %s prio error", pp->dev, prio_name(p));
-		pp->priority = PRIO_UNDEF;
+		/* this changes pp->offline, but why not */
+		int state = path_offline(pp);
+
+		if (state == PATH_DOWN || state == PATH_PENDING)
+			condlog(3, "%s: %s prio error in state %d, keeping prio = %d",
+				pp->dev, prio_name(p), state, pp->priority);
+		else {
+			condlog(3, "%s: %s prio error in state %d",
+				pp->dev, prio_name(p), state);
+			pp->priority = PRIO_UNDEF;
+		}
 		return 1;
 	}
 	condlog((old_prio == pp->priority ? 4 : 3), "%s: %s prio = %u",
-- 
2.21.0
