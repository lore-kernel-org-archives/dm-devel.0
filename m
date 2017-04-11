From: Enric Balletbo i Serra <enric.balletbo@collabora.com>
Subject: [PATCH 0/5] dm: boot a mapped device without an initramfs
Date: Tue, 11 Apr 2017 17:33:39 +0200
Message-ID: <20170411153344.27092-1-enric.balletbo@collabora.com>
Return-path: <linux-doc-owner@vger.kernel.org>
Sender: linux-doc-owner@vger.kernel.org
To: Jonathan Corbet <corbet@lwn.net>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Will Drewry <wad@chromium.org>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

Hello,

Some of these patches were send few years back, I saw that first
version was send to this list in 2010, and after some reviews did not
landi [1] , apparently without any reason.

The patches has been used and working well on the ChromeOS kernel for
long time, this version is basically a rebase on top of mainline based
on latest version found in chromeos 4.4 kernel, the patches has also
been tested on a veyron device.

This a new attempt to try to land these patches again, so I'll wait
for comments/reviews and send new version to the list.

[1] Patchwork links:
    https://patchwork.kernel.org/patch/104857/
    https://patchwork.kernel.org/patch/104856/
    https://patchwork.kernel.org/patch/104858/

Best regards,
 Enric

Brian Norris (1):
  dm: move dm_table_destroy() to same header as dm_table_create()

Enric Balletbo i Serra (1):
  dm: move dm definitions outside the private header to boot dm targets.

Will Drewry (3):
  dm: export a table+mapped device to the ioctl interface
  init: add support to directly boot to a mapped device
  dm verity: add support for version 0 of the on-disk format

 Documentation/admin-guide/kernel-parameters.rst |   1 +
 Documentation/admin-guide/kernel-parameters.txt |   3 +
 Documentation/device-mapper/boot.txt            |  42 +++
 drivers/md/dm-ioctl.c                           |  39 ++
 drivers/md/dm-verity-target.c                   | 279 ++++++++++----
 drivers/md/dm.h                                 |   8 -
 include/linux/device-mapper.h                   |  19 +
 init/Makefile                                   |   1 +
 init/do_mounts.c                                |   1 +
 init/do_mounts.h                                |  10 +
 init/do_mounts_dm.c                             | 472 ++++++++++++++++++++++++
 11 files changed, 803 insertions(+), 72 deletions(-)
 create mode 100644 Documentation/device-mapper/boot.txt
 create mode 100644 init/do_mounts_dm.c

-- 
2.9.3

