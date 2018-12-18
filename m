From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 10/19] libmultipath: restore PG prio in
	update_multipath_strings
Date: Wed, 19 Dec 2018 00:19:22 +0100
Message-ID: <20181218231931.10762-11-mwilck@suse.com>
References: <20181218231931.10762-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20181218231931.10762-1-mwilck@suse.com>
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
Cc: Martin Wilck <mwilck@suse.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

update_multipath_strings() destroys and recreates the
pathgroup vector. This wipes information previously
stored. Restore the path group priorities.

Fixes: efc7407bed65 "libmultipath: don't update path groups when
 printing"
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/structs_vec.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index 03e2b978..db5d19da 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -18,6 +18,7 @@
 #include "configure.h"
 #include "libdevmapper.h"
 #include "io_err_stat.h"
+#include "switchgroup.h"
 
 /*
  * creates or updates mpp->paths reading mpp->pg
@@ -261,6 +262,9 @@ void sync_paths(struct multipath *mpp, vector pathvec)
 int
 update_multipath_strings(struct multipath *mpp, vector pathvec, int is_daemon)
 {
+	struct pathgroup *pgp;
+	int i;
+
 	if (!mpp)
 		return 1;
 
@@ -278,6 +282,10 @@ update_multipath_strings(struct multipath *mpp, vector pathvec, int is_daemon)
 	if (update_multipath_status(mpp))
 		return 1;
 
+	vector_foreach_slot(mpp->pg, pgp, i)
+		if (pgp->paths)
+			path_group_prio_update(pgp);
+
 	return 0;
 }
 
-- 
2.19.2
