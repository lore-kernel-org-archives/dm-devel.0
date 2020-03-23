From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH RFC 0/2] dm-zoned: add cache device
Date: Mon, 23 Mar 2020 16:03:50 +0100
Message-ID: <20200323150352.107826-1-hare@suse.de>
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
Cc: dm-devel@redhat.com, Johannes Thumshirn <jth@kernel.org>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

Hi Damien,

as my original plan to upgrade bcache to work for SMR devices
turned out to be more complex than anticipated I went for the
simpler approach and added a 'cache' device for dm-zoned.
It is using a normal device (eg '/dev/pmem0' :-), split it
into zones of the same size of the original SMR device, and
makes those 'virtual' zones avialable to dm-zoned in a similar
manner than the existing 'random write' zoned.

The implementation is still a bit rough (one would need to add
metadata to the cache device, too), but so far it seems to work
quite well; still running after copying 300GB of data back and forth.

As usual, comments and reviews are welcome.

Hannes Reinecke (2):
  dm-zoned: cache device for zones
  dm-zoned: add 'status' and 'message' callbacks

 drivers/md/dm-zoned-metadata.c | 189 +++++++++++++++++++++++++++++----
 drivers/md/dm-zoned-reclaim.c  |  76 ++++++++++---
 drivers/md/dm-zoned-target.c   | 159 ++++++++++++++++++++++++---
 drivers/md/dm-zoned.h          |  34 +++++-
 4 files changed, 407 insertions(+), 51 deletions(-)

-- 
2.25.0
