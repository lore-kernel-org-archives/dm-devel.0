From: "IKEDA, Munehiro" <m-ikeda@ds.jp.nec.com>
Subject: Re: [PATCH] IO Controller: Add per-device weight and ioprio_class
 handling
Date: Mon, 18 May 2009 18:33:40 -0400
Message-ID: <4A11E244.2000305@ds.jp.nec.com>
References: <1241553525-28095-1-git-send-email-vgoyal@redhat.com> <4A0A29B5.7030109@cn.fujitsu.com> <20090513190929.GB18371@redhat.com> <4A0BC7AB.8030703@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755528AbZERWhs@vger.kernel.org>
In-Reply-To: <4A0BC7AB.8030703@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it, jens.axboe@oracle.com, ryov@valinux.co.jp, fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp, jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, righi.andrea@gmail.com, agk@redhat.com, dm-devel@redhat.com, snitzer@redhat.com, akpm@linux-foundation.org
List-Id: dm-devel.ids

Hi Gui,

Gui Jianfeng wrote:
> Hi Vivek,
> 
> This patch enables per-cgroup per-device weight and ioprio_class handling.
> A new cgroup interface "policy" is introduced. You can make use of this 
> file to configure weight and ioprio_class for each device in a given cgroup.
> The original "weight" and "ioprio_class" files are still available. If you
> don't do special configuration for a particular device, "weight" and 
> "ioprio_class" are used as default values in this device.
> 
> You can use the following format to play with the new interface.
> #echo DEV:weight:ioprio_class > /patch/to/cgroup/policy
> weight=0 means removing the policy for DEV.
> 
> Examples:
> Configure weight=300 ioprio_class=2 on /dev/hdb in this cgroup
> # echo /dev/hdb:300:2 > io.policy
> # cat io.policy
> dev weight class
> /dev/hdb 300 2

Users can specify a device file of a partition for io.policy.
In this case, io_policy_node::dev_name is set as a name of the
partition device like /dev/sda2.

ex)
  # cd /mnt/cgroup
  # cat /dev/sda2:500:2 > io.policy
  # echo io.policy
    dev weight class
    /dev/sda2 500 2

I believe io_policy_node::dev_name should be set a generic
device name like /dev/sda.
What do you think about it?

Signed-off-by: Munehiro "Muuhh" Ikeda <m-ikeda@ds.jp.nec.com>
---
 block/elevator-fq.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/block/elevator-fq.c b/block/elevator-fq.c
index 39fa2a1..5d3d55c 100644
--- a/block/elevator-fq.c
+++ b/block/elevator-fq.c
@@ -1631,11 +1631,12 @@ static struct io_policy_node *policy_search_node(const struct io_cgroup *iocg,
 	return NULL;
 }
 
-static int devname_to_devnum(const char *buf, dev_t *dev)
+static int devname_to_devnum(char *buf, dev_t *dev)
 {
 	struct block_device *bdev;
 	struct gendisk *disk;
 	int part;
+	char *c;
 
 	bdev = lookup_bdev(buf);
 	if (IS_ERR(bdev))
@@ -1645,6 +1646,10 @@ static int devname_to_devnum(const char *buf, dev_t *dev)
 	*dev = MKDEV(disk->major, disk->first_minor);
 	bdput(bdev);
 
+	c = strrchr(buf, '/');
+	if (c)
+		strcpy(c+1, disk->disk_name);
+
 	return 0;
 }
 
-- 
1.5.4.3


-- 
IKEDA, Munehiro
  NEC Corporation of America
    m-ikeda@ds.jp.nec.com
