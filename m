From: Gabriel Krisman Bertazi <krisman@collabora.com>
Subject: [PATCH v2 0/3] Historical Service Time Path Selector
Date: Mon, 27 Apr 2020 20:51:43 -0400
Message-ID: <20200428005146.242231-1-krisman@collabora.com>
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
To: agk@redhat.com, snitzer@redhat.com
Cc: dm-devel@redhat.com, kernel@collabora.com, Gabriel Krisman Bertazi <krisman@collabora.com>, khazhy@google.com
List-Id: dm-devel.ids

Hi Mike,

Please find an updated version of HST integrating the change you
requested to also support BIO based multipath.  I hope you don't mind me
folding the function you implemented into patch 2.  If you prefer, I can
integrate a patch you provide into the series.

One interesting data point is that the selection performance on
BIO-based is worse when compared to request-based.  I tested a bit and I
believe the reason is that the paths are more sticky because the bucket
is too large, and it takes longer for HST to detect differences.  By
changing the bucket_size indirectly through the bucket_shift, the
bio-based multipath performance improved, but I'm not sure this is a
knob we want to expose to users.  For now, please consider the patches
below, for review.

By the way, the exercise to support bio-based mpath uncovered the mpath
initialization bug that I fixed in the previous patch I sent today, so
it was worth it.

Gabriel Krisman Bertazi (2):
  md: multipath: Encapsulate parameters passed to selectors
  md: multipath: Pass io_start_time to the path selector

Khazhismel Kumykov (1):
  md: Add Historical Service Time Path Selector

 drivers/md/Kconfig                      |  11 +
 drivers/md/Makefile                     |   1 +
 drivers/md/dm-historical-service-time.c | 561 ++++++++++++++++++++++++
 drivers/md/dm-mpath.c                   |  30 +-
 drivers/md/dm-path-selector.h           |   9 +-
 drivers/md/dm-queue-length.c            |   4 +-
 drivers/md/dm-service-time.c            |   8 +-
 drivers/md/dm.c                         |  10 +
 include/linux/device-mapper.h           |   2 +
 9 files changed, 623 insertions(+), 13 deletions(-)
 create mode 100644 drivers/md/dm-historical-service-time.c

-- 
2.26.2
