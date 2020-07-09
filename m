From: mwilck@suse.com
Subject: [PATCH 32/35] libmultipath: log table params in addmap()
Date: Thu,  9 Jul 2020 12:16:17 +0200
Message-ID: <20200709101620.6786-33-mwilck@suse.com>
References: <20200709101620.6786-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200709101620.6786-1-mwilck@suse.com>
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

We currently log the table parameters with "load table" in domap()
in the success case. But it's at least as interesting to get this
information when domap() fails. Log in addmap() instead at v2 level.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/configure.c | 2 +-
 libmultipath/devmapper.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index fe590f4..315eb6a 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -992,7 +992,7 @@ int domap(struct multipath *mpp, char *params, int is_daemon)
 		} else  {
 			/* multipath daemon mode */
 			mpp->stat_map_loads++;
-			condlog(2, "%s: load table [0 %llu %s %s]", mpp->alias,
+			condlog(4, "%s: load table [0 %llu %s %s]", mpp->alias,
 				mpp->size, TGT_MPATH, params);
 			/*
 			 * Required action is over, reset for the stateful daemon.
diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 4096e9d..a177a54 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -395,7 +395,7 @@ dm_addmap (int task, const char *target, struct multipath *mpp,
 	if (mpp->attribute_flags & (1 << ATTR_GID) &&
 	    !dm_task_set_gid(dmt, mpp->gid))
 		goto freeout;
-	condlog(4, "%s: %s [0 %llu %s %s]", mpp->alias,
+	condlog(2, "%s: %s [0 %llu %s %s]", mpp->alias,
 		task == DM_DEVICE_RELOAD ? "reload" : "addmap", mpp->size,
 		target, params);
 
-- 
2.26.2
