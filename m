From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 0/4] libmultipath: Fixes for NVME / NVMEoF
Date: Tue, 18 Jul 2017 09:29:12 +0200
Message-ID: <20170718072916.24275-1-mwilck@suse.com>
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
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Bart Van Assche <Bart.VanAssche@sandisk.com>, Benjamin Marzinski <bmarzins@redhat.com>, Hannes Reinecke <hare@suse.de>, Guan Junxiong <guanjunxiong@huawei.com>
Cc: Martin Wilck <mwilck@suse.de>, dm-devel@redhat.com, Xose Vazquez Perez <xose.vazquez@gmail.com>, linux-nvme@lists.infradead.org, tang.junhui@zte.com.cn
List-Id: dm-devel.ids

Current code fails to set up multipath maps for NVME devices in a
Linux target/Linux host combination. This series enables at least
basic operation.

Patch 1/4 fixes a crash that happens if over-long WWIDs are encountered, and
is not specific to NVME as such. Patch 2/4 drops
the broken test uevent_can_discard_by_devpath(). Patch 3/4 compensates
for the additional event processing required by 2/4. Patch 4/4 mangles
overlong "nvme.*" WWIDs to make them usable for multipath (related discussion
in [1]; WWID_SIZE can't be simply increased because it has to match
device mapper's DM_NAME_LEN).

Changes wrt v1:
 1/4: assure 0-termination by using strlcpy() (Bart van Assche)
 4/4: drop extra length test (Ben Marzinski)

I kept the v1 Reviewed-by: and Acked-by tags because the changes are minor,
I hope that's ok for the reviewers.

[1] http://lists.infradead.org/pipermail/linux-nvme/2017-July/011960.html

Martin Wilck (4):
  libmultipath: get_udev_uid: make sure pp->wwid is 0-terminated
  libmultipath: drop uevent_can_discard_by_devpath
  libmultipath: only listen for uevents with DEVTYPE=disk
  libmultipath: fix over-long NVME WWIDs

 libmultipath/discovery.c | 85 +++++++++++++++++++++++++++++++++++++++++++++---
 libmultipath/uevent.c    | 27 +--------------
 2 files changed, 82 insertions(+), 30 deletions(-)

-- 
2.13.2
