From: Nikos Tsironis <ntsironis@arrikto.com>
Subject: [PATCH 0/4] dm clone: Fix discard handling and overflow
	bugs which could cause data corruption
Date: Fri, 27 Mar 2020 16:01:07 +0200
Message-ID: <20200327140111.7798-1-ntsironis@arrikto.com>
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
To: agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com
Cc: ntsironis@arrikto.com
List-Id: dm-devel.ids

There is a bug in the way dm-clone handles partial region discards,
which can lead to discarding the wrong blocks or trying to discard
blocks beyond the end of the device.

This could lead to data corruption, if the destination device indeed
discards the underlying blocks, i.e., if the discard operation results
in the original contents of a block to be lost.

The bug manifests when we try to discard part of a single region, i.e.,
when we try to discard a block with size < region_size, and the discard
request both starts at an offset with respect to the beginning of that
region and ends before the end of the region.

The root of the bug is the code that calculates the range of regions
covered by a discard request and decides which regions to discard.

For more information, please see the relevant commit.

As part of fixing this bug, I also audited dm-clone for other
arithmetic/overflow related bugs and found the following:

1. Missing overflow check for the total number of regions
2. Missing casts when converting from regions to sectors
3. Wrong return type of dm_clone_nr_of_hydrated_regions(), which caused
   an unwanted sign extension to occur.

Again, more information can be found in the relevant commits.

Nikos Tsironis (4):
  dm clone: Fix handling of partial region discards
  dm clone: Add overflow check for number of regions
  dm clone: Add missing casts to prevent overflows and data corruption
  dm clone metadata: Fix return type of
    dm_clone_nr_of_hydrated_regions()

 drivers/md/dm-clone-metadata.c | 15 +++++++++-
 drivers/md/dm-clone-metadata.h |  2 +-
 drivers/md/dm-clone-target.c   | 66 ++++++++++++++++++++++++++++++------------
 3 files changed, 62 insertions(+), 21 deletions(-)

-- 
2.11.0
