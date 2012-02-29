From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 00/13] dm thin: updated patches for 3.4
Date: Wed, 29 Feb 2012 09:50:04 -0500
Message-ID: <1330527017-28618-1-git-send-email-snitzer@redhat.com>
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
Cc: snitzer@redhat.com
List-Id: dm-devel.ids

I've reviewed all but one of these patches quite closely (didn't go
crazy on the held root patch).

I've taken care to make sure the patches include relevant fixes that
were made after Joe's previous submission to dm-devel.

This patchset will bring the upstream dm thinp code up to Joe's
thin-dev commit f1f8676ecdf366.

Heinz Mauelshagen (1):
  dm thin: pre-commit in pool_status so it provides accurate free block counts

Joe Thornber (12):
  dm thin: tidy up the cell_release functions
  dm btree-remove: break up __rebalance3 function
  dm btree remove: remove 2 BUG_ONs from __rebalance2 function
  dm btree remove: fix bug that allowed the nr of entries in a btree node to drop below 1/3
  dm btree remove: fix center node entry redistribution in redistribute3 function
  dm space map: remove entries from the ref_count tree if no longer needed
  dm thin: don't use the bi_next field for the holder of a cell
  dm thin: add support for external origins
  dm thin: held root support
  dm thin: foundation for discard support
  dm thin: add discard support
  dm thin: add discard pool features

 Documentation/device-mapper/thin-provisioning.txt |   51 ++-
 drivers/md/dm-thin-metadata.c                     |   78 +++-
 drivers/md/dm-thin-metadata.h                     |    1 +
 drivers/md/dm-thin.c                              |  577 ++++++++++++++++-----
 drivers/md/persistent-data/dm-btree-remove.c      |  174 ++++---
 drivers/md/persistent-data/dm-space-map-common.c  |    3 -
 6 files changed, 675 insertions(+), 209 deletions(-)
