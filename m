From: mwilck@suse.com
Subject: [PATCH 15/19] multipath: use {get_put}_multipath_config
	from libmultipath
Date: Wed, 16 Sep 2020 17:37:14 +0200
Message-ID: <20200916153718.582-16-mwilck@suse.com>
References: <20200916153718.582-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200916153718.582-1-mwilck@suse.com>
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

From: Martin Wilck <mwilck@suse.com>

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipath/main.c | 20 ++++----------------
 1 file changed, 4 insertions(+), 16 deletions(-)

diff --git a/multipath/main.c b/multipath/main.c
index 650977c..2f5ddd9 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -68,7 +68,6 @@
 
 int logsink;
 struct udev *udev;
-struct config *multipath_conf;
 
 /*
  * Return values of configure(), check_path_valid(), and main().
@@ -79,16 +78,6 @@ enum {
 	RTVL_RETRY, /* returned by configure(), not by main() */
 };
 
-struct config *get_multipath_config(void)
-{
-	return multipath_conf;
-}
-
-void put_multipath_config(__attribute__((unused)) void *arg)
-{
-	/* Noop for now */
-}
-
 static int
 dump_config (struct config *conf, vector hwes, vector mpvec)
 {
@@ -826,10 +815,9 @@ main (int argc, char *argv[])
 
 	udev = udev_new();
 	logsink = 0;
-	conf = load_config(DEFAULT_CONFIGFILE);
-	if (!conf)
+	if (init_config(DEFAULT_CONFIGFILE))
 		exit(RTVL_FAIL);
-	multipath_conf = conf;
+	conf = get_multipath_config();
 	conf->retrigger_tries = 0;
 	conf->force_sync = 1;
 	while ((arg = getopt(argc, argv, ":adDcChl::eFfM:v:p:b:BrR:itTquUwW")) != EOF ) {
@@ -1081,8 +1069,8 @@ out_free_config:
 	 * the logging function (dm_write_log()), which is called there,
 	 * references the config.
 	 */
-	free_config(conf);
-	conf = NULL;
+	put_multipath_config(conf);
+	uninit_config();
 	udev_unref(udev);
 	if (dev)
 		FREE(dev);
-- 
2.28.0
