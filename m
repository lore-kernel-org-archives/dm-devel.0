From: lixiaokeng <lixiaokeng@huawei.com>
Subject: [PATCH V3 12/14] libmultipathpersist: use
 update_multipath_table/status in get_mpvec
Date: Tue, 8 Sep 2020 16:53:11 +0800
Message-ID: <8c63f729-b7f0-be38-6f8c-2dbb5e0ad6fc@huawei.com>
References: <2fb59aa1-eafa-49b6-08aa-a279565ec234@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <2fb59aa1-eafa-49b6-08aa-a279565ec234@huawei.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Content-Language: en-GB
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Martin Wilck <mwilck@suse.com>, Benjamin Marzinski <bmarzins@redhat.com>, dm-devel
	mailing list <dm-devel@redhat.com>
Cc: linfeilong <linfeilong@huawei.com>, "liuzhiqiang (I)" <liuzhiqiang26@huawei.com>
List-Id: dm-devel.ids

The return values of dm_get_map, disassemble_map in get_mpvec
were not checked. Use update_multipath_table/status to instead
of them.

V1->V2: delete continue and add remove_map

Signed-off-by: Lixiaokeng <lixiaokeng@huawei.com>
Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
Signed-off-by: Linfeilong <linfeilong@huawei.com>
---
 libmpathpersist/mpath_persist.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/libmpathpersist/mpath_persist.c b/libmpathpersist/mpath_persist.c
index e7256049..1f9817ed 100644
--- a/libmpathpersist/mpath_persist.c
+++ b/libmpathpersist/mpath_persist.c
@@ -323,7 +323,6 @@ get_mpvec (vector curmp, vector pathvec, char * refwwid)
 {
 	int i;
 	struct multipath *mpp;
-	char params[PARAMS_SIZE], status[PARAMS_SIZE];

 	vector_foreach_slot (curmp, mpp, i){
 		/*
@@ -341,14 +340,12 @@ get_mpvec (vector curmp, vector pathvec, char * refwwid)
 		if (refwwid && strncmp (mpp->alias, refwwid, WWID_SIZE - 1))
 			continue;

-		dm_get_map(mpp->alias, &mpp->size, params);
-		condlog(3, "params = %s", params);
-		dm_get_status(mpp->alias, status);
-		condlog(3, "status = %s", status);
-		disassemble_map (pathvec, params, mpp);
-		update_pathvec_from_dm(pathvec, mpp, DI_CHECKER);
-		disassemble_status (status, mpp);
-
+		if (update_multipath_table(mpp, pathvec, DI_CHECKER) != DMP_OK ||
+		    update_multipath_status(mpp) != DMP_OK) {
+			condlog(1, "error parsing map %s", mpp->wwid);
+			remove_map(mpp, pathvec, curmp, PURGE_VEC);
+			i--;
+		}
 	}
 	return MPATH_PR_SUCCESS ;
 }
-- 
