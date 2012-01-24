From: Joe Thornber <ejt@redhat.com>
Subject: [PATCH 0/5] [dm-thin] btree remove tweaks
Date: Tue, 24 Jan 2012 11:50:35 +0000
Message-ID: <1327405840-19750-1-git-send-email-ejt@redhat.com>
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

Here's a set of patches that do some tidying in the btree remove code and
fix an issue that caused under populated nodes.

Tested on my system, more testing required before pushing upstream.

Joe Thornber (5):
  [dm-thin] Remove redundant arg from value_ptr()
  [dm-thin] Remove 2 BUG_ONs from btree_remove code.
  [dm-thin] [btree-remove] break up __rebalance3 function.
  [dm-thin] [btree-remove] Fix bug that allowed the nr of entries in a
    btree node to drop below 1/3.
  [dm-thin] [space-map-common] Remove entries from the ref_count tree
    if they're no longer needed.

 drivers/md/persistent-data/dm-btree-internal.h   |    7 +-
 drivers/md/persistent-data/dm-btree-remove.c     |  157 ++++++++++-----------
 drivers/md/persistent-data/dm-btree.c            |   27 ++--
 drivers/md/persistent-data/dm-space-map-common.c |    3 -
 4 files changed, 90 insertions(+), 104 deletions(-)

-- 
1.7.5.4
