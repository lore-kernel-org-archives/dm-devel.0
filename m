From: Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 0/4] multipath-patches for 0.8.2
Date: Tue, 9 Jul 2019 07:39:59 +0000
Message-ID: <20190709073909.32112-1-martin.wilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, Martin Wilck <Martin.Wilck@suse.com>
List-Id: dm-devel.ids

From: Martin Wilck <mwilck@suse.com>

Hi Christophe,

as you requested, I'm resending the recent kpartx/DASD patch on top of
0.8.2. I'm resending 3 other previously posted patches, too. First and
foremost, Ben's "vector_foreach_slot_backwards" patch. The last two
have not been acked by Ben, or otherwise reviewed, yet.

Benjamin Marzinski (1):
  libmultipath: make vector_foreach_slot_backwards work as expected

Martin Wilck (3):
  kpartx: recognize DASD on loop devices again
  multipath-tools (coverity): assert availability of CLOCK_MONOTONIC
  libmultipath: trigger uevents for partitions, too

 kpartx/dasd.c               |  7 ++++---
 libmultipath/checkers/tur.c |  6 +++---
 libmultipath/configure.c    | 38 +++++++++++++++++++++++++++++++++++++
 libmultipath/time-util.c    |  9 +++++++++
 libmultipath/time-util.h    |  1 +
 libmultipath/vector.h       |  2 +-
 multipathd/main.c           | 34 +++++++++++++--------------------
 multipathd/uxlsnr.c         |  8 +++-----
 8 files changed, 72 insertions(+), 33 deletions(-)

-- 
2.22.0
