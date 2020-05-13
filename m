From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 0/2] dm-zoned: improve cache performance
Date: Wed, 13 May 2020 09:07:27 +0200
Message-ID: <20200513070729.71461-1-hare@suse.de>
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

here are two patches to improve performance when a regular device
is specified for dm-zoned.
Damien noted that we have a performance drop after the zones on the
regular device are used up, as then the random zones on the zoned
device are being used, _and_ reclaim is running on the same disk.
This slows down I/O whle using random zones, increasing again after
the random zones are used up.
This patchset fixes this by not allowing random zones for caching
if a regular device is present.

Patch is relative to the dm-5.8 branch from
git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git

As usual, comments and reviews are welcome.


Hannes Reinecke (2):
  dm-zoned: invert zone check in dmz_reset_zone()
  dm-zoned: split off random and cache zones

 .../admin-guide/device-mapper/dm-zoned.rst    |  17 +-
 drivers/md/dm-zoned-metadata.c                | 157 +++++++++++++-----
 drivers/md/dm-zoned-reclaim.c                 |  70 ++++----
 drivers/md/dm-zoned-target.c                  |  19 ++-
 drivers/md/dm-zoned.h                         |   7 +-
 5 files changed, 189 insertions(+), 81 deletions(-)

-- 
2.25.0
