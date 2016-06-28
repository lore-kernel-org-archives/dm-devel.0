From: Toshi Kani <toshi.kani-ZPxbGqLxI0U@public.gmane.org>
Subject: [PATCH 0/2] Support DAX for device-mapper dm-linear devices
Date: Tue, 28 Jun 2016 13:37:14 -0600
Message-ID: <1467142636-21094-1-git-send-email-toshi.kani@hpe.com>
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
To: snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: dm-devel.ids

I noticed that dm-snap reloads DM table of target mapped-device, which
fails for dax-capable device after dax support is added.  Ideally,
adding dax support to dm-snap solves the issue, but it cannot be done
easily.  This patch-set allows dm-snap to work with dax-capable target
devices when bio-based operation is used.

dax operation is unsupported with dm-snap, such that:
 a) After snapshot is taken, mount with dax option to a target device
    or a snapshot device fails.  They can be mounted without dax.
 b) After snapshot is taken to a dax-mounted target device, any writes 
    to the target device fails (EIO).

b) can be protected by changing lvcreate to fail when snapshot is
requested to a dax-mounted target device. 

- Patch 1 solves an error when lvremove is made to a snapshot device.
- Patch 2 solves an error when lvcreate --snapshot is made to a dax-
  capable device.

---
Toshi Kani (2):
 1/2 dm: update table type check for dax
 2/2 dm snap: add fake origin_direct_access

---
 drivers/md/dm-ioctl.c | 11 ++++++++++-
 drivers/md/dm-snap.c  |  8 ++++++++
 2 files changed, 18 insertions(+), 1 deletion(-)
