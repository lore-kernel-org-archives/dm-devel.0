From: liuchaowei110@gmail.com
Subject: [PATCH 0/2] dm: add asymmetric stripe device driver
Date: Fri, 29 Dec 2017 20:33:58 +0800
Message-ID: <5a4636dc.5465650a.6d7db.95f2@mx.google.com>
Return-path: <linux-doc-owner@vger.kernel.org>
Sender: linux-doc-owner@vger.kernel.org
To: agk@redhat.com
Cc: snitzer@redhat.com, dm-devel@redhat.com, neilb@suse.com, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, corbet@lwn.net
List-Id: dm-devel.ids

Device-Mapper's "asm-striped" target is used to create a striped (i.e. RAID-0)
device across one or more underlying devices. Data is written in "chunks",
with consecutive chunks rotating among the underlying devices. This can
potentially provide improved I/O throughput by utilizing several physical
devices in parallel. However, in order to gain maximum I/O performance
between slow and fast device, there is a ratio to set up the chunk size
among these device.

Parameters: <num devs> <chunk size> <ratio> [<dev path> <offset>]+
<num devs>: Number of underlying devices.
<chunk size>: Size of each chunk of data. Must be at least as
large as the system's PAGE_SIZE.
<ratio>: The proportion of per io size, it is the times as much
as 1 chunk size
<dev path>: Full pathname to the underlying block-device, or a
"major:minor" device-number.
<offset>: Starting sector within the device.

 Documentation/device-mapper/asymmetric-striped.txt |  85 ++++
 drivers/md/Kconfig                                 |  11 +
 drivers/md/Makefile                                |   1 +
 drivers/md/dm-asymmetric-stripe.c                  | 556 +++++++++++++++++++++
 drivers/md/dm.c                                    |   5 +
 include/linux/device-mapper.h                      |  15 +
 6 files changed, 678 insertions(+)

