From: Guan Junxiong <guanjunxiong@huawei.com>
Subject: [PATCH RFC 0/3] multipath-tools: coalesce heterogenous
	paths by referencing method
Date: Fri, 21 Jul 2017 13:07:29 +0800
Message-ID: <1500613652-9084-1-git-send-email-guanjunxiong@huawei.com>
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
To: dm-devel@redhat.com, christophe.varoqui@opensvc.com, hare@suse.de, mwilck@suse.com, bmarzins@redhat.com, xose.vazquez@gmail.com
Cc: zouming.zouming@huawei.com, chengjike.cheng@huawei.com, guanjunxiong@huawei.com, philip.yang@huawei.com, shenhong09@huawei.com, hege09@huawei.com
List-Id: dm-devel.ids

This three patches support coalescing heterogenous paths by referencing
another path identifier. This is useful in the scenario of migrating data
for heterogenous arrays without interrupting uplayer transaction.

The 1/3 patch and 2/3 patch is used to prepare for the 3/3 patch which
covers the core logic of this coalescing feature.
The 1/3 patch move generic helper _get_next_string_ to util and the helper
will be used in the 3/3 patch.However this patch can be seen as an independent
patch.
The 2/3 patch adds flags into path struct to track path internal state for
future use. With this flag, we can distinguish the referenced path and
non-referenced path in the 3/3 patch.

The usage is as follows:

The new attribute named uid_reference provides a unique path identifier
for some paths by referencing another path's identifier. Therefor those
paths can be coalesced. This is useful to migrate data for heterogenous
arrays without interrupting uplayer transaction. If you are going to let
sda, sdb and sdc use the unique path identifier of the sdd, you can add
the uid_reference field as follows into the vendor specific _devices_
section, _override_ section or the _default_ section in the multipath.conf
file.

uid_reference  "sd[a-c]  sdd"

where the first parameter which can be regular expression specifies
the target devices to be assigned with the identifier of the source device.
The second parameter is the source device to be referenced by the target
devices. The source device only supports one device.

Here is another example I use:
uid_reference "nvme[1-9]*n[0-9]*  nvme0n1"


Plese inform me if you have any idea.


Junxiong Guan (3):
  multipath-tools: move get_next_string to util
  multipath-tools: add flags to path struct to track internel state
  multipath-tools: coalesce heterogenous paths by referencing method

 libmultipath/config.c                    |  13 ++++
 libmultipath/config.h                    |   3 +
 libmultipath/dict.c                      |  11 +++
 libmultipath/discovery.c                 | 128 ++++++++++++++++++++++++++++++-
 libmultipath/discovery.h                 |  11 ++-
 libmultipath/prioritizers/weightedpath.c |  10 +--
 libmultipath/propsel.c                   |  25 ++++++
 libmultipath/structs.h                   |   2 +
 libmultipath/structs_vec.c               |   1 +
 libmultipath/util.c                      |   9 +++
 libmultipath/util.h                      |   1 +
 multipath/multipath.conf.5               |  37 ++++++++-
 multipathd/main.c                        |   4 +-
 13 files changed, 239 insertions(+), 16 deletions(-)

-- 
2.11.1
