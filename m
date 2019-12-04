From: Nikos Tsironis <ntsironis@arrikto.com>
Subject: [PATCH 0/2] dm thin: Flush data device before committing
	metadata to avoid data corruption
Date: Wed,  4 Dec 2019 16:07:40 +0200
Message-ID: <20191204140742.26273-1-ntsironis@arrikto.com>
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
Cc: thornber@redhat.com, ntsironis@arrikto.com
List-Id: dm-devel.ids

The thin provisioning target maintains per thin device mappings that map
virtual blocks to data blocks in the data device.

When we write to a shared block, in case of internal snapshots, or
provision a new block, in case of external snapshots, we copy the shared
block to a new data block (COW), update the mapping for the relevant
virtual block and then issue the write to the new data block.

Suppose the data device has a volatile write-back cache and the
following sequence of events occur:

1. We write to a shared block
2. A new data block is allocated
3. We copy the shared block to the new data block using kcopyd (COW)
4. We insert the new mapping for the virtual block in the btree for that
   thin device.
5. The commit timeout expires and we commit the metadata, that now
   includes the new mapping from step (4).
6. The system crashes and the data device's cache has not been flushed,
   meaning that the COWed data are lost.

The next time we read that virtual block of the thin device we read it
from the data block allocated in step (2), since the metadata have been
successfully committed. The data are lost due to the crash, so we read
garbage instead of the old, shared data.

Moreover, apart from internal and external snapshots, the same issue
exists for newly provisioned blocks, when block zeroing is enabled.
After the system recovers the provisioned blocks might contain garbage
instead of zeroes.

For more information regarding the implications of this please see the
relevant commit.

To solve this and avoid the potential data corruption we have to flush
the pool's data device before committing its metadata.

This ensures that the data blocks of any newly inserted mappings are
properly written to non-volatile storage and won't be lost in case of a
crash.

Nikos Tsironis (2):
  dm thin metadata: Add support for a pre-commit callback
  dm thin: Flush data device before committing metadata

 drivers/md/dm-thin-metadata.c | 29 +++++++++++++++++++++++++++++
 drivers/md/dm-thin-metadata.h |  7 +++++++
 drivers/md/dm-thin.c          | 32 ++++++++++++++++++++++++++++++++
 3 files changed, 68 insertions(+)

-- 
2.11.0
