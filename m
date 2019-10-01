From: Heinz Mauelshagen <heinzm@redhat.com>
Subject: [PATCH 0/4] dm raid: fix raid set extensions not being
	synchronized
Date: Tue,  1 Oct 2019 17:47:51 +0200
Message-ID: <cover.1569888100.git.heinzm@redhat.com>
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
To: heinzm@redhat.com, dm-devel@redhat.com, snitzer@redhat.com
List-Id: dm-devel.ids

This patch series fixes flaws causing raid set extensions not to be
synchronized in case a grown MD bitmap has to allocate additional pages.

When a raid set's grown, additional pages in the MD write-intent bitmap
may have to be allocated as a result.  Because so far no md_bitmap_resize()
occurs in that process, additional new regions (aka MD bitmap chunks) aren't
set dirty during creation, thus they fail to be synchronized.  Solve by
using md_bitmap_resize() in raid set size extensions to ensure dirtying
of additional, new regions.

Also address another flaw causing new regions not to be synchronized
after a raid set size reduction followed by an extension and streamline
recovery setup and progress status functions.  

Passes all lvm2 test suite RAID tests.


Heinz Mauelshagen (4):
  dm raid: change rs_set_dev_and_array_sectors API and callers
  dm raid: to ensure resynchronization, perform raid set grow in preresume
  dm raid: simplify rs_setup_recovery call chain
  dm raid: streamline rs_get_progress() and its raid_status() caller side

 .../admin-guide/device-mapper/dm-raid.rst     |   2 +
 drivers/md/dm-raid.c                          | 168 ++++++++++--------
 2 files changed, 91 insertions(+), 79 deletions(-)

-- 
2.21.0
