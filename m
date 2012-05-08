From: Hannes Reinecke <hare@suse.de>
Subject: [RFC] [PATCH 0/3] dm-multipath: New features
Date: Tue,  8 May 2012 16:18:04 +0200
Message-ID: <1336486687-31535-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
Cc: Babu Moger <babu.moger@netapp.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

This patchset implements two new features, 'no_partitions'
and 'default_hw_handler'.
The 'no_partition' feature is just a marker for kpartx
to not attempt partitions scanning on these devices.

The 'default_hw_handler' feature allows for a 'default'
hardware handler. Problem is that multipath-tools only has
a static setting for the hardware handler of a device. The
kernel, however, is able to distinguish between various
possible hardware handler and might already have attached
a different one.
So by specifying the feature 'default_hw_handler'
the dm-multipath module is instructed to use the
currently selected one, and not the one specified
during table creation.

This is an alternative implementation to Mike Snitzers
'default' hardware handler implementation.

Hannes Reinecke (3):
  scsi_dh: Allow NULL hardware handler name in scsi_dh_attach()
  dm-multipath: disable partition scan feature
  dm-multipath: 'default_hw_handler' feature

 drivers/md/dm-mpath.c                 |   36 ++++++++++++++++++++++++++++++--
 drivers/scsi/device_handler/scsi_dh.c |    8 +++++-
 2 files changed, 39 insertions(+), 5 deletions(-)
