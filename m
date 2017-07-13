From: Yang Feng <philip.yang@huawei.com>
Subject: [PATCH 0/2] multipath-tools/libmultipath: Support for
	the native NVMe Ioctl command and add args min_avg_latency
	for path_latency.
Date: Thu, 13 Jul 2017 15:51:26 +0800
Message-ID: <1499932288-15420-1-git-send-email-philip.yang@huawei.com>
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
Cc: zouming.zouming@huawei.com, chengjike.cheng@huawei.com, guanjunxiong@huawei.com, philip.yang@huawei.com, shenhong09@huawei.com, hege09@huawei.com
List-Id: dm-devel.ids

1. The SCSI-to-NVMe translations have been removed in the patch "nvme:
Remove SCSI translations" in the linux-nvme, so the native NVMe Ioctl
command should be supported in the multipath-tools.
   In the prioritizers/path_latency.c, modify the func do_readsector0():
send a native NVMe Read Ioctl command to the nvme device, and send a SG
Read Ioctl command to the scsi device.
   In the checkers, delete the file tur.c and create the new file ping.c:
ping.c can support the native NVMe Keep Alive Ioctl command to the nvme
device, and can support the SG TUR Ioctl command to the scsi device.
2. Add args min_avg_latency of logarithmic scale, for prioritizers/
path_latency.c. Min average latency is not constant 1us, and can be set
by user. Certainly, max average latency value is still constant 100s.
It make support better for more scenes, because it can deal better with
the normal standard deviation of path latency.
   For example, when the standard deviation value is 200us and the average
latency of the normal paths is 1ms, args base_num can be set to 5 and args
min_avg_latency can be set to 2ms, so the paths will be grouped in priority
groups with path latency <=2ms, (2ms, 10ms], (10ms, 50ms], etc.

Yang Feng (1):
  multipath-tools/libmultipath: Support for the native NVMe Ioctl command
and add args min_avg_latency for path_latency.

 libmultipath/checkers.c                  |   7 +
 libmultipath/checkers.h                  |   6 +-
 libmultipath/checkers/Makefile           |   6 +-
 libmultipath/checkers/emc_clariion.c     |   4 +-
 libmultipath/checkers/libsg.c            |  94 -------
 libmultipath/checkers/libsg.h            |   9 -
 libmultipath/checkers/ping.c             | 453 +++++++++++++++++++++++++++++++
 libmultipath/checkers/readsector0.c      |   4 +-
 libmultipath/checkers/tur.c              | 427 -----------------------------
 libmultipath/checkers/tur.h              |   8 -
 libmultipath/defaults.h                  |   2 +-
 libmultipath/discovery.c                 |   1 +
 libmultipath/hwtable.c                   |   2 +-
 libmultipath/libnvme.c                   | 130 +++++++++
 libmultipath/libnvme.h                   |  10 +
 libmultipath/libsg.c                     | 113 ++++++++
 libmultipath/libsg.h                     |  13 +
 libmultipath/prioritizers/Makefile       |   2 +-
 libmultipath/prioritizers/path_latency.c |  95 ++++---
 libmultipath/propsel.c                   |   2 +-
 multipath/multipath.conf.5               |  18 +-
 21 files changed, 821 insertions(+), 585 deletions(-)
 delete mode 100644 libmultipath/checkers/libsg.c
 delete mode 100644 libmultipath/checkers/libsg.h
 create mode 100644 libmultipath/checkers/ping.c
 delete mode 100644 libmultipath/checkers/tur.c
 delete mode 100644 libmultipath/checkers/tur.h
 create mode 100644 libmultipath/libnvme.c
 create mode 100644 libmultipath/libnvme.h
 create mode 100644 libmultipath/libsg.c
 create mode 100644 libmultipath/libsg.h

-- 
2.6.4.windows.1
