From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH 0/4 v2] Various cleanups
Date: Thu, 16 Jul 2020 13:38:11 +0900
Message-ID: <20200716043815.605448-1-damien.lemoal@wdc.com>
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
To: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
Cc: Damien Le Moal <damien.lemoal@wdc.com>
List-Id: dm-devel.ids

Mike,

These patches fix various compilation warnings showing up when
compiling with W=1. The last patch addresses a static checker warning
(C=1 compilation). There are a lot more of these code checker warnings
remaining that probably could be addressed, some seem to be false
positive though.

Damien Le Moal (4):
  dm verity: Fix compilation warning
  dm raid: Remove empty if statement
  dm ioctl: Fix compilation warning
  dm init: Set file local variable static

 drivers/md/dm-init.c              |  2 +-
 drivers/md/dm-ioctl.c             |  2 +-
 drivers/md/dm-raid.c              |  2 --
 drivers/md/dm-verity-verify-sig.h | 14 +++++++-------
 4 files changed, 9 insertions(+), 11 deletions(-)

Changes from v1:
* Removed md patches to route them through linux-raid

-- 
2.26.2
