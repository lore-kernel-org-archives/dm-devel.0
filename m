From: Xinghai Yu <yuxinghai@cn.fujitsu.com>
Subject: [PATCH] move the 'update_multipath_strings()' function
	up so that mpp->mpe can be assigned in some situation
Date: Thu, 28 Nov 2013 10:12:24 +0800
Message-ID: <1385604744-16823-1-git-send-email-yuxinghai@cn.fujitsu.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: Xinghai Yu <yuxinghai@cn.fujitsu.com>, christophe.varoqui@gmail.com
List-Id: dm-devel.ids

This patch is correcting a bug about multipath's no_path_retry attribute.
When the multipath was just created by user cmd 'multipath', the DM driver 
doesn't know the wwid of this dm device, so the 'set_multipath_wwid()'
function can't get the wwid for mpp at this time, then the mpp->mpe can't befind and assigned by wwid also. In that case, the following function 
'set_no_path_retry()' can't able to use the value provided by mpp->mpe 
which values were getted from file '/etc/multipath.conf'. But the fuction 
'update_multipath_strings()' can assign the wwid to mpp from its path, so
move this function up to solve this problem.

Bug reproduce steps:
1.First, by setting 'no_path_retry fail', we have features='0'.
[root@localhost multipath-tools]# cat /etc/multipath.conf
...
	multipath {
		wwid 36000b5d0006a0000006a14e7000b0000
		alias                   yellow
		path_grouping_policy    failover
		no_path_retry		fail
	}
...
[root@localhost multipath-tools]# multipath -ll
yellow (36000b5d0006a0000006a14e7000b0000) dm-0    
size=50G features='0' hwhandler='0' wp=rw
|-+- policy='service-time 0' prio=130 status=active
| `- 0:0:0:0 sda 8:0    active ready running
`-+- policy='service-time 0' prio=130 status=enabled
  `- 1:0:0:0 sdc 8:32   active ready running
[root@localhost multipath-tools]# 

2.Second, we flush all multipath device maps.
[root@localhost multipath-tools]# multipath -F
[root@localhost multipath-tools]# 

3.Third, create all multipath device maps.
[root@localhost multipath-tools]# multipath 
create: yellow (36000b5d0006a0000006a14e7000b0000) undef    
size=50G features='0' hwhandler='0' wp=undef
|-+- policy='service-time 0' prio=130 status=undef
| `- 0:0:0:0 sda 8:0    undef ready running
`-+- policy='service-time 0' prio=130 status=undef
  `- 1:0:0:0 sdc 8:32   undef ready running
[root@localhost multipath-tools]# 

4.The end, we found "features='1 queue_if_no_path'" and this is not what we 
expect, it's a bug. After applying this patch, it can be corrected.
[root@localhost multipath-tools]# multipath -ll
yellow (36000b5d0006a0000006a14e7000b0000) dm-0    
size=50G features='1 queue_if_no_path' hwhandler='0' wp=rw
|-+- policy='service-time 0' prio=130 status=active
| `- 0:0:0:0 sda 8:0    active ready running
`-+- policy='service-time 0' prio=130 status=enabled
  `- 1:0:0:0 sdc 8:32   active ready running
[root@localhost multipath-tools]# 


Signed-off-by: Xinghai Yu <yuxinghai@cn.fujitsu.com>
---
 libmultipath/structs_vec.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index 7073915..bb2c71a 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -344,15 +344,15 @@ __setup_multipath (struct vectors * vecs, struct multipath * mpp, int reset)
 		goto out;
 	}
 
-	set_multipath_wwid(mpp);
-	mpp->mpe = find_mpe(mpp->wwid);
-	condlog(3, "%s: discover", mpp->alias);
-
 	if (update_multipath_strings(mpp, vecs->pathvec)) {
 		condlog(0, "%s: failed to setup multipath", mpp->alias);
 		goto out;
 	}
 
+	set_multipath_wwid(mpp);
+	mpp->mpe = find_mpe(mpp->wwid);
+	condlog(3, "%s: discover", mpp->alias);
+
 	if (!mpp->hwe)
 		mpp->hwe = extract_hwe_from_path(mpp);
 	if (!mpp->hwe) {
-- 
1.7.1
