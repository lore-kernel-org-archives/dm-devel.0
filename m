From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v5 11/21] multipathd: improve checker message
	logging
Date: Fri,  2 Nov 2018 13:21:15 +0100
Message-ID: <20181102122125.30906-12-mwilck@suse.com>
References: <20181102122125.30906-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20181102122125.30906-1-mwilck@suse.com>
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

Don't rely on any variables being defined in LOG_MSG.
If message log level is low, don't bother to fetch the message.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/main.c | 35 ++++++++++++++++++++++++-----------
 1 file changed, 24 insertions(+), 11 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index bf5f12a6..2f922db7 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -89,12 +89,24 @@ static int use_watchdog;
 #define FILE_NAME_SIZE 256
 #define CMDSIZE 160
 
-#define LOG_MSG(a, b) \
-do { \
-	if (pp->offline) \
-		condlog(a, "%s: %s - path offline", pp->mpp->alias, pp->dev); \
-	else if (strlen(b)) \
-		condlog(a, "%s: %s - %s", pp->mpp->alias, pp->dev, b); \
+#define LOG_MSG(lvl, verb, pp)					\
+do {								\
+	if (lvl <= verb) {					\
+		if (pp->offline)				\
+			condlog(lvl, "%s: %s - path offline",	\
+				pp->mpp->alias, pp->dev);	\
+		else  {						\
+			const char *__m =			\
+				checker_message(&pp->checker);	\
+								\
+			if (strlen(__m))			      \
+				condlog(lvl, "%s: %s - %s checker%s", \
+					pp->mpp->alias,		      \
+					pp->dev,		      \
+					checker_name(&pp->checker),   \
+					__m);			      \
+		}						      \
+	}							      \
 } while(0)
 
 struct mpath_event_param
@@ -1811,7 +1823,7 @@ check_path (struct vectors * vecs, struct path * pp, int ticks)
 	int add_active;
 	int disable_reinstate = 0;
 	int oldchkrstate = pp->chkrstate;
-	int retrigger_tries, checkint, max_checkint;
+	int retrigger_tries, checkint, max_checkint, verbosity;
 	struct config *conf;
 	int ret;
 
@@ -1828,6 +1840,7 @@ check_path (struct vectors * vecs, struct path * pp, int ticks)
 	retrigger_tries = conf->retrigger_tries;
 	checkint = conf->checkint;
 	max_checkint = conf->max_checkint;
+	verbosity = conf->verbosity;
 	put_multipath_config(conf);
 	if (!pp->mpp && pp->initialized == INIT_MISSING_UDEV) {
 		if (pp->retriggers < retrigger_tries) {
@@ -1970,7 +1983,7 @@ check_path (struct vectors * vecs, struct path * pp, int ticks)
 		int oldstate = pp->state;
 		pp->state = newstate;
 
-		LOG_MSG(1, checker_message(&pp->checker));
+		LOG_MSG(1, verbosity, pp);
 
 		/*
 		 * upon state change, reset the checkint
@@ -2058,7 +2071,7 @@ check_path (struct vectors * vecs, struct path * pp, int ticks)
 				return 0;
 			}
 		} else {
-			LOG_MSG(4, checker_message(&pp->checker));
+			LOG_MSG(4, verbosity, pp);
 			if (pp->checkint != max_checkint) {
 				/*
 				 * double the next check delay.
@@ -2088,9 +2101,9 @@ check_path (struct vectors * vecs, struct path * pp, int ticks)
 			log_checker_err = conf->log_checker_err;
 			put_multipath_config(conf);
 			if (log_checker_err == LOG_CHKR_ERR_ONCE)
-				LOG_MSG(3, checker_message(&pp->checker));
+				LOG_MSG(3, verbosity, pp);
 			else
-				LOG_MSG(2, checker_message(&pp->checker));
+				LOG_MSG(2, verbosity, pp);
 		}
 	}
 
-- 
2.19.1
