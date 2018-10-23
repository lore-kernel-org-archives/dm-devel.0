From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 09/10] multipathd: improve "add missing path"
	handling
Date: Tue, 23 Oct 2018 15:43:47 +0200
Message-ID: <20181023134348.17915-4-mwilck@suse.com>
References: <20181023134348.17915-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20181023134348.17915-1-mwilck@suse.com>
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

Only add devices that have been properly initialized by pathinfo().
For others, increase the path check interval to avoid useless checks
of devices which are probably not meant to be multipathed anyway.

The check for pp->initialized != INIT_MISSING_UDEV is redundant,
as check_path() returns early in all other cases. Replace it by a
check for INIT_FAILED, in case we ever add more init states.

Suggested-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/main.c | 23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index a9e1a4bd..bf5f12a6 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1811,7 +1811,7 @@ check_path (struct vectors * vecs, struct path * pp, int ticks)
 	int add_active;
 	int disable_reinstate = 0;
 	int oldchkrstate = pp->chkrstate;
-	int retrigger_tries, checkint;
+	int retrigger_tries, checkint, max_checkint;
 	struct config *conf;
 	int ret;
 
@@ -1827,6 +1827,7 @@ check_path (struct vectors * vecs, struct path * pp, int ticks)
 	conf = get_multipath_config();
 	retrigger_tries = conf->retrigger_tries;
 	checkint = conf->checkint;
+	max_checkint = conf->max_checkint;
 	put_multipath_config(conf);
 	if (!pp->mpp && pp->initialized == INIT_MISSING_UDEV) {
 		if (pp->retriggers < retrigger_tries) {
@@ -1891,18 +1892,26 @@ check_path (struct vectors * vecs, struct path * pp, int ticks)
 		return 1;
 	}
 	if (!pp->mpp) {
-		if (!strlen(pp->wwid) && pp->initialized != INIT_MISSING_UDEV &&
+		if (!strlen(pp->wwid) && pp->initialized == INIT_FAILED &&
 		    (newstate == PATH_UP || newstate == PATH_GHOST)) {
 			condlog(2, "%s: add missing path", pp->dev);
 			conf = get_multipath_config();
 			pthread_cleanup_push(put_multipath_config, conf);
 			ret = pathinfo(pp, conf, DI_ALL | DI_BLACKLIST);
 			pthread_cleanup_pop(1);
-			if (ret == PATHINFO_OK) {
+			/* INIT_OK implies ret == PATHINFO_OK */
+			if (pp->initialized == INIT_OK) {
 				ev_add_path(pp, vecs, 1);
 				pp->tick = 1;
-			} else if (ret == PATHINFO_SKIPPED)
-				return -1;
+			} else {
+				/*
+				 * We failed multiple times to initialize this
+				 * path properly. Don't re-check too often.
+				 */
+				pp->checkint = max_checkint;
+				if (ret == PATHINFO_SKIPPED)
+					return -1;
+			}
 		}
 		return 0;
 	}
@@ -2049,11 +2058,7 @@ check_path (struct vectors * vecs, struct path * pp, int ticks)
 				return 0;
 			}
 		} else {
-			unsigned int max_checkint;
 			LOG_MSG(4, checker_message(&pp->checker));
-			conf = get_multipath_config();
-			max_checkint = conf->max_checkint;
-			put_multipath_config(conf);
 			if (pp->checkint != max_checkint) {
 				/*
 				 * double the next check delay.
-- 
2.19.1
