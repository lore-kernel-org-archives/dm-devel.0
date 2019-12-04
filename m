From: Nikos Tsironis <ntsironis@arrikto.com>
Subject: [PATCH 0/3] dm clone: Flush destination device before
	committing metadata to avoid data corruption
Date: Wed,  4 Dec 2019 16:06:51 +0200
Message-ID: <20191204140654.26214-1-ntsironis@arrikto.com>
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
To: snitzer@redhat.com, agk@redhat.com, dm-devel@redhat.com
Cc: vkoukis@arrikto.com, ntsironis@arrikto.com, iliastsi@arrikto.com
List-Id: dm-devel.ids

dm-clone maintains an on-disk bitmap which records which regions are
valid in the destination device, i.e., which regions have already been
hydrated, or have been written to directly, via user I/O.

Setting a bit in the on-disk bitmap meas the corresponding region is
valid in the destination device and we redirect all I/O regarding it to
the destination device.

Suppose the destination device has a volatile write-back cache and the
following sequence of events occur:

1. A region gets hydrated, either through the background hydration or
   because it was written to directly, via user I/O.

2. The commit timeout expires and we commit the metadata, marking that
   region as valid in the destination device.

3. The system crashes and the destination device's cache has not been
   flushed, meaning the region's data are lost.

The next time we read that region we read it from the destination
device, since the metadata have been successfully committed, but the
data are lost due to the crash, so we read garbage instead of the old
data.

For more information regarding the implications of this please see the
relevant commit.

To solve this and avoid the potential data corruption we have to flush
the destination device before committing the metadata.

This ensures that any freshly hydrated regions, for which we commit the
metadata, are properly written to non-volatile storage and won't be lost
in case of a crash.

Nikos Tsironis (3):
  dm clone metadata: Track exact changes per transaction
  dm clone metadata: Use a two phase commit
  dm clone: Flush destination device before committing metadata

 drivers/md/dm-clone-metadata.c | 136 ++++++++++++++++++++++++++++++-----------
 drivers/md/dm-clone-metadata.h |  17 ++++++
 drivers/md/dm-clone-target.c   |  53 +++++++++++++---
 3 files changed, 162 insertions(+), 44 deletions(-)

-- 
2.11.0
