From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 19/21] libmultipath: coalesce_paths: improve
	logging of orphaned paths
Date: Fri, 12 Oct 2018 00:27:05 +0200
Message-ID: <20181011222707.3631-20-mwilck@suse.com>
References: <20181011222707.3631-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20181011222707.3631-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/configure.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index 09c3dcf2..ed3e30f5 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -1020,14 +1020,18 @@ int coalesce_paths (struct vectors * vecs, vector newmp, char * refwwid,
 		}
 	}
 	vector_foreach_slot (pathvec, pp1, k) {
-		int invalid = 0;
+		int invalid;
 		/* skip this path for some reason */
 
 		/* 1. if path has no unique id or wwid blacklisted */
+		if (strlen(pp1->wwid) == 0) {
+			orphan_path(pp1, "no WWID");
+			continue;
+		}
+
 		conf = get_multipath_config();
 		pthread_cleanup_push(put_multipath_config, conf);
-		if (strlen(pp1->wwid) == 0 || filter_path(conf, pp1) > 0)
-			invalid = 1;
+		invalid = (filter_path(conf, pp1) > 0);
 		pthread_cleanup_pop(1);
 		if (invalid) {
 			orphan_path(pp1, "blacklisted");
-- 
2.19.0
