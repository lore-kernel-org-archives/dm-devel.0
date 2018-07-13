From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 04/10] mpathpersist: add --param-alltgpt option
Date: Fri, 13 Jul 2018 14:39:09 -0500
Message-ID: <1531510755-16046-5-git-send-email-bmarzins@redhat.com>
References: <1531510755-16046-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1531510755-16046-1-git-send-email-bmarzins@redhat.com>
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

From the limited testing I've been able to do, commit 5b54e772
"mpathpersist: add all_tg_pt option", does appear to enable
--param-alltgpt to work correctly on devices that accept the ALL_TG_PT
flag, so I've added the option to mpathpersist.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmpathpersist/mpath_persist.c | 10 ++++------
 mpathpersist/main.c             | 11 ++++++++---
 mpathpersist/main.h             |  1 +
 mpathpersist/mpathpersist.8     |  4 ++++
 multipath/multipath.conf.5      |  8 +++++---
 5 files changed, 22 insertions(+), 12 deletions(-)

diff --git a/libmpathpersist/mpath_persist.c b/libmpathpersist/mpath_persist.c
index 6e9e67f..61818e0 100644
--- a/libmpathpersist/mpath_persist.c
+++ b/libmpathpersist/mpath_persist.c
@@ -466,11 +466,14 @@ int mpath_prout_reg(struct multipath *mpp,int rq_servact, int rq_scope,
 	int rc;
 	int count=0;
 	int status = MPATH_PR_SUCCESS;
+	int all_tg_pt;
 	uint64_t sa_key = 0;
 
 	if (!mpp)
 		return MPATH_PR_DMMP_ERROR;
 
+	all_tg_pt = (mpp->all_tg_pt == ALL_TG_PT_ON ||
+		     paramp->sa_flags & MPATH_F_ALL_TG_PT_MASK);
 	active_pathcount = pathcount(mpp, PATH_UP) + pathcount(mpp, PATH_GHOST);
 
 	if (active_pathcount == 0) {
@@ -478,10 +481,6 @@ int mpath_prout_reg(struct multipath *mpp,int rq_servact, int rq_scope,
 		return MPATH_PR_DMMP_ERROR;
 	}
 
-	if ( paramp->sa_flags & MPATH_F_ALL_TG_PT_MASK ) {
-		condlog (1, "Warning: ALL_TG_PT is set. Configuration not supported");
-	}
-
 	struct threadinfo thread[active_pathcount];
 	int hosts[active_pathcount];
 
@@ -518,8 +517,7 @@ int mpath_prout_reg(struct multipath *mpp,int rq_servact, int rq_scope,
 				condlog (1, "%s: %s path not up. Skip.", mpp->wwid, pp->dev);
 				continue;
 			}
-			if (mpp->all_tg_pt == ALL_TG_PT_ON &&
-			    pp->sg_id.host_no != -1) {
+			if (all_tg_pt && pp->sg_id.host_no != -1) {
 				for (k = 0; k < count; k++) {
 					if (pp->sg_id.host_no == hosts[k]) {
 						condlog(3, "%s: %s host %d matches skip.", pp->wwid, pp->dev, pp->sg_id.host_no);
diff --git a/mpathpersist/main.c b/mpathpersist/main.c
index 5b37f3a..99151fe 100644
--- a/mpathpersist/main.c
+++ b/mpathpersist/main.c
@@ -118,7 +118,7 @@ int main (int argc, char * argv[])
 	{
 		int option_index = 0;
 
-		c = getopt_long (argc, argv, "v:Cd:hHioZK:S:PAT:skrGILcRX:l:",
+		c = getopt_long (argc, argv, "v:Cd:hHioYZK:S:PAT:skrGILcRX:l:",
 				long_options, &option_index);
 		if (c == -1)
 			break;
@@ -158,6 +158,10 @@ int main (int argc, char * argv[])
 				prout_flag = 1;
 				break;
 
+			case 'Y':
+				param_alltgpt = 1;
+				++num_prout_param;
+				break;
 			case 'Z':
 				param_aptpl = 1;
 				++num_prout_param;
@@ -443,9 +447,9 @@ int main (int argc, char * argv[])
 		}
 
 		if (param_alltgpt)
-			paramp->sa_flags |= 0x4;
+			paramp->sa_flags |= MPATH_F_ALL_TG_PT_MASK;
 		if (param_aptpl)
-			paramp->sa_flags |= 0x1;
+			paramp->sa_flags |= MPATH_F_APTPL_MASK;
 
 		if (num_transport)
 		{
@@ -698,6 +702,7 @@ static void usage(void)
 			"    --hex|-H                   output response in hex\n"
 			"    --in|-i                    request PR In command \n"
 			"    --out|-o                   request PR Out command\n"
+			"    --param-alltgpt|-Y         PR Out parameter 'ALL_TG_PT\n"
 			"    --param-aptpl|-Z           PR Out parameter 'APTPL'\n"
 			"    --read-keys|-k             PR In: Read Keys\n"
 			"    --param-sark=SARK|-S SARK  PR Out parameter service "
diff --git a/mpathpersist/main.h b/mpathpersist/main.h
index 5c0e089..beb8a21 100644
--- a/mpathpersist/main.h
+++ b/mpathpersist/main.h
@@ -6,6 +6,7 @@ static struct option long_options[] = {
 	{"hex", 0, NULL, 'H'},
 	{"in", 0, NULL, 'i'},
 	{"out", 0, NULL, 'o'},
+	{"param-alltgpt", 0, NULL, 'Y'},
 	{"param-aptpl", 0, NULL, 'Z'},
 	{"param-rk", 1, NULL, 'K'},
 	{"param-sark", 1, NULL, 'S'},
diff --git a/mpathpersist/mpathpersist.8 b/mpathpersist/mpathpersist.8
index a8982e6..885491d 100644
--- a/mpathpersist/mpathpersist.8
+++ b/mpathpersist/mpathpersist.8
@@ -87,6 +87,10 @@ Request PR In command.
 Request PR Out command.
 .
 .TP
+.B \--param-alltgpt|\-Y
+PR Out parameter 'ALL_TG_PT'.
+.
+.TP
 .B \--param-aptpl|\-Z
 PR Out parameter 'APTPL'.
 .
diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index e4b25a0..fb863fd 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -756,9 +756,11 @@ The default is: \fB<unset>\fR
 .
 .TP
 .B all_tg_pt
-This must be set to \fByes\fR to successfully use mpathpersist on arrays that
-automatically set and clear registration keys on all target ports from a
-host, instead of per target port per host.
+Set the 'all targets ports' flag when registering keys with mpathpersist. Some
+arrays automatically set and clear registration keys on all target ports from a
+host, instead of per target port per host. The ALL_TG_PT flag must be set to
+successfully use mpathpersist on these arrays. Setting this option is identical
+to calling mpathpersist with \fI--param-alltgpt\fR
 .RS
 .TP
 The default is: \fBno\fR
-- 
2.7.4
