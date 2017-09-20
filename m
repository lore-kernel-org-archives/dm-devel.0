From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH v3 3/6] libmpathpersist: fix update_prflag code
Date: Wed, 20 Sep 2017 14:35:14 -0500
Message-ID: <1505936117-19547-4-git-send-email-bmarzins@redhat.com>
References: <1505936117-19547-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1505936117-19547-1-git-send-email-bmarzins@redhat.com>
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
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

There are multiple problems with the prflag code. First, it doesn't do
anything useful at all currently. update_prflags is called with "set"
and "unset" instead of "setprstatus" and "unsetprstatus", so it doesn't
actually enable persistent reservation tracking in multipathd when a key
is registered. Second, the string is to store the multipathd message is
64 bytes long, while just a WWID, which can be used as an alias, can be
128 bytes long, so it's possible to run out of space in the message.
Finally, it is called by mpath_persistent_reserve_out when doing a
preempt and abort, which doesn't make any sense. This disables
multipathd persistent reservation tracking when a node has just taken
over the reservation on a device.

This patch fixes these issues, cleans up the return codes and variable
names, and splits update_prflag into two functions, so that the bulk of
the work (now in do_update_pr), can be reused by other callers.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmpathpersist/mpath_persist.c  |  9 ++++-----
 libmpathpersist/mpath_updatepr.c | 33 +++++++++++++++++----------------
 libmpathpersist/mpathpr.h        |  2 +-
 3 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/libmpathpersist/mpath_persist.c b/libmpathpersist/mpath_persist.c
index 226a0b3..9f6e07a 100644
--- a/libmpathpersist/mpath_persist.c
+++ b/libmpathpersist/mpath_persist.c
@@ -371,13 +371,12 @@ int mpath_persistent_reserve_out ( int fd, int rq_servact, int rq_scope,
 			++keyp;
 		}
 		if (prkey == 0)
-			update_prflag(alias, "unset", noisy);
+			update_prflag(alias, 0);
 		else
-			update_prflag(alias, "set", noisy);
+			update_prflag(alias, 1);
 	} else {
-		if ((ret == MPATH_PR_SUCCESS) && ((rq_servact == MPATH_PROUT_CLEAR_SA) ||
-					(rq_servact == MPATH_PROUT_PREE_AB_SA ))){
-			update_prflag(alias, "unset", noisy);
+		if ((ret == MPATH_PR_SUCCESS) && (rq_servact == MPATH_PROUT_CLEAR_SA)) {
+			update_prflag(alias, 0);
 		}
 	}
 out1:
diff --git a/libmpathpersist/mpath_updatepr.c b/libmpathpersist/mpath_updatepr.c
index b3701b2..6992879 100644
--- a/libmpathpersist/mpath_updatepr.c
+++ b/libmpathpersist/mpath_updatepr.c
@@ -18,42 +18,43 @@
 #include "mpathpr.h"
 
 
-int update_prflag(char * arg1, char * arg2, int noisy)
+static int do_update_pr(char *alias, char *arg)
 {
 	int fd;
-	char str[64];
+	char str[256];
 	char *reply;
 	int ret = 0;
 
 	fd = mpath_connect();
 	if (fd == -1) {
 		condlog (0, "ux socket connect error");
-		return 1 ;
+		return -1;
 	}
 
-	snprintf(str,sizeof(str),"map %s %s", arg1, arg2);
-	condlog (2, "%s: pr flag message=%s", arg1, str);
+	snprintf(str,sizeof(str),"map %s %s", alias, arg);
+	condlog (2, "%s: pr message=%s", alias, str);
 	if (send_packet(fd, str) != 0) {
-		condlog(2, "%s: message=%s send error=%d", arg1, str, errno);
+		condlog(2, "%s: message=%s send error=%d", alias, str, errno);
 		mpath_disconnect(fd);
-		return -2;
+		return -1;
 	}
 	ret = recv_packet(fd, &reply, DEFAULT_REPLY_TIMEOUT);
 	if (ret < 0) {
-		condlog(2, "%s: message=%s recv error=%d", arg1, str, errno);
-		ret = -2;
+		condlog(2, "%s: message=%s recv error=%d", alias, str, errno);
+		ret = -1;
 	} else {
-		condlog (2, "%s: message=%s reply=%s", arg1, str, reply);
-		if (!reply || strncmp(reply,"ok", 2) == 0)
+		condlog (2, "%s: message=%s reply=%s", alias, str, reply);
+		if (reply && strncmp(reply,"ok", 2) == 0)
+			ret = 0;
+		else
 			ret = -1;
-		else if (strncmp(reply, "fail", 4) == 0)
-			ret = -2;
-		else{
-			ret = atoi(reply);
-		}
 	}
 
 	free(reply);
 	mpath_disconnect(fd);
 	return ret;
 }
+
+int update_prflag(char *mapname, int set) {
+	return do_update_pr(mapname, (set)? "setprstatus" : "unsetprstatus");
+}
diff --git a/libmpathpersist/mpathpr.h b/libmpathpersist/mpathpr.h
index 99e641b..967ba52 100644
--- a/libmpathpersist/mpathpr.h
+++ b/libmpathpersist/mpathpr.h
@@ -45,7 +45,7 @@ int mpath_prout_rel(struct multipath *mpp,int rq_servact, int rq_scope,
 int send_prout_activepath(char * dev, int rq_servact, int rq_scope,
 	unsigned int rq_type,   struct prout_param_descriptor * paramp, int noisy);
 
-int update_prflag(char * arg1, char * arg2, int noisy);
+int update_prflag(char *mapname, int set);
 void * mpath_alloc_prin_response(int prin_sa);
 int update_map_pr(struct multipath *mpp);
 
-- 
2.7.4
