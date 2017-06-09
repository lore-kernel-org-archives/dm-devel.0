From: Yang Feng <philip.yang@huawei.com>
Subject: [PATCH v5 0/1] multipath-tools: Prioritizer based on a
	latency algorithm
Date: Fri, 9 Jun 2017 17:58:25 +0800
Message-ID: <1497002306-26880-1-git-send-email-philip.yang@huawei.com>
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
To: mwilck@suse.com, hare@suse.de, christophe.varoqui@opensvc.com, bmarzins@redhat.com, xose.vazquez@gmail.com
Cc: zouming.zouming@huawei.com, guanjunxiong@huawei.com, philip.yang@huawei.com, shenhong09@huawei.com, dm-devel@redhat.com, hege09@huawei.com, qiuxin@huawei.com
List-Id: dm-devel.ids

This patch value is in the following: 
1. In the Storage-Backup environment of HyperCluster, includes
one storage array near to the host and one remote storage array,
and the two storage arrays have the same hardware.The same LUN is
writed or readed by the two storage arrays. However, usually, the
average latency of the paths of the remote storage array is much 
higher than the near storage array's. Apparently, the prioritizer
can be a good automatic solution. And the current selectors don't
solve it, IOs will send to the paths of the remote storage array,
IOPS will be influenced unavoidably.

2. In the environment of single storage array, the prioritizer can
automatically separate the paths who's latency is much higher, IOs
will not send to this paths. But the current selectors don't solve
this problem, IOPS will be influenced unavoidably.

Changes from v4:
* Argument "latency_interval" is set by using logarithmic scale, 
where base number is 10. Fix according to Martin's reviews.
* The value of "MAX_LATENCY_INTERVAL" is set 10 from 60.

Changes from v3:
* Delete Copyright time "2021", Fix according to Xose's reviews.
* Add version for GPL, Fix according to Xose's reviews.

Changes from v2:
* Reorganize the commit comment and patch format.
* Added Benjamin, Martin and Xose's Reviewed-by.

Changes from v1:
* The value of "MIN_IO_NUM" is set 2 from 10.
* Fix according to Benjamin, Martin and Xose's reviews.

Yang Feng (1):
  multipath-tools: Prioritizer based on a latency algorithm

 libmultipath/prio.h                      |   1 +
 libmultipath/prioritizers/Makefile       |   4 +
 libmultipath/prioritizers/path_latency.c | 282 +++++++++++++++++++++++++++++++
 multipath/multipath.conf.5               |  20 +++
 4 files changed, 307 insertions(+)
 create mode 100644 libmultipath/prioritizers/path_latency.c

-- 
2.6.4.windows.1
