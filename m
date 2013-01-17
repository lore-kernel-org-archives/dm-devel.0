From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 08/11] multipathd: log message when check
	interval has changed
Date: Thu, 17 Jan 2013 15:59:30 +0100
Message-ID: <1358434773-2002-9-git-send-email-hare@suse.de>
References: <1358434773-2002-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1358434773-2002-1-git-send-email-hare@suse.de>
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

We should only log the message if the check interval has
indeed changed.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 multipathd/main.c |   26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 8c0866d..7f83a7a 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1209,18 +1209,20 @@ check_path (struct vectors * vecs, struct path * pp)
 			reinstate_path(pp, 0);
 		} else {
 			LOG_MSG(4, checker_message(&pp->checker));
-			/*
-			 * double the next check delay.
-			 * max at conf->max_checkint
-			 */
-			if (pp->checkint < (conf->max_checkint / 2))
-				pp->checkint = 2 * pp->checkint;
-			else
-				pp->checkint = conf->max_checkint;
-
-			pp->tick = pp->checkint;
-			condlog(4, "%s: delay next check %is",
-				pp->dev_t, pp->tick);
+			if (pp->checkint != conf->max_checkint) {
+				/*
+				 * double the next check delay.
+				 * max at conf->max_checkint
+				 */
+				if (pp->checkint < (conf->max_checkint / 2))
+					pp->checkint = 2 * pp->checkint;
+				else
+					pp->checkint = conf->max_checkint;
+
+				pp->tick = pp->checkint;
+				condlog(4, "%s: delay next check %is",
+					pp->dev_t, pp->tick);
+			}
 		}
 	}
 	else if (newstate == PATH_DOWN) {
-- 
1.7.10.4
