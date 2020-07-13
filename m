From: lixiaokeng <lixiaokeng@huawei.com>
Subject: [dm-level] master - libmultipath: fix use after free
 when iscsi logs in
Date: Mon, 13 Jul 2020 10:22:11 +0800
Message-ID: <b2037975-dc52-7841-fa61-a38ec94f93a7@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
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
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Martin Wilck <mwilck@suse.com>
Cc: linfeilong@huawei.com, dm-devel@redhat.com, liuzhiqiang26@huawei.com, lutianxiong@huawei.com
List-Id: dm-devel.ids

When two iscsi ips log in and out alternately and  the following scripts run
at the same time,

#!/bin/bash
interval=5
while true
do
        iscsiadm -m node -p 9.41.147.171 &> /dev/null
        iscsiadm -m node -p 9.41.148.172 &> /dev/null
        iscsiadm -m session &> /dev/null
        rescan-scsi-bus.sh &> /dev/null
        multipath -v2 &> /dev/null
        multipath -ll &> /dev/null
        sleep $interval
done

multipathd will have a segfault after about 30 mins.

The reason is that mpp->hwe is accessed after hwe is already freed. In
extract_hwe_from_path func, mpp->hwe is set to pp->hwe, so they points to the
same hwe. For some reasons, pp->mpp will be set to NULL in orphan_path func.
Then, pp and hwe will be freed with (pp->mpp == NULL) in free_path func
called by ev_remove_path func. However, mpp->hwe is not set to NULL while hwe
is already freed. So, when iscsi device logs in and new path is added to mpp,
mpp->hwe will be accessed in select_pgfailback func. Finally, use-after-free
problem occurs.

The procedure details given as follows,
1.wait_dmevents thread
wait_dmevents
	->dmevent_loop
		->update_multipath
			->__setup_multipath
				->update_multipath_strings
					 -> sync_paths
						->orphan_path
2.uevqloop thread  (iscsi log out, remove path)
uevqloop
->uevent_dispatch
	->service_uevq
		->uev_remove_path
			->ev_remove_path  //pp->mpp is NULL
				->free_path(pp)
			//pp->hew are freed but mpp->hwe is not set to NULL
3.ev_remove_path  (iscsi log in, add path)
uevqloop
->uevent_dispatch
	->service_uevq
		->ev_add_path
			->select_pgfailback //mpp->hwe is accessed

Here, we will set mpp->hwe to NULL before setting pp->map to NULL in orphan_path
func.

Signed-off-by: Tianxiong Lu <lutianxiong@huawei.com>
Signed-off-by: lixiaokeng <lixiaokeng@huawei.com>
Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
---
 libmultipath/structs_vec.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index 3dbbaa0..9bbe5d1 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -93,6 +93,8 @@ int adopt_paths(vector pathvec, struct multipath *mpp)
 void orphan_path(struct path *pp, const char *reason)
 {
 	condlog(3, "%s: orphan path, %s", pp->dev, reason);
+	if (pp->mpp && pp->mpp->hwe == pp->hwe)
+		pp->mpp->hwe = NULL;
 	pp->mpp = NULL;
 	pp->dmstate = PSTATE_UNDEF;
 	pp->uid_attribute = NULL;
--
2.26.1
