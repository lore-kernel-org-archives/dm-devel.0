From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 49/78] multipathd: do not remove paths without
	uevents
Date: Mon, 16 Mar 2015 13:36:36 +0100
Message-ID: <1426509425-15978-50-git-send-email-hare@suse.de>
References: <1426509425-15978-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1426509425-15978-1-git-send-email-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@gmail.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

multipathd should not remove any paths without the corresponding
uevent. Otherwise the daemon will never be able to reinstate that
path as it wouldn't get any uevents.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 multipathd/main.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 2eade36..0608f06 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1152,11 +1152,14 @@ check_path (struct vectors * vecs, struct path * pp)
 	pp->tick = conf->checkint;
 
 	newstate = path_offline(pp);
-	if (newstate == PATH_REMOVED) {
-		condlog(2, "%s: remove path (checker)", pp->dev);
-		ev_remove_path(pp, vecs);
-		return 0;
-	}
+	/*
+	 * Wait for uevent for removed paths;
+	 * some LLDDs like zfcp keep paths unavailable
+	 * without sending uevents.
+	 */
+	if (newstate == PATH_REMOVED)
+		newstate = PATH_DOWN;
+
 	if (newstate == PATH_UP)
 		newstate = get_state(pp, 1);
 	else
-- 
1.8.4.5
