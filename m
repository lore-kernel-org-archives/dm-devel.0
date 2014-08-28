From: Vasily Tarasov <tarasov@vasily.name>
Subject: [PATCH RFCv2 00/10] dm-dedup: device-mapper
	deduplication target
Date: Thu, 28 Aug 2014 18:48:28 -0400
Message-ID: <53ffb64b.257e320a.6ec4.2b61@mx.google.com>
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
Cc: Joe Thornber <thornber@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Christoph Hellwig <hch@infradead.org>, Philip Shilane <philip.shilane@emc.com>, Sonam Mandal <sonam.dp42@gmail.com>, Erez Zadok <ezk@fsl.cs.sunysb.edu>
List-Id: dm-devel.ids

This is a second request for comments for dm-dedup.

Updates compared to the first submission:

- code is updated to kernel 3.16
- construction parameters are now positional (as in other targets)
- documentation is extended and brought to the same format as in other targets

Dm-dedup is a device-mapper deduplication target.  Every write coming to the
dm-dedup instance is deduplicated against previously written data.  For
datasets that contain many duplicates scattered across the disk (e.g.,
collections of virtual machine disk images and backups) deduplication provides
a significant amount of space savings.

To quickly identify duplicates, dm-dedup maintains an index of hashes for all
written blocks.  A block is a user-configurable unit of deduplication with a
recommended block size of 4KB.  dm-dedup's index, along with other
deduplication metadata, resides on a separate block device, which we refer to
as a metadata device.  Although the metadata device can be on any block
device, e.g., an HDD or its own partition, for higher performance we recommend
to use SSD devices to store metadata.

Dm-dedup is designed to support pluggable metadata backends.  A metadata
backend is responsible for storing metadata: LBN-to-PBN and HASH-to-PBN
mappings, allocation maps, and reference counters.  (LBN: Logical Block
Number, PBN: Physical Block Number).  Currently we implemented "cowbtree" and
"inram" backends.  The cowbtree uses device-mapper persistent API to store
metadata.  The inram backend stores all metadata in RAM as a hash table.

Detailed design is described here:

http://www.fsl.cs.sunysb.edu/docs/ols-dmdedup/dmdedup-ols14.pdf

Our preliminary experiments on real traces demonstrate that Dmdedup can even
exceed the performance of a disk drive running ext4.  The reasons are that (1)
deduplication reduces I/O traffic to the data device, and (2) Dmdedup
effectively sequentializes random writes to the data device.

Dmdedup is developed by a joint group of researchers from Stony Brook
University, Harvey Mudd College, and EMC.  See the documentation patch for
more details.

Vasily Tarasov (10):
  dm-dedup: main data structures
  dm-dedup: core deduplication logic
  dm-dedup: hash computation
  dm-dedup: implementation of the read-on-write procedure
  dm-dedup: COW B-tree backend
  dm-dedup: inram backend
  dm-dedup: Makefile changes
  dm-dedup: Kconfig changes
  dm-dedup: status function
  dm-dedup: documentation

 Documentation/device-mapper/dedup.txt |  205 +++++++
 drivers/md/Kconfig                    |    8 +
 drivers/md/Makefile                   |    2 +
 drivers/md/dm-dedup-backend.h         |  114 ++++
 drivers/md/dm-dedup-cbt.c             |  755 ++++++++++++++++++++++++++
 drivers/md/dm-dedup-cbt.h             |   44 ++
 drivers/md/dm-dedup-hash.c            |  145 +++++
 drivers/md/dm-dedup-hash.h            |   30 +
 drivers/md/dm-dedup-kvstore.h         |   51 ++
 drivers/md/dm-dedup-ram.c             |  580 ++++++++++++++++++++
 drivers/md/dm-dedup-ram.h             |   43 ++
 drivers/md/dm-dedup-rw.c              |  248 +++++++++
 drivers/md/dm-dedup-rw.h              |   19 +
 drivers/md/dm-dedup-target.c          |  946 +++++++++++++++++++++++++++++++++
 drivers/md/dm-dedup-target.h          |  100 ++++
 15 files changed, 3290 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/device-mapper/dedup.txt
 create mode 100644 drivers/md/dm-dedup-backend.h
 create mode 100644 drivers/md/dm-dedup-cbt.c
 create mode 100644 drivers/md/dm-dedup-cbt.h
 create mode 100644 drivers/md/dm-dedup-hash.c
 create mode 100644 drivers/md/dm-dedup-hash.h
 create mode 100644 drivers/md/dm-dedup-kvstore.h
 create mode 100644 drivers/md/dm-dedup-ram.c
 create mode 100644 drivers/md/dm-dedup-ram.h
 create mode 100644 drivers/md/dm-dedup-rw.c
 create mode 100644 drivers/md/dm-dedup-rw.h
 create mode 100644 drivers/md/dm-dedup-target.c
 create mode 100644 drivers/md/dm-dedup-target.h
