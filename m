From: Keith Busch <keith.busch@intel.com>
Subject: [PATCHv2 0/5] nvme/dm failover unification
Date: Tue,  9 Jan 2018 12:04:13 -0700
Message-ID: <20180109190418.7123-1-keith.busch@intel.com>
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: Linux Block <linux-block@vger.kernel.org>, Linux NVMe <linux-nvme@lists.infradead.org>, Device Mapper <dm-devel@redhat.com>, Christoph Hellwig <hch@lst.de>, Mike Snitzer <snitzer@redhat.com>, Jens Axboe <axboe@kernel.dk>
Cc: Bart VanAssche <bart.vanassche@wdc.com>, James Smart <james.smart@broadcom.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.com>, Sagi Grimberg <sagi@grimberg.me>, Keith Busch <keith.busch@intel.com>
List-Id: dm-devel.ids

Native nvme multipath provided a separate NVMe status decoder,
complicating maintenance as new statuses need to be accounted for. This
was already diverging from the generic nvme status decoder, which has
implications for other components that rely on accurate generic block
errors.

This series unifies common code among nvme and device-mapper multipath
so user experience regarding the failover fate of a command is the same.

v1 -> v2:

  Fixed blk_status_t used for NVME_SC_LBA_RANGE.

  Fixed line break formatting.

  Changed name of new block API for path related errors and added kernel
  doc for it. 

  Added reviews and acks.

Keith Busch (5):
  nvme: Add more command status translation
  nvme/multipath: Consult blk_status_t for failover
  block: Provide blk_status_t decoding for path errors
  nvme/multipath: Use blk_path_error
  dm mpath: Use blk_path_error

 drivers/md/dm-mpath.c         | 19 ++-----------------
 drivers/nvme/host/core.c      | 16 ++++++++++++----
 drivers/nvme/host/multipath.c | 44 ++-----------------------------------------
 drivers/nvme/host/nvme.h      |  5 +++--
 include/linux/blk_types.h     | 28 +++++++++++++++++++++++++++
 5 files changed, 47 insertions(+), 65 deletions(-)

-- 
2.13.6
