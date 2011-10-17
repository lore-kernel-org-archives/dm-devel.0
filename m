From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH] multipath: handle offlined paths
Date: Mon, 17 Oct 2011 16:16:02 -0500
Message-ID: <20111017211602.GZ24133@ether.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
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
Cc: Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

The kernel does not allow multipath to load tables containing offline
devices. Because of this, if you try add a path to a multipath device with
an offline path, the multipathd will continually, retry and fail to reload
the table. I've limited the retries to three to avoid livelocking.

Also, if you map included a offline path, multipath was crashing because
it couldn't get the required sysfs information before calling get_state().
It now checks for this in multipath, like it does in multipathd

Lastly, multipathd would keep reprinting the last checker message for
offlined paths, instead of something useful. It now prints a "path offline"
message.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/discovery.c |    9 +++++++--
 multipathd/main.c        |   13 ++++++++++---
 2 files changed, 17 insertions(+), 5 deletions(-)

Index: multipath-tools-111010/libmultipath/discovery.c
===================================================================
--- multipath-tools-111010.orig/libmultipath/discovery.c
+++ multipath-tools-111010/libmultipath/discovery.c
@@ -805,8 +805,13 @@ get_state (struct path * pp, int daemon)
 	condlog(3, "%s: get_state", pp->dev);
 
 	if (!checker_selected(c)) {
-		if (daemon)
-			pathinfo(pp, conf->hwtable, DI_SYSFS);
+		if (daemon || pp->sysdev == NULL) {
+			if (pathinfo(pp, conf->hwtable, DI_SYSFS) != 0) {
+				condlog(3, "%s: couldn't get sysfs pathinfo",
+					pp->dev);
+				return PATH_UNCHECKED;
+			}
+		}
 		select_checker(pp);
 		if (!checker_selected(c)) {
 			condlog(3, "%s: No checker selected", pp->dev);
Index: multipath-tools-111010/multipathd/main.c
===================================================================
--- multipath-tools-111010.orig/multipathd/main.c
+++ multipath-tools-111010/multipathd/main.c
@@ -63,8 +63,13 @@
 #define FILE_NAME_SIZE 256
 #define CMDSIZE 160
 
-#define LOG_MSG(a,b) \
-	if (strlen(b)) condlog(a, "%s: %s - %s", pp->mpp->alias, pp->dev, b);
+#define LOG_MSG(a, b) \
+do { \
+	if (pp->offline) \
+		condlog(a, "%s: %s - path offline", pp->mpp->alias, pp->dev); \
+	else if (strlen(b)) \
+		condlog(a, "%s: %s - %s", pp->mpp->alias, pp->dev, b); \
+} while(0)
 
 pthread_cond_t exit_cond = PTHREAD_COND_INITIALIZER;
 pthread_mutex_t exit_mutex = PTHREAD_MUTEX_INITIALIZER;
@@ -365,6 +370,7 @@ ev_add_path (char * devname, struct vect
 	struct path * pp;
 	char empty_buff[WWID_SIZE] = {0};
 	char params[PARAMS_SIZE] = {0};
+	int retries = 3;
 	int start_waiter = 0;
 
 	if (strstr(devname, "..") != NULL) {
@@ -478,12 +484,14 @@ rescan:
 		/*
 		 * deal with asynchronous uevents :((
 		 */
-		if (mpp->action == ACT_RELOAD) {
+		if (mpp->action == ACT_RELOAD && retries-- > 0) {
 			condlog(0, "%s: uev_add_path sleep", mpp->alias);
 			sleep(1);
 			update_mpp_paths(mpp, vecs->pathvec);
 			goto rescan;
 		}
+		else if (mpp->action == ACT_RELOAD)
+			condlog(0, "%s: giving up reload", mpp->alias);
 		else
 			goto fail_map;
 	}
@@ -502,8 +510,12 @@ rescan:
 	    start_waiter_thread(mpp, vecs))
 			goto fail_map;
 
-	condlog(2, "%s path added to devmap %s", devname, mpp->alias);
-	return 0;
+	if (retries >= 0) {
+		condlog(2, "%s path added to devmap %s", devname, mpp->alias);
+		return 0;
+	}
+	else
+		return 1;
 
 fail_map:
 	remove_map(mpp, vecs, 1);
