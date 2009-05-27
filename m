From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 0/3] dm table: alignment and topology support
Date: Wed, 27 May 2009 17:06:50 -0400
Message-ID: <1243458413-15854-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: martin.petersen@oracle.com, agk@redhat.com, jens.axboe@oracle.com
List-Id: dm-devel.ids

The first 2 patches refresh what has already been in linux-next (from
Alasdair's DM quilt tree).  The last patch builds on Martin Peterson's
topology work that has been added to Jens' linux-2.6-block.git
for-next tree.

I have published a quilt tree that builds on 2.6.30-rc7 here:
http://people.redhat.com/msnitzer/patches/dm-topology/

Mike Snitzer (3):
  dm-table-ensure-targets-are-aligned-to-logical_block_size
  dm-table-validate-device-logical_block_size
  dm-topology-support

 drivers/md/dm-table.c         |  261 ++++++++++++++++++++++++-----------------
 include/linux/device-mapper.h |   16 +---
 2 files changed, 156 insertions(+), 121 deletions(-)
