From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 18/42] Check return code from pathinfo()
Date: Tue,  8 Jan 2013 14:53:56 +0100
Message-ID: <1357653259-62650-19-git-send-email-hare@suse.de>
References: <1357653259-62650-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1357653259-62650-1-git-send-email-hare@suse.de>
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

Pathinfo might fail, which indicates that the path is not
available anymore. So check the return value and take
appropriate action.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/discovery.c   |    2 +-
 libmultipath/structs_vec.c |    6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index e328332..b5df8e3 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -680,7 +680,7 @@ path_offline (struct path * pp)
 	return PATH_DOWN;
 }
 
-extern int
+int
 sysfs_pathinfo(struct path * pp)
 {
 	if (common_sysfs_pathinfo(pp))
diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index d914435..6d36d58 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -68,9 +68,9 @@ adopt_paths (vector pathvec, struct multipath * mpp, int get_info)
 			if (!find_path_by_dev(mpp->paths, pp->dev) &&
 			    store_path(mpp->paths, pp))
 					return 1;
-			if (get_info)
-				pathinfo(pp, conf->hwtable,
-					 DI_PRIO | DI_CHECKER);
+			if (get_info && pathinfo(pp, conf->hwtable,
+						 DI_PRIO | DI_CHECKER))
+				return 1;
 		}
 	}
 	return 0;
-- 
1.7.4.2
