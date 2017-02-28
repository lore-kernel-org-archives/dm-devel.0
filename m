From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 10/33] multipath: avoid crash when using modified
	configuration
Date: Tue, 28 Feb 2017 17:23:06 +0100
Message-ID: <20170228162329.14517-11-mwilck@suse.com>
References: <20170228162329.14517-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170228162329.14517-1-mwilck@suse.com>
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

From: Hannes Reinecke <hare@suse.de>

Occasionally multipath would crash when using a modified configuration.


Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 libmultipath/discovery.c |  2 +-
 multipath/main.c         | 10 ++++------
 2 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index e4186de1..bd8ab557 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -1801,7 +1801,7 @@ int pathinfo(struct path *pp, struct config *conf, int mask)
 {
 	int path_state;
 
-	if (!pp)
+	if (!pp || !conf)
 		return PATHINFO_FAILED;
 
 	/*
diff --git a/multipath/main.c b/multipath/main.c
index befe4c53..5811630c 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -266,7 +266,8 @@ get_dm_mpvec (enum mpath_cmds cmd, vector curmp, vector pathvec, char * refwwid)
  *   1: Failure
  */
 static int
-configure (enum mpath_cmds cmd, enum devtypes dev_type, char *devpath)
+configure (struct config *conf, enum mpath_cmds cmd,
+	   enum devtypes dev_type, char *devpath)
 {
 	vector curmp = NULL;
 	vector pathvec = NULL;
@@ -275,7 +276,6 @@ configure (enum mpath_cmds cmd, enum devtypes dev_type, char *devpath)
 	int di_flag = 0;
 	char * refwwid = NULL;
 	char * dev = NULL;
-	struct config *conf;
 
 	/*
 	 * allocate core vectors to store paths and multipaths
@@ -295,7 +295,6 @@ configure (enum mpath_cmds cmd, enum devtypes dev_type, char *devpath)
 	/*
 	 * if we have a blacklisted device parameter, exit early
 	 */
-	conf = get_multipath_config();
 	if (dev && (dev_type == DEV_DEVNODE ||
 		    dev_type == DEV_UEVENT) &&
 	    cmd != CMD_REMOVE_WWID &&
@@ -304,10 +303,9 @@ configure (enum mpath_cmds cmd, enum devtypes dev_type, char *devpath)
 		if (cmd == CMD_VALID_PATH)
 			printf("%s is not a valid multipath device path\n",
 			       devpath);
-		put_multipath_config(conf);
 		goto out;
 	}
-	put_multipath_config(conf);
+
 	/*
 	 * scope limiting must be translated into a wwid
 	 * failing the translation is fatal (by policy)
@@ -730,7 +728,7 @@ main (int argc, char *argv[])
 		r = dm_flush_maps(retries);
 		goto out;
 	}
-	while ((r = configure(cmd, dev_type, dev)) < 0)
+	while ((r = configure(conf, cmd, dev_type, dev)) < 0)
 		condlog(3, "restart multipath configuration process");
 
 out:
-- 
2.11.0
