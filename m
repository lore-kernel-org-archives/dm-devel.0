From: Ram Pai <linuxram@us.ibm.com>
Subject: [RFC PATCH 00/16] dm-inplace-compression block device
Date: Mon, 15 Aug 2016 10:36:37 -0700
Message-ID: <1471282613-31006-1-git-send-email-linuxram@us.ibm.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: LKML <linux-kernel@vger.kernel.org>, linux-raid@vger.kernel.org, dm-devel@redhat.com, linux-doc@vger.kernel.org
Cc: shli@kernel.org, agk@redhat.com, snitzer@redhat.com, corbet@lwn.net, Ram Pai <linuxram@us.ibm.com>
List-Id: dm-devel.ids

This patch series provides a generic device-mapper inplace compression device.
Originally written by Shaohua Li.
https://www.redhat.com/archives/dm-devel/2013-December/msg00143.html

I have optimized the code and used it as a compressed swap device supporting
exterme levels of swap traffic using a NVMe device as a backend.

Comments from Alasdair have been incorporated.
https://www.redhat.com/archives/dm-devel/2013-December/msg00144.html

Testing:

This patch is tested thoroughly as a swap device on Power machine only.  More
testing is needed before it can be used as a generic compression device.

Your comments to improve the code is very much appreciated.

Ram Pai (15):
  DM: Ability to choose the compressor.
  DM: Error if enough space is not available.
  DM: Ensure that the read request is within the device range.
  DM: allocation/free helper routines.
  DM: separate out compression and decompression routines.
  DM: Optimize memory allocated to hold compressed buffer.
  DM: Tag a magicmarker at the end of each compressed segment.
  DM: Delay allocation of decompression buffer during read.
  DM: Try to use the bio buffer for decompression instead of allocating
    one.
  DM: Try to avoid temporary buffer allocation to hold compressed data.
  DM: release unneeded buffer as soon as possible.
  DM: macros to set and get the state of the request.
  DM: Wasted bio copy.
  DM: Add sysfs parameters to track total memory saved and allocated.
  DM: add documentation for dm-inplace-compress.

Shaohua Li (1):
  DM: dm-inplace-compress: a compressed DM target for SSD

 .../device-mapper/dm-inplace-compress.text         |  138 ++
 drivers/md/Kconfig                                 |    6 +
 drivers/md/Makefile                                |    1 +
 drivers/md/dm-inplace-compress.c                   | 1792 ++++++++++++++++++++
 drivers/md/dm-inplace-compress.h                   |  162 ++
 5 files changed, 2099 insertions(+)
 create mode 100644 Documentation/device-mapper/dm-inplace-compress.text
 create mode 100644 drivers/md/dm-inplace-compress.c
 create mode 100644 drivers/md/dm-inplace-compress.h

-- 
1.8.3.1

