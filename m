From: lixiaokeng <lixiaokeng@huawei.com>
Subject: [PATCH 3/5] multipathd: add reclear_pp_from_mpp in
	ev_remove_path
Date: Tue, 18 Aug 2020 21:08:27 +0800
Message-ID: <8fd64929-cb4b-5267-1899-15a82e2ff678@huawei.com>
References: <5ef5f58e-3a27-8959-3abb-4b4c401cc309@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <5ef5f58e-3a27-8959-3abb-4b4c401cc309@huawei.com>
Content-Language: en-GB
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>, Martin Wilck <mwilck@suse.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>, dm-devel@redhat.com
Cc: linfeilong@huawei.com, liuzhiqiang26@huawei.com
List-Id: dm-devel.ids

Add reclear_pp_from_mpp in ev_remove_path to make sure that pp is cleared in mpp.

When multipathd del path xxx, multipathd -v2, multipathd add path xxx and multipath -U
dm-x are executed simultaneously, multipath -U dm-x will case coredump.

The reason is that there are two paths with same dev_t in dm_table. The process
is as follows:

multipathd del path xxx(such as sde whose dev_t is 8:64):

cli_del_path
	->ev_remove_path
		->domap //dm_table in kernel will be reloaded and doesn't contain 8:64.
		        //Then multipath -v2 is executed, and the dm_table in kernel
		        //will be reloaded and contains 8:64.
		->setup_multipath
			->update_multipath_strings
				->update_multipath_table
					->dm_get_map //get params with 8:64
					->disassemble_map //pp1 will be saved mpp->pg
		->delete pp1 in pathvec
		->clear_ref_from_mpp //pp is cleared in mpp->paths but still saved in
		                     //mpp->pg
		->free_paths //pp1 is freed but still exist in mpp->pg

multipathd add path sde
cli_add_path
	->store_pathinfo //alloc pp2 (dev_t is 8:64), and store it to gvecs->pathvec
	->ev_add_path
		->adopt_paths
			->update_mpp_paths //pp1 is found in mpp->pg and its dev_t is
			                   //8:64 and dev is not sde (cased by free).
			                   //it will be stored in mpp->paths.
			->pp2 is stored to mpp->paths
		->setup_map //params with two 8:64
		->domap //dm_table is reloaded and contains two 8:64

multipath -U dm-x(sde is one path of dm-x)
main
	->check_usable_paths
		->dm_get_maps //get params with two 8:64
		->disassemble_map //alloc pp3, and pp3 is saved twice in mpp->pg
		->free_multipath(mpp, FREE_PATHS) //double free

Here, we add that pp1 in mpp->pg is cleared in clear_ref_from_mpp.

Reported-by: Tianxiong Lu <lutianxiong@huawei.com>
Signed-off-by: lixiaokeng <lixiaokeng@huawei.com>
Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
---
 multipathd/main.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/multipathd/main.c b/multipathd/main.c
index 9ec65856..a1db17a0 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1059,6 +1059,32 @@ fail:
 	return 1;
 }

+static
+void reclear_pp_from_mpp(struct path * pp, struct vectors * vecs)
+{
+	struct multipath * mpp = NULL;
+	struct pathgroup * pgp;
+	int i = -1;
+	int j = 0;
+	int is_log = 0;
+
+	mpp = find_mp_by_wwid(vecs->mpvec, pp->wwid);
+	if(!!mpp) {
+		if ((i = find_slot(mpp->paths, (void *)pp)) != -1) {
+			vector_del_slot(mpp->paths, i);
+			is_log = 1;
+		}
+		vector_foreach_slot (mpp->pg, pgp, j) {
+			if ((i = find_slot(pgp->paths, (void *)pp)) != -1) {
+				vector_del_slot(pgp->paths, i);
+				is_log = 1;
+			}
+		}
+		if (is_log)
+			condlog(2, "%s: reclear path from mpp %s", pp->dev, mpp->alias);
+	}
+}
+
 static int
 uev_remove_path (struct uevent *uev, struct vectors * vecs, int need_do_map)
 {
@@ -1186,6 +1212,7 @@ out:
 	if ((i = find_slot(vecs->pathvec, (void *)pp)) != -1)
 		vector_del_slot(vecs->pathvec, i);

+	reclear_pp_from_mpp(pp, vecs);
 	free_path(pp);

 	return retval;
-- 
