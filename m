From: mwilck@suse.com
Subject: [PATCH 44/54] libmultipath: adopt_paths(): don't bail
	out on single path failure
Date: Thu,  9 Jul 2020 12:36:13 +0200
Message-ID: <20200709103623.8302-3-mwilck@suse.com>
References: <20200709103623.8302-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200709103623.8302-1-mwilck@suse.com>
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

If pathinfo fails for one path to be adopted, we currently
fail the entire function. This may cause ev_add_path() for a valid
path to fail because some other path is broken. Fix it by just
skipping paths that don't look healthy.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/structs_vec.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index 55fca9b..bc47d1e 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -75,16 +75,20 @@ int adopt_paths(vector pathvec, struct multipath *mpp)
 			if (!mpp->paths && !(mpp->paths = vector_alloc()))
 				return 1;
 
-			if (!find_path_by_devt(mpp->paths, pp->dev_t) &&
-			    store_path(mpp->paths, pp))
-					return 1;
 			conf = get_multipath_config();
 			pthread_cleanup_push(put_multipath_config, conf);
 			ret = pathinfo(pp, conf,
 				       DI_PRIO | DI_CHECKER);
 			pthread_cleanup_pop(1);
-			if (ret)
-				return 1;
+			if (ret) {
+				condlog(3, "%s: pathinfo failed for %s",
+					__func__, pp->dev);
+				continue;
+			}
+
+			if (!find_path_by_devt(mpp->paths, pp->dev_t) &&
+			    store_path(mpp->paths, pp))
+					return 1;
 		}
 	}
 	return 0;
-- 
2.26.2
