From: Enric Balletbo i Serra <enric.balletbo@collabora.com>
Subject: [PATCH v7 0/2] dm: boot a mapped device without an initramfs
Date: Thu, 18 May 2017 18:29:09 +0200
Message-ID: <20170518162911.15538-1-enric.balletbo@collabora.com>
Return-path: <linux-doc-owner@vger.kernel.org>
Sender: linux-doc-owner@vger.kernel.org
To: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

Dear all,

So here is a new version of the patches to be reviewed, this time as
suggested by Alasdair the patches are reworked to match with the new
dmsetup bootformat feature [1]. These patches are not reviewed yet but
the format was discussed in the IRC and was suggested to send the
kernel patches in parallel.

Changes since v6:
 - Add a new function to issue the equivalent of a DM ioctl programatically.
 - Use the new ioctl interface to create the devices.
 - Use a comma-delimited and semi-colon delimited dmsetup-like commands.

Changes since v5:
 - https://www.redhat.com/archives/dm-devel/2016-February/msg00112.html

[1] https://www.redhat.com/archives/linux-lvm/2017-May/msg00047.html

Wating for your feedback,

Enric Balletbo i Serra (1):
  dm ioctl: add a device mapper ioctl function.

Will Drewry (1):
  init: add support to directly boot to a mapped device

 Documentation/admin-guide/kernel-parameters.rst |   1 +
 Documentation/admin-guide/kernel-parameters.txt |   3 +
 Documentation/device-mapper/dm-boot.txt         |  65 ++++
 drivers/md/dm-ioctl.c                           |  45 +++
 include/linux/device-mapper.h                   |   6 +
 init/Makefile                                   |   1 +
 init/do_mounts.c                                |   1 +
 init/do_mounts.h                                |  10 +
 init/do_mounts_dm.c                             | 459 ++++++++++++++++++++++++
 9 files changed, 591 insertions(+)
 create mode 100644 Documentation/device-mapper/dm-boot.txt
 create mode 100644 init/do_mounts_dm.c

-- 
2.9.3

