From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv4 00/13] dm-zoned: metadata version 2
Date: Mon, 20 Apr 2020 12:08:11 +0200
Message-ID: <20200420100824.124618-1-hare@suse.de>
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
To: Mike Snitzer <snitzer@redhat.com>
Cc: Damien LeMoal <damien.lemoal@wdc.com>, Bob Liu <bob.liu@oracle.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

Hi all,

this patchset adds a new metadata version 2 for dm-zoned, which brings the
following improvements:
- UUIDs and labels: Adding three more fields to the metadata containing
  the dm-zoned device UUID and label, and the device UUID. This allows
  for an unique identification of the devices, so that several dm-zoned
  sets can coexist and have a persistent identification.
- Extend random zones by an additional regular disk device: A regular
  block device can be added together with the zoned block device, providing
  additional (emulated) random write zones. With this it's possible to
  handle sequential zones only devices; also there will be a speed-up if
  the regular block device resides on a fast medium. The regular block device
  is placed logically in front of the zoned block device, so that metadata
  and mapping tables reside on the regular block device, not the zoned device.
- Tertiary superblock support: In addition to the two existing sets of metadata
  another, tertiary, superblock is written to the first block of the zoned
  block device. This superblock is for identification only; the generation
  number is set to '0' and the block itself it never updated. The additional
  metadate like bitmap tables etc are not copied.

To handle this, some changes to the original handling are introduced:
- Zones are now equidistant. Originally, runt zones were ignored, and
  not counted when sizing the mapping tables. With the dual device setup
  runt zones might occur at the end of the regular block device, making
  direct translation between zone number and sector/block number complex.
  For metadata version 2 all zones are considered to be of the same size,
  and runt zones are simply marked as 'offline' to have them ignored when
  allocating a new zone.
- The block number in the superblock is now the global number, and refers to
  the location of the superblock relative to the resulting device-mapper
  device. Which means that the tertiary superblock contains absolute block
  addresses, which needs to be translated to the relative device addresses
  to find the referenced block.

There is an accompanying patchset for dm-zoned-tools for writing and checking
this new metadata.

As usual, comments and reviews are welcome.

Changes to v3:
- Reorder devices such that the regular device is always at position 0,
  and the zoned device is always at position 1.
- Split off dmz_dev_is_dying() into a separate patch
- Include reviews from Damien

Changes to v2:
- Kill dmz_id()
- Include reviews from Damien
- Sanitize uuid handling as suggested by John Dorminy


Hannes Reinecke (13):
  dm-zoned: add 'status' and 'message' callbacks
  dm-zoned: store zone id within the zone structure and kill dmz_id()
  dm-zoned: use array for superblock zones
  dm-zoned: store device in struct dmz_sb
  dm-zoned: move fields from struct dmz_dev to dmz_metadata
  dm-zoned: introduce dmz_metadata_label() to format device name
  dm-zoned: Introduce dmz_dev_is_dying() and dmz_check_dev()
  dm-zoned: remove 'dev' argument from reclaim
  dm-zoned: replace 'target' pointer in the bio context
  dm-zoned: use dmz_zone_to_dev() when handling metadata I/O
  dm-zoned: add metadata logging functions
  dm-zoned: ignore metadata zone in dmz_alloc_zone()
  dm-zoned: metadata version 2

 drivers/md/dm-zoned-metadata.c | 658 +++++++++++++++++++++++++++++++----------
 drivers/md/dm-zoned-reclaim.c  |  88 +++---
 drivers/md/dm-zoned-target.c   | 331 +++++++++++++--------
 drivers/md/dm-zoned.h          |  33 ++-
 4 files changed, 780 insertions(+), 330 deletions(-)

-- 
2.16.4
