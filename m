From: Gabriel Krisman Bertazi <krisman@collabora.com>
Subject: [PATCH v4 0/2] Historical Service Time Path Selector
Date: Mon, 11 May 2020 12:39:08 -0400
Message-ID: <20200511163910.3778467-1-krisman@collabora.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: agk@redhat.com, snitzer@redhat.com
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org, song@kernel.org, breeves@redhat.com, mpatocka@redhat.com, khazhy@google.com, Gabriel Krisman Bertazi <krisman@collabora.com>, kernel@collabora.com
List-Id: dm-devel.ids

Hi,

This fourth version of HST applies the suggestion from Mikulas Patocka
to do the ktime_get_ns inside the mpath map_bio instead of generic
device-mapper code. This means that struct dm_mpath_io gained another
64bit field.  For the request-based case, we continue to use the block
layer start time information.

With this modification, I was able obtain similar performance on  BIO
to request-based multipath with HST on the benchmarks shared in v1.

v3: https://www.redhat.com/archives/dm-devel/2020-April/msg00308.html
v2: https://www.redhat.com/archives/dm-devel/2020-April/msg00270.html
v1: https://www.redhat.com/archives/dm-devel/2020-April/msg00176.html

Gabriel Krisman Bertazi (1):
  md: mpath: Pass IO start time to path selector

Khazhismel Kumykov (1):
  md: mpath: Add Historical Service Time Path Selector

 drivers/md/Kconfig                      |  11 +
 drivers/md/Makefile                     |   1 +
 drivers/md/dm-historical-service-time.c | 561 ++++++++++++++++++++++++
 drivers/md/dm-mpath.c                   |  12 +-
 drivers/md/dm-path-selector.h           |   2 +-
 drivers/md/dm-queue-length.c            |   2 +-
 drivers/md/dm-service-time.c            |   2 +-
 7 files changed, 585 insertions(+), 6 deletions(-)
 create mode 100644 drivers/md/dm-historical-service-time.c

-- 
2.26.2
