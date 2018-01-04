From: Keith Busch <keith.busch@intel.com>
Subject: [PATCH 0/5] Failover criteria unification
Date: Thu,  4 Jan 2018 15:46:18 -0700
Message-ID: <20180104224623.8944-1-keith.busch@intel.com>
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: Linux Block <linux-block@vger.kernel.org>, Linux NVMe <linux-nvme@lists.infradead.org>, Device Mapper <dm-devel@redhat.com>, Christoph Hellwig <hch@lst.de>, Mike Snitzer <snitzer@redhat.com>, Jens Axboe <axboe@kernel.dk>
Cc: Bart VanAssche <bart.vanassche@wdc.com>, James Smart <james.smart@broadcom.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.com>, Sagi Grimberg <sagi@grimberg.me>, Keith Busch <keith.busch@intel.com>
List-Id: dm-devel.ids

The nvme native multipath provided a separate NVMe status decoder,
complicating maintenance as new statuses need to be accounted for. This
was already diverging from the generic nvme status decoder, which has
implications for other components that rely on accurate generic block
errors.

This series unifies common code among nvme and device-mapper multipath
so that user experience regarding the failover fate of a command is the
same.

Mike:

I split this up because I thought there'd be trouble merging the dm
mpath update with the inverted retry logic, but I think you may have
rebased the dm-4.16 without that patch, as I'm not seeing it in the most
current branch.

Keith Busch (5):
  nvme: Add more command status translation
  nvme/multipath: Consult blk_status_t for failover
  block: Provide blk_status_t decoding for retryable errors
  nvme/multipath: Use blk_retryable
  dm mpath: Use blk_retryable

 drivers/md/dm-mpath.c         | 19 ++-----------------
 drivers/nvme/host/core.c      | 15 +++++++++++----
 drivers/nvme/host/multipath.c | 44 ++-----------------------------------------
 drivers/nvme/host/nvme.h      |  4 ++--
 include/linux/blk_types.h     | 16 ++++++++++++++++
 5 files changed, 33 insertions(+), 65 deletions(-)

-- 
2.13.6
