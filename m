From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv3 00/14] dm-zoned: multiple drive support
Date: Fri, 29 May 2020 19:38:53 +0200
Message-ID: <20200529173907.40529-1-hare@suse.de>
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
Cc: Damien LeMoal <damien.lemoal@wdc.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

Hi all,

here's the second version of my patchset to support multiple zoned
drives with dm-zoned.
This patchset:
- Converts the zone array to using xarray for better scalability
- Separates out shared structures into per-device structure
- Enforce drive-locality for allocating and reclaiming zones
- Lifts the restriction of 2 devices to handle an arbitrary number
  of drives.

This gives me a near-perfect scalability by increasing the write
speed from 150MB/s (for a cache and one zoned drive) to 300MB/s
(for a cache and two zoned drives).

Changes to v1:
- Include reviews from Damien
- Reshuffle patches
Changes to v2:
- Add reviews from Damien
- Merge patches 'dynamic device allocation' and
  'support arbitrary number of devices'
- Fix memory leak when reading tertiary superblocks

Hannes Reinecke (14):
  dm-zoned: add debugging message for reading superblocks
  dm-zoned: secondary superblock must reside on the same devices than
    primary superblock
  dm-zoned: improve logging messages for reclaim
  dm-zoned: add a 'reserved' zone flag
  dm-zoned: convert to xarray
  dm-zoned: temporary superblock for tertiary devices
  dm-zoned: add device pointer to struct dm_zone
  dm-zoned: add metadata pointer to struct dmz_dev
  dm-zoned: per-device reclaim
  dm-zoned: move random and sequential zones into struct dmz_dev
  dm-zoned: support arbitrary number of devices
  dm-zoned: allocate zone by device index
  dm-zoned: select reclaim zone based on device index
  dm-zoned: prefer full zones for reclaim

 drivers/md/dm-zoned-metadata.c | 453 +++++++++++++++++++++++++----------------
 drivers/md/dm-zoned-reclaim.c  |  95 +++++----
 drivers/md/dm-zoned-target.c   | 169 +++++++++------
 drivers/md/dm-zoned.h          |  77 ++++---
 4 files changed, 485 insertions(+), 309 deletions(-)

-- 
2.16.4
