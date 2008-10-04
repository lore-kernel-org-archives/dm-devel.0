From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [PATCH 0/2] scsi: export busy state for request stacking drivers
Date: Sat, 04 Oct 2008 14:03:50 -0400 (EDT)
Message-ID: <20081004.140350.74754456.k-ueda@ct.jp.nec.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, dm-devel@redhat.com, j-nomura@ce.jp.nec.com, k-ueda@ct.jp.nec.com
List-Id: dm-devel.ids

Hi James,

The following patches export busy-status of SCSI LLD to request-based
dm-multipath for proper I/O scheduling.
The patches are created on the following commit of scsi-post-merge-2.6.
---------------------------------------------------------------
commit 454f40af9f0d4cda1c89e1fc0028d5235b150bc7
Author: Mike Christie <michaelc@cs.wisc.edu>
Date:   Wed Sep 24 11:46:15 2008 -0500

    libiscsi: fix locking in iscsi_eh_device_reset
---------------------------------------------------------------

The changes from the previous version (*) is to check the busy state
everytime instead of using a cached flag inside scsi.

Summary of the patches:
  1/2: scsi: refactor sdev/starget/shost busy checking
  2/2: scsi: export busy state via q->lld_busy_fn()

Please review and apply.

Thanks,
Kiyoshi Ueda
