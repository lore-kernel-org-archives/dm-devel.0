From: Joe Thornber <ejt@redhat.com>
Subject: [PATCH 00/11] Latest dm-thin patches
Date: Thu,  2 Feb 2012 16:39:03 +0000
Message-ID: <1328200754-13642-1-git-send-email-ejt@redhat.com>
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
Cc: Joe Thornber <ejt@redhat.com>
List-Id: dm-devel.ids

Clean patches that merge together various fixes in the thin-dev tree.

Joe Thornber (11):
  Unlock the superblock on an error path for new metadata dev creation.
  Remove redundant arg from value_ptr()
  [dm-thin] [bio prison] Don't use the bi_next field for the holder of
    a cell.
  [dm-thin] dm_thin_remove_block() wasn't decrementing the
    mapped_blocks counter.
  [dm-thin] btree-remove - fix rebalancing of 3 nodes.
  Remove entries from the ref_count tree if they're no longer needed.
  [dm-thin] Commit every second to prevent too much of a position
    building up.
  [dm-thin] Add support for external origins.
  [dm-thin] Discard support part 1
  [dm-thin] Add support for REQ_DISCARD
  [dm-thin] some tidy ups of the __open_device() error path (Mike
    Snitzer)

 Documentation/device-mapper/thin-provisioning.txt |   38 ++-
 drivers/md/dm-thin-metadata.c                     |   25 +-
 drivers/md/dm-thin.c                              |  442 ++++++++++++++++-----
 drivers/md/persistent-data/dm-btree-internal.h    |    7 +-
 drivers/md/persistent-data/dm-btree-remove.c      |  202 ++++++----
 drivers/md/persistent-data/dm-btree.c             |   27 +-
 drivers/md/persistent-data/dm-space-map-common.c  |    3 -
 7 files changed, 531 insertions(+), 213 deletions(-)

-- 
1.7.5.4
