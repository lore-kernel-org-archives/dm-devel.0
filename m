From: Mike Anderson <andmike@linux.vnet.ibm.com>
Subject: [PATCH 0/2] dm: Add no_abort_q feature flag to dm-mpath
Date: Mon,  3 May 2010 21:01:29 -0700
Message-ID: <1272945691-31649-1-git-send-email-andmike@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
To: dm-devel@redhat.com
Cc: linux-scsi@vger.kernel.org
List-Id: dm-devel.ids

This patch series contains two patches.

1.) The first patch adds a feature flags bit field to the multipath
structure for selected features.

2.) The second patch allows a user to set a feature flag for a dm-mpath
device of "no_abort_q" to indicate that deactivate_path should not call
blk_abort_queue. I tried to select a short feature name to feature output
listed with multipath -l would not be too long "features='2 queue_if_no_path
no_abort_q'

Mike Anderson (2):
  dm: Add feature flags to dm-mpath
  dm: Add feature flag to control call to blk_abort_queue

 drivers/md/dm-mpath.c |   27 +++++++++++++++++++++++++--
 1 files changed, 25 insertions(+), 2 deletions(-)

