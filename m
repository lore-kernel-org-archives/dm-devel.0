From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 5/5] mpathpersist: add support for prkeys file
Date: Fri,  8 Sep 2017 13:45:54 -0500
Message-ID: <1504896354-28181-6-git-send-email-bmarzins@redhat.com>
References: <1504896354-28181-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1504896354-28181-1-git-send-email-bmarzins@redhat.com>
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

When the reservation_key is set to "file", the reservation key needs to
be added to the prkeys file for multipathd to be able to register new
paths as they are added to the device.  This patch adds support to the
mpathpersist command to message multipathd when a key is registered or
unregistered to either add or remove the mapping from the prkeys file.

With these changes, once a device is configured to use the prkeys file,
running mpathpersist commands will automatically update the prkeys file
as necessary.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmpathpersist/mpath_persist.c  | 42 +++++++++++++++++++++++++---------------
 libmpathpersist/mpath_updatepr.c | 10 ++++++++++
 libmpathpersist/mpathpr.h        |  1 +
 3 files changed, 37 insertions(+), 16 deletions(-)

diff --git a/libmpathpersist/mpath_persist.c b/libmpathpersist/mpath_persist.c
index 33843a4..2ddfe77 100644
--- a/libmpathpersist/mpath_persist.c
+++ b/libmpathpersist/mpath_persist.c
@@ -261,8 +261,6 @@ int mpath_persistent_reserve_out ( int fd, int rq_servact, int rq_scope,
 	int map_present;
 	int major, minor;
 	int ret;
-	int j;
-	unsigned char *keyp;
 	uint64_t prkey;
 	struct config *conf;
 
@@ -339,6 +337,26 @@ int mpath_persistent_reserve_out ( int fd, int rq_servact, int rq_scope,
 	select_reservation_key(conf, mpp);
 	put_multipath_config(conf);
 
+	memcpy(&prkey, paramp->sa_key, 8);
+	if (mpp->prkey_source == PRKEY_SOURCE_FILE && prkey &&
+	    ((!mpp->reservation_key && MPATH_PROUT_REG_SA) ||
+	     MPATH_PROUT_REG_IGN_SA)) {
+		memcpy(&mpp->reservation_key, paramp->sa_key, 8);
+		if (update_prkey(alias, be64_to_cpu(mpp->reservation_key))) {
+			condlog(0, "%s: failed to set prkey for multipathd.",
+				alias);
+			ret = MPATH_PR_DMMP_ERROR;
+			goto out1;
+		}
+	}
+
+	if (memcmp(paramp->key, &mpp->reservation_key, 8) &&
+	    memcmp(paramp->sa_key, &mpp->reservation_key, 8)) {
+		condlog(0, "%s: configured reservation key doesn't match: 0x%" PRIx64, alias, be64_to_cpu(mpp->reservation_key));
+		ret = MPATH_PR_SYNTAX_ERROR;
+		goto out1;
+	}
+
 	switch(rq_servact)
 	{
 	case MPATH_PROUT_REG_SA:
@@ -362,22 +380,14 @@ int mpath_persistent_reserve_out ( int fd, int rq_servact, int rq_scope,
 	if ((ret == MPATH_PR_SUCCESS) && ((rq_servact == MPATH_PROUT_REG_SA) ||
 				(rq_servact ==  MPATH_PROUT_REG_IGN_SA)))
 	{
-		keyp=paramp->sa_key;
-		prkey = 0;
-		for (j = 0; j < 8; ++j) {
-			if (j > 0)
-				prkey <<= 8;
-			prkey |= *keyp;
-			++keyp;
-		}
-		if (prkey == 0)
+		if (prkey == 0) {
 			update_prflag(alias, 0);
-		else
+			update_prkey(alias, 0);
+		} else
 			update_prflag(alias, 1);
-	} else {
-		if ((ret == MPATH_PR_SUCCESS) && (rq_servact == MPATH_PROUT_CLEAR_SA)) {
-			update_prflag(alias, 0);
-		}
+	} else if ((ret == MPATH_PR_SUCCESS) && (rq_servact == MPATH_PROUT_CLEAR_SA)) {
+		update_prflag(alias, 0);
+		update_prkey(alias, 0);
 	}
 out1:
 	free_multipathvec(curmp, KEEP_PATHS);
diff --git a/libmpathpersist/mpath_updatepr.c b/libmpathpersist/mpath_updatepr.c
index 6992879..8063e90 100644
--- a/libmpathpersist/mpath_updatepr.c
+++ b/libmpathpersist/mpath_updatepr.c
@@ -58,3 +58,13 @@ static int do_update_pr(char *alias, char *arg)
 int update_prflag(char *mapname, int set) {
 	return do_update_pr(mapname, (set)? "setprstatus" : "unsetprstatus");
 }
+
+int update_prkey(char *mapname, uint64_t prkey) {
+	char str[256];
+
+	if (prkey)
+		sprintf(str, "setprkey key %" PRIx64, prkey);
+	else
+		sprintf(str, "unsetprkey");
+	return do_update_pr(mapname, str);
+}
diff --git a/libmpathpersist/mpathpr.h b/libmpathpersist/mpathpr.h
index 967ba52..72feb60 100644
--- a/libmpathpersist/mpathpr.h
+++ b/libmpathpersist/mpathpr.h
@@ -46,6 +46,7 @@ int send_prout_activepath(char * dev, int rq_servact, int rq_scope,
 	unsigned int rq_type,   struct prout_param_descriptor * paramp, int noisy);
 
 int update_prflag(char *mapname, int set);
+int update_prkey(char *mapname, uint64_t prkey);
 void * mpath_alloc_prin_response(int prin_sa);
 int update_map_pr(struct multipath *mpp);
 
-- 
2.7.4
