From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 53/78] Use strlen() when checking for valid wwid
Date: Mon, 16 Mar 2015 13:36:40 +0100
Message-ID: <1426509425-15978-54-git-send-email-hare@suse.de>
References: <1426509425-15978-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1426509425-15978-1-git-send-email-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@gmail.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

The wwid is required to be a string, so we should be using
strlen() when checking for a valid WWID.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/configure.c | 5 +----
 multipathd/main.c        | 3 +--
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index ddbd3ed..ef217de 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -734,7 +734,6 @@ coalesce_paths (struct vectors * vecs, vector newmp, char * refwwid, int force_r
 {
 	int r = 1;
 	int k, i;
-	char empty_buff[WWID_SIZE];
 	char params[PARAMS_SIZE];
 	struct multipath * mpp;
 	struct path * pp1;
@@ -742,8 +741,6 @@ coalesce_paths (struct vectors * vecs, vector newmp, char * refwwid, int force_r
 	vector curmp = vecs->mpvec;
 	vector pathvec = vecs->pathvec;
 
-	memset(empty_buff, 0, WWID_SIZE);
-
 	/* ignore refwwid if it's empty */
 	if (refwwid && !strlen(refwwid))
 		refwwid = NULL;
@@ -757,7 +754,7 @@ coalesce_paths (struct vectors * vecs, vector newmp, char * refwwid, int force_r
 		/* skip this path for some reason */
 
 		/* 1. if path has no unique id or wwid blacklisted */
-		if (memcmp(empty_buff, pp1->wwid, WWID_SIZE) == 0 ||
+		if (strlen(pp1->wwid) == 0 ||
 		    filter_path(conf, pp1) > 0) {
 			orphan_path(pp1, "wwid blacklisted");
 			continue;
diff --git a/multipathd/main.c b/multipathd/main.c
index 2d527df..b86e3b6 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -482,7 +482,6 @@ int
 ev_add_path (struct path * pp, struct vectors * vecs)
 {
 	struct multipath * mpp;
-	char empty_buff[WWID_SIZE] = {0};
 	char params[PARAMS_SIZE] = {0};
 	int retries = 3;
 	int start_waiter = 0;
@@ -491,7 +490,7 @@ ev_add_path (struct path * pp, struct vectors * vecs)
 	/*
 	 * need path UID to go any further
 	 */
-	if (memcmp(empty_buff, pp->wwid, WWID_SIZE) == 0) {
+	if (strlen(pp->wwid) == 0) {
 		condlog(0, "%s: failed to get path uid", pp->dev);
 		goto fail; /* leave path added to pathvec */
 	}
-- 
1.8.4.5
