From: Huaisheng Ye <yehs2007-ytc+IHgoah0@public.gmane.org>
Subject: [RFC PATCH v2 0/3] realize dax_operations for dm-snapshot
Date: Wed, 21 Nov 2018 11:26:59 +0800
Message-ID: <20181121032702.3048-1-yehs2007@zoho.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, zwisler-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, jack-AlSwsSmVLrQ@public.gmane.org, dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, vishal.l.verma-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, chengnt-6jq1YtArVR3QT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: dm-devel.ids

From: Huaisheng Ye <yehs1-6jq1YtArVR3QT0dZR+AlfA@public.gmane.org>

Changes
v1->v2:
	Add NULL funtions for origin_dax_direct_access and
	origin_dax_copy_from/to_iter in order to avoid building
	error when CONFIG_DAX_DRIVER has NOT been enabled.

[v1]: https://lkml.org/lkml/2018/11/20/759

This series patches are used to realize the dax_operations for dm-snapshot
with persistent memory device.

Here are the steps about how to verify the function.

1. Configure the persistent memory to fs-dax mode and create namespace with ndctl;
2. find them in /dev;
  # ndctl list
  {
    "dev":"namespace0.0",
    "mode":"fsdax",
    "map":"dev",
    "size":132118478848,
    "sector_size":512,
    "blockdev":"pmem0",
    "name":"yhs_pmem0",
    "numa_node":0
  },
3. create lv_pmem (here is 4G size) for testing;
   # pvcreate /dev/pmem0
   # vgcreate vg_pmem /dev/pmem0
   # lvcreate  -L 4G -n lv_pmem vg_pmem
4. create filesystem (ext2 or ext4) to /dev/pmem0
   # mkfs.ext2 -b 4096 /dev/vg_pmem/lv_pmem
5. mount pmem with DAX way;
   # mkdir /mnt/lv_pmem
   # mount -o dax /dev/vg_pmem/lv_pmem /mnt/lv_pmem/
6. cp some files to /mnt/lv_pmem;
   # cp linear_table03.log /mnt/lv_pmem/
   # cp test0.log /mnt/lv_pmem/
7. create snapshot for test (here I limit it to 1G size);
   # lvcreate -L 1G -n snap_pmem -s /dev/vg_pmem/lv_pmem
8. modify the files copied with vim or copy more other new files;
   # vim /mnt/lv_pmem/test0.log
9. umount the pmem device;
   # umount /mnt/lv_pmem/
10.merge the snapshot back to origin;
   # lvconvert --merge /dev/vg_pmem/snap_pmem
11.mount pmem device again for checking the content of files;
   # mount -o dax /dev/vg_pmem/lv_pmem /mnt/lv_pmem/

Huaisheng Ye (3):
  dm: enable dax_operations for dm-snapshot
  dm: expand hc_map in mapped_device for lack of map
  dm: expand valid types for dm-ioctl

 drivers/md/dm-core.h  |  1 +
 drivers/md/dm-ioctl.c |  4 +++-
 drivers/md/dm-snap.c  | 51 +++++++++++++++++++++++++++++++++++++++++++++++++--
 drivers/md/dm.c       | 15 +++++++++++++++
 4 files changed, 68 insertions(+), 3 deletions(-)

-- 
1.8.3.1
