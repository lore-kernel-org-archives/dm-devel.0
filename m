From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH 10/15] libmultipath: change how the checker async
	is set
Date: Thu, 16 Jan 2020 20:18:15 -0600
Message-ID: <1579227500-17196-11-git-send-email-bmarzins@redhat.com>
References: <1579227500-17196-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1579227500-17196-1-git-send-email-bmarzins@redhat.com>
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
Cc: device-mapper development <dm-devel@redhat.com>, Martin Wilck <Martin.Wilck@suse.com>
List-Id: dm-devel.ids

The way that the checkers async mode worked in multipathd didn't make
much sense. When multipathd starts up, all checker classes are in the
sync mode, and any pathinfo() calls on devices would run the checker in
sync mode. However, the First time a checker class was used in
checkerloop, it would set that checker class to async (assuming
force_sync wasn't set).  After that, no matter when a checker from that
class was called, it would always run in async mode.  Multipathd doesn't
need to run checkers in sync mode at all, so don't.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmpathpersist/mpath_persist.c |  2 +-
 libmultipath/discovery.c        | 10 ++++------
 multipath/main.c                |  1 +
 3 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/libmpathpersist/mpath_persist.c b/libmpathpersist/mpath_persist.c
index 603cfc3b..b2238f00 100644
--- a/libmpathpersist/mpath_persist.c
+++ b/libmpathpersist/mpath_persist.c
@@ -47,7 +47,7 @@ mpath_lib_init (void)
 		condlog(0, "Failed to initialize multipath config.");
 		return NULL;
 	}
-
+	conf->force_sync = 1;
 	set_max_fds(conf->max_fds);
 
 	return conf;
diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index d2773c3a..1ab093f4 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -1643,12 +1643,10 @@ get_state (struct path * pp, struct config *conf, int daemon, int oldstate)
 	if (pp->mpp && !c->mpcontext)
 		checker_mp_init(c, &pp->mpp->mpcontext);
 	checker_clear_message(c);
-	if (daemon) {
-		if (conf->force_sync == 0)
-			checker_set_async(c);
-		else
-			checker_set_sync(c);
-	}
+	if (conf->force_sync == 0)
+		checker_set_async(c);
+	else
+		checker_set_sync(c);
 	if (!conf->checker_timeout &&
 	    sysfs_get_timeout(pp, &(c->timeout)) <= 0)
 		c->timeout = DEF_TIMEOUT;
diff --git a/multipath/main.c b/multipath/main.c
index 4f4d8e89..aebabd9b 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -905,6 +905,7 @@ main (int argc, char *argv[])
 		exit(RTVL_FAIL);
 	multipath_conf = conf;
 	conf->retrigger_tries = 0;
+	conf->force_sync = 1;
 	while ((arg = getopt(argc, argv, ":adcChl::FfM:v:p:b:BrR:itTquUwW")) != EOF ) {
 		switch(arg) {
 		case 1: printf("optarg : %s\n",optarg);
-- 
2.17.2
