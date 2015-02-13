From: heinzm@redhat.com
Subject: [PATCH 0/3] md raid: enhancements to support the device
	mapper dm-raid target
Date: Fri, 13 Feb 2015 19:48:05 +0100
Message-ID: <1423853288-6278-1-git-send-email-heinzm@redhat.com>
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
Cc: Heinz Mauelshagen <heinzm@redhat.com>
List-Id: dm-devel.ids

From: Heinz Mauelshagen <heinzm@redhat.com>

I'm enhancing the device mapper raid target (dm-raid) to take
advantage of so far unused md raid kernel funtionality:
takeover, reshape, resize, addition and removal of devices to/from raid sets.

This series of patches remove constraints doing so.


Patch #1:
add 2 API functions to allow dm-raid to access the raid takeover
and resize functionality (namely md_takeover() and md_resize());
reshape APIs are not needed in lieu of the existing personalilty ones

Patch #2:
because device mapper core manages a request queue per mapped device
utilizing the md make_request API to pass on bios via the dm-raid target,
no md instance underneath it needs to manage a request queue of its own.
Thus dm-raid can't use the md raid0 personality as is, because the latter
accesses the request queue unconditionally in 3 places via mddev->queue
which this patch addresses.

Patch #3:
when dm-raid processes a down takeover to raid0, it needs to destroy
any existing bitmap, because raid0 does not require one. The patch
exports the bitmap_destroy() API to allow dm-raid to remove bitmaps.


Heinz Mauelshagen (3):
  md core:   add 2 API functions for takeover and resize to support dm-raid
  md raid0:  access mddev->queue (request queue member) conditionally
             because it is not set when accessed from dm-raid
  md bitmap: export bitmap_destroy() to support dm-raid down takover to raid0

 drivers/md/bitmap.c |  1 +
 drivers/md/md.c     | 39 ++++++++++++++++++++++++++++++---------
 drivers/md/md.h     |  3 +++
 drivers/md/raid0.c  | 48 +++++++++++++++++++++++++++---------------------
 4 files changed, 61 insertions(+), 30 deletions(-)

-- 
2.1.0
