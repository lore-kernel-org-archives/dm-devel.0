From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH 1/4] multipathd: avoid null pointer dereference
	in LOG_MSG
Date: Thu,  7 Feb 2019 17:52:59 -0600
Message-ID: <20190207235302.21635-2-bmarzins@redhat.com>
References: <20190207235302.21635-1-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190207235302.21635-1-bmarzins@redhat.com>
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

LOG_MSG() will dereference pp->mpp. Commit cb5ec664 added a call to
LOG_MSG() before the check for (!pp->mpp) in check_path.  This can cause
multipathd to crash.  LOG_MSG() should only be called if pp->mpp is set
and a checker is selected.

Also, checker_message() should fail to a generic message if c->cls isn't
set (which means that a checker hasn't been selected).

Fixes: cb5ec664 (multipathd: check_path: improve logging for "unusable
                 path" case)
Cc: Martin Wilck <mwilck@suse.com>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/checkers.c | 2 +-
 multipathd/main.c       | 6 ++++--
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/libmultipath/checkers.c b/libmultipath/checkers.c
index 848c4c3..ca95cae 100644
--- a/libmultipath/checkers.c
+++ b/libmultipath/checkers.c
@@ -295,7 +295,7 @@ const char *checker_message(const struct checker *c)
 {
 	int id;
 
-	if (!c || c->msgid < 0 ||
+	if (!c || !c->cls || c->msgid < 0 ||
 	    (c->msgid >= CHECKER_GENERIC_MSGTABLE_SIZE &&
 	     c->msgid < CHECKER_FIRST_MSGID))
 		goto bad_id;
diff --git a/multipathd/main.c b/multipathd/main.c
index 0e3ac2c..1caa40f 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2017,8 +2017,10 @@ check_path (struct vectors * vecs, struct path * pp, int ticks)
 	}
 
 	if (newstate == PATH_WILD || newstate == PATH_UNCHECKED) {
-		condlog(2, "%s: unusable path - checker failed", pp->dev);
-		LOG_MSG(2, verbosity, pp);
+		condlog(2, "%s: unusable path (%s) - checker failed", pp->dev,
+			checker_state_name(newstate));
+		if (pp->mpp && checker_selected(&pp->checker))
+			LOG_MSG(2, verbosity, pp);
 		conf = get_multipath_config();
 		pthread_cleanup_push(put_multipath_config, conf);
 		pathinfo(pp, conf, 0);
-- 
2.17.2
