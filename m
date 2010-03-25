From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH] multipath: patch checker consolidation
Date: Thu, 25 Mar 2010 00:44:17 -0500
Message-ID: <20100325054417.GF23952@ether.msp.redhat.com>
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
List-Id: dm-devel.ids

This patch does two things. First, it allows the tur checker to retry when it
fails with DID_TRANSPORT_DISRUPTED. Second, it makes both calls to check a path
use get_state, do avoid duplicated code.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
:100644 100644 e06dc52... 47107a2... M	libmultipath/checkers/tur.c
:100644 100644 98d1618... 00aa5ea... M	libmultipath/discovery.c
:100644 100644 7283f36... 17cd4af... M	libmultipath/discovery.h
:100644 100644 90de6df... 5d3625a... M	multipathd/main.c
 libmultipath/checkers/tur.c |    1 -
 libmultipath/discovery.c    |   36 +++++++++++++++++++++---------------
 libmultipath/discovery.h    |    1 +
 multipathd/main.c           |   20 ++------------------
 4 files changed, 24 insertions(+), 34 deletions(-)

Index: multipath-tools-100322/libmultipath/checkers/tur.c
===================================================================
--- multipath-tools-100322.orig/libmultipath/checkers/tur.c
+++ multipath-tools-100322/libmultipath/checkers/tur.c
@@ -69,7 +69,6 @@ libcheck_check (struct checker * c)
 		case DID_NO_CONNECT:
 		case DID_BAD_TARGET:
 		case DID_ABORT:
-		case DID_TRANSPORT_DISRUPTED:
 		case DID_TRANSPORT_FAILFAST:
 			break;
 		default:
Index: multipath-tools-100322/libmultipath/discovery.c
===================================================================
--- multipath-tools-100322.orig/libmultipath/discovery.c
+++ multipath-tools-100322/libmultipath/discovery.c
@@ -741,38 +741,41 @@ cciss_ioctl_pathinfo (struct path * pp, 
 	return 0;
 }
 
-static int
-get_state (struct path * pp)
+int
+get_state (struct path * pp, int daemon)
 {
 	struct checker * c = &pp->checker;
-	int sysfs_state;
+	int state;
 
 	condlog(3, "%s: get_state", pp->dev);
 
 	if (!checker_selected(c)) {
+		if (daemon)
+			pathinfo(pp, conf->hwtable, DI_SYSFS);
 		select_checker(pp);
 		if (!checker_selected(c)) {
 			condlog(3, "%s: No checker selected", pp->dev);
-			return 1;
+			return PATH_UNCHECKED;
 		}
 		checker_set_fd(c, pp->fd);
 		if (checker_init(c, pp->mpp?&pp->mpp->mpcontext:NULL)) {
 			condlog(3, "%s: checker init failed", pp->dev);
-			return 1;
+			return PATH_UNCHECKED;
 		}
 	}
-	sysfs_state = path_offline(pp);
-	if (sysfs_state != PATH_UP) {
+	state = path_offline(pp);
+	if (state != PATH_UP) {
 		condlog(3, "%s: path inaccessible", pp->dev);
-		pp->state = sysfs_state;
-		return 0;
+		return state;
 	}
-	pp->state = checker_check(c);
-	condlog(3, "%s: state = %i", pp->dev, pp->state);
-	if (pp->state == PATH_DOWN && strlen(checker_message(c)))
+	if (daemon)
+		checker_set_async(c);
+	state = checker_check(c);
+	condlog(3, "%s: state = %i", pp->dev, state);
+	if (state == PATH_DOWN && strlen(checker_message(c)))
 		condlog(3, "%s: checker msg is \"%s\"",
 			pp->dev, checker_message(c));
-	return 0;
+	return state;
 }
 
 static int
@@ -857,8 +860,11 @@ pathinfo (struct path *pp, vector hwtabl
 	    cciss_ioctl_pathinfo(pp, mask))
 		goto blank;
 
-	if (mask & DI_CHECKER && get_state(pp))
-		goto blank;
+	if (mask & DI_CHECKER) {
+		pp->state = get_state(pp, 0);
+		if (pp->state == PATH_UNCHECKED || pp->state == PATH_WILD)
+			goto blank;
+	}
 
 	 /*
 	  * Retrieve path priority, even for PATH_DOWN paths if it has never
Index: multipath-tools-100322/libmultipath/discovery.h
===================================================================
--- multipath-tools-100322.orig/libmultipath/discovery.h
+++ multipath-tools-100322/libmultipath/discovery.h
@@ -30,6 +30,7 @@ int path_discovery (vector pathvec, stru
 int do_tur (char *);
 int devt2devname (char *, char *);
 int path_offline (struct path *);
+int get_state (struct path * pp, int daemon);
 int pathinfo (struct path *, vector hwtable, int mask);
 struct path * store_pathinfo (vector pathvec, vector hwtable,
 			      char * devname, int flag);
Index: multipath-tools-100322/multipathd/main.c
===================================================================
--- multipath-tools-100322.orig/multipathd/main.c
+++ multipath-tools-100322/multipathd/main.c
@@ -934,25 +934,9 @@ check_path (struct vectors * vecs, struc
 	 */
 	pp->tick = conf->checkint;
 
-	if (!checker_selected(&pp->checker)) {
-		pathinfo(pp, conf->hwtable, DI_SYSFS);
-		select_checker(pp);
-	}
-	if (!checker_selected(&pp->checker)) {
-		condlog(0, "%s: checker is not set", pp->dev);
-		return;
-	}
-	/*
-	 * Set checker in async mode.
-	 * Honored only by checker implementing the said mode.
-	 */
-	checker_set_async(&pp->checker);
-
-	newstate = path_offline(pp);
-	if (newstate == PATH_UP)
-		newstate = checker_check(&pp->checker);
+	newstate = get_state(pp, 1);
 
-	if (newstate < 0) {
+	if (newstate == PATH_WILD || newstate == PATH_UNCHECKED) {
 		condlog(2, "%s: unusable path", pp->dev);
 		pathinfo(pp, conf->hwtable, 0);
 		return;
