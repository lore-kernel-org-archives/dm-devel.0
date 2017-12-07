From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 11/12] multipath: check failed path dmstate in
	check_path
Date: Thu,  7 Dec 2017 12:49:05 -0600
Message-ID: <1512672546-12785-12-git-send-email-bmarzins@redhat.com>
References: <1512672546-12785-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1512672546-12785-1-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

If a path's checker state is down before and after a path check, but the
path's dmstate is active, mutipath won't update the dmstate. It only
updates the dmstate when the path first fails.  This can cause the
kernel to try known faulty paths, if the multipath device was reloaded
outside of multipathd.  check_path() already checks for and deals with a
similar case where the path's checker state is up before and after a
path check, but the dmstate is failed.  It should do the same thing for
faulty paths.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/main.c | 23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index a420c83..16e4fdf 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1770,16 +1770,21 @@ check_path (struct vectors * vecs, struct path * pp, int ticks)
 			pp->tick = pp->checkint;
 		}
 	}
-	else if (newstate == PATH_DOWN) {
-		int log_checker_err;
+	else if (newstate != PATH_UP && newstate != PATH_GHOST) {
+		if (pp->dmstate == PSTATE_ACTIVE ||
+		    pp->dmstate == PSTATE_UNDEF)
+			fail_path(pp, 0);
+		if (newstate == PATH_DOWN) {
+			int log_checker_err;
 
-		conf = get_multipath_config();
-		log_checker_err = conf->log_checker_err;
-		put_multipath_config(conf);
-		if (log_checker_err == LOG_CHKR_ERR_ONCE)
-			LOG_MSG(3, checker_message(&pp->checker));
-		else
-			LOG_MSG(2, checker_message(&pp->checker));
+			conf = get_multipath_config();
+			log_checker_err = conf->log_checker_err;
+			put_multipath_config(conf);
+			if (log_checker_err == LOG_CHKR_ERR_ONCE)
+				LOG_MSG(3, checker_message(&pp->checker));
+			else
+				LOG_MSG(2, checker_message(&pp->checker));
+		}
 	}
 
 	pp->state = newstate;
-- 
2.7.4
