From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 5/5] multipath-tools: remove redundant ;
Date: Wed,  3 Aug 2016 20:14:00 +0200
Message-ID: <1470248040-11789-5-git-send-email-xose.vazquez@gmail.com>
References: <1470248040-11789-1-git-send-email-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1470248040-11789-1-git-send-email-xose.vazquez@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Cc: device-mapper development <dm-devel@redhat.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

Found by checkpatch - WARNING: Statements terminations use 1 semicolon

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 kpartx/lopart.c                 | 2 +-
 libmpathpersist/mpath_persist.c | 2 +-
 libmultipath/wwids.c            | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kpartx/lopart.c b/kpartx/lopart.c
index 5d20450..0ab1688 100644
--- a/kpartx/lopart.c
+++ b/kpartx/lopart.c
@@ -147,7 +147,7 @@ find_loop_by_file (const char * filename)
 extern char *
 find_unused_loop_device (void)
 {
-	char dev[20], *next_loop_dev = NULL;;
+	char dev[20], *next_loop_dev = NULL;
 	int fd, next_loop = 0, somedev = 0, someloop = 0, loop_known = 0;
 	struct stat statbuf;
 	struct loop_info loopinfo;
diff --git a/libmpathpersist/mpath_persist.c b/libmpathpersist/mpath_persist.c
index c5be6cd..7501651 100644
--- a/libmpathpersist/mpath_persist.c
+++ b/libmpathpersist/mpath_persist.c
@@ -642,7 +642,7 @@ int mpath_prout_rel(struct multipath *mpp,int rq_servact, int rq_scope,
 	struct path *pp = NULL;
 	int active_pathcount = 0;
 	pthread_attr_t attr;
-	int rc, found = 0;;
+	int rc, found = 0;
 	int count = 0;
 	int status = MPATH_PR_SUCCESS;
 	struct prin_resp resp;
diff --git a/libmultipath/wwids.c b/libmultipath/wwids.c
index a7c3249..babf149 100644
--- a/libmultipath/wwids.c
+++ b/libmultipath/wwids.c
@@ -273,7 +273,7 @@ out:
 int
 should_multipath(struct path *pp1, vector pathvec)
 {
-	int i, ignore_new_devs;;
+	int i, ignore_new_devs;
 	struct path *pp2;
 	struct config *conf;
 
-- 
2.7.4
