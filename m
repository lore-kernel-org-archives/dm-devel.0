From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH RFC 00/12] dm-zoned: multi-device support
Date: Fri, 22 May 2020 17:38:49 +0200
Message-ID: <20200522153901.133375-1-hare@suse.de>
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
To: Damien LeMoal <damien.lemoal@wdc.com>
Cc: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

Hi all,

on the risk of boring you to death, here's yet another RFC to update
dm-zoned. As it has seen only light testing and has some areas which
need to be improved I'd consider it RFC material.
I'm just putting it out now to get some feedback and get it ready for
the next merge window.

So, this patchset:
- Converts the zone array to using xarray for better scalability
- Separate out shared structures into per-device structure
- Lift the restriction of 2 devices to handle an arbitrary number
  of drives.

With this patchset I'm seeing a performance increase for writes from
an average of 150MB/s (with 2 drives) to 200MB/s (with 3 drives).

Hannes Reinecke (12):
  dm-zoned: add debugging message for reading superblocks
  dm-zoned: convert to xarray
  dm-zoned: use on-stack superblock for tertiary devices
  dm-zoned: secondary superblock must reside on the same devices than
    primary superblock
  dm-zoned: add device pointer to struct dm_zone
  dm-zoned: add metadata pointer to struct dmz_dev
  dm-zoned: add a 'reserved' zone flag
  dm-zoned: move random and sequential zones into struct dmz_dev
  dm-zoned: improve logging messages for reclaim
  dm-zoned: support arbitrary number of devices
  dm-zoned: round-robin load balancer for reclaiming zones
  dm-zoned: per-device reclaim

 drivers/md/dm-zoned-metadata.c | 430 ++++++++++++++++++++++++-----------------
 drivers/md/dm-zoned-reclaim.c  |  85 ++++----
 drivers/md/dm-zoned-target.c   | 172 ++++++++++-------
 drivers/md/dm-zoned.h          |  70 ++++---
 4 files changed, 454 insertions(+), 303 deletions(-)

-- 
2.16.4
