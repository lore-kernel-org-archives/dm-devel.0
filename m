From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 6/6] libmultipath: only add uninitialized paths
	in check_path
Date: Wed, 19 Nov 2014 00:17:39 -0600
Message-ID: <1416377859-15073-7-git-send-email-bmarzins@redhat.com>
References: <1416377859-15073-1-git-send-email-bmarzins@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1416377859-15073-1-git-send-email-bmarzins@redhat.com>
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

With find_multipaths enabled, there can be non-blacklisted paths that
are not supposed to be part of any multipath device. To make sure that
check_path doesn't keep checking them, this patch marks paths which are
fully initialized. Only uninitialized paths are checked, if they don't
belong to a multipath device.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/discovery.c | 2 ++
 libmultipath/structs.h   | 1 +
 multipathd/main.c        | 3 +++
 3 files changed, 6 insertions(+)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index af2aa20..91eab74 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -1250,6 +1250,7 @@ pathinfo (struct path *pp, vector hwtable, int mask)
 		}
 	}
 
+	pp->initialized = 1;
 	return 0;
 
 blank:
@@ -1258,6 +1259,7 @@ blank:
 	 */
 	memset(pp->wwid, 0, WWID_SIZE);
 	pp->chkrstate = pp->state = PATH_DOWN;
+	pp->initialized = 0;
 
 	return 0;
 }
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index 15e7e19..abd1c29 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -186,6 +186,7 @@ struct path {
 	struct checker checker;
 	struct multipath * mpp;
 	int fd;
+	int initialized;
 
 	/* configlet pointers */
 	struct hwentry * hwe;
diff --git a/multipathd/main.c b/multipathd/main.c
index e697897..5da31bb 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1124,6 +1124,9 @@ check_path (struct vectors * vecs, struct path * pp)
 	int chkr_new_path_up = 0;
 	int oldchkrstate = pp->chkrstate;
 
+	if (pp->initialized && !pp->mpp)
+		return 0;
+
 	if (pp->tick && --pp->tick)
 		return 0; /* don't check this path yet */
 
-- 
1.8.3.1
