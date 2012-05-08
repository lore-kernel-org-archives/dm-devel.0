From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v2 0/5] dm mpath: add 'default_hw_handler' and
	'no_partitions' features
Date: Tue,  8 May 2012 17:56:02 -0400
Message-ID: <1336514167-15393-1-git-send-email-snitzer@redhat.com>
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
Cc: babu.moger@netapp.com, Mike Snitzer <snitzer@redhat.com>, agk@redhat.com
List-Id: dm-devel.ids

I've included all related patches in this v2 post simply to eliminate
any confusion with all the patches that have been in-flight from
Hannes and I.  Patches 1 and 2 are unchanged from previous posts.

Patch 4 is the combination of the different approaches Hannes and I
took.  I pushed the 'no_partitions' feature patch (5) to the end of
the series because it seemed more natural.

Hannes Reinecke (2):
  dm mpath: add 'default_hw_handler' feature
  dm mpath: add ability to disable partition creation

Mike Snitzer (3):
  dm mpath: only try to load the scsi_dh module if the scsi_dh doesn't exist
  scsi_dh: add scsi_dh_attached_handler_name
  dm mpath: reduce size of multipath structure

 drivers/md/dm-mpath.c                 |   53 +++++++++++++++++++++++++-------
 drivers/scsi/device_handler/scsi_dh.c |   31 ++++++++++++++++++-
 include/scsi/scsi_dh.h                |    5 +++
 3 files changed, 75 insertions(+), 14 deletions(-)

-- 
1.7.4.4
