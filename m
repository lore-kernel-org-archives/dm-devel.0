From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 04/11] multipath: do not print 'path is up' for
	removed paths
Date: Fri, 13 Dec 2013 13:14:07 +0100
Message-ID: <1386936854-8399-5-git-send-email-hare@suse.de>
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

When a path is removed the previous checker message is still
kept in the checker context, and will be printed upon each
check. This causes multipath to print out
'path is up'
even though it already has been removed from sysfs.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 multipathd/main.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 91d7bfc..2633da9 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1124,6 +1124,8 @@ check_path (struct vectors * vecs, struct path * pp)
 	newstate = path_offline(pp);
 	if (newstate == PATH_UP)
 		newstate = get_state(pp, 1);
+	else
+		checker_clear_message(&pp->checker);
 
 	if (newstate == PATH_WILD || newstate == PATH_UNCHECKED) {
 		condlog(2, "%s: unusable path", pp->dev);
@@ -1150,7 +1152,9 @@ check_path (struct vectors * vecs, struct path * pp)
 	if (newstate != pp->state) {
 		int oldstate = pp->state;
 		pp->state = newstate;
-		LOG_MSG(1, checker_message(&pp->checker));
+
+		if (strlen(checker_message(&pp->checker)))
+			LOG_MSG(1, checker_message(&pp->checker));
 
 		/*
 		 * upon state change, reset the checkint
@@ -1232,7 +1236,8 @@ check_path (struct vectors * vecs, struct path * pp)
 			pp->tick = pp->checkint;
 		}
 	}
-	else if (newstate == PATH_DOWN) {
+	else if (newstate == PATH_DOWN &&
+		 strlen(checker_message(&pp->checker))) {
 		if (conf->log_checker_err == LOG_CHKR_ERR_ONCE)
 			LOG_MSG(3, checker_message(&pp->checker));
 		else
-- 
1.8.1.4
