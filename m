From: lixiaokeng <lixiaokeng@huawei.com>
Subject: [PATCH 13/14] multipath: use
 update_multipath_table/status in, check_useable_paths
Date: Wed, 2 Sep 2020 15:25:28 +0800
Message-ID: <78021dc0-bede-f376-b450-40dd5522786b@huawei.com>
References: <37544d4c-950f-4281-3b66-e4d1884c5167@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <37544d4c-950f-4281-3b66-e4d1884c5167@huawei.com>
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
To: Martin Wilck <mwilck@suse.com>, Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>, dm-devel mailing list <dm-devel@redhat.com>
Cc: linfeilong <linfeilong@huawei.com>, "liuzhiqiang (I)" <liuzhiqiang26@huawei.com>
List-Id: dm-devel.ids

The return values of dm_get_map, disassemble_map,dm_get_status
and disassemble_status in check_usable_paths were not checked.
Use update_multipath_table/status to instead of them.

Signed-off-by: Lixiaokeng <lixiaokeng@huawei.com>
Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
Signed-off-by: Linfeilong <linfeilong@huawei.com>
---
 multipath/main.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/multipath/main.c b/multipath/main.c
index d227e0b3..9e920d89 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -251,7 +251,6 @@ static int check_usable_paths(struct config *conf,
 	struct path *pp;
 	char *mapname;
 	vector pathvec = NULL;
-	char params[PARAMS_SIZE], status[PARAMS_SIZE];
 	dev_t devt;
 	int r = 1, i, j;

@@ -285,11 +284,9 @@ static int check_usable_paths(struct config *conf,
 	if (mpp == NULL)
 		goto free;

-	dm_get_map(mpp->alias, &mpp->size, params);
-	dm_get_status(mpp->alias, status);
-	disassemble_map(pathvec, params, mpp);
-	update_pathvec_from_dm(pathvec, mpp, 0);
-	disassemble_status(status, mpp);
+	if (update_multipath_table(mpp, pathvec, 0) != DMP_OK ||
+		    update_multipath_status(mpp) != DMP_OK)
+		    goto free;

 	vector_foreach_slot (mpp->pg, pg, i) {
 		vector_foreach_slot (pg->paths, pp, j) {
-- 
