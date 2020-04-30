From: Gabriel Krisman Bertazi <krisman@collabora.com>
Subject: [PATCH v3 0/2] Historical Service Time Path Selector
Date: Thu, 30 Apr 2020 16:48:28 -0400
Message-ID: <20200430204830.2589456-1-krisman@collabora.com>
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

Hi,

This is the third version of HST considering the review by Mike
Snitzer.  This version drops the encapsulation patches and passes the
parameter directly to end_io.  It also uses jiffies_to_nsecs directly in
dm_start_time_ns_from_clone, instead of converting to msecs in an
intermediary step.

This didn't show any regressions compared to the benchmark I presented
on previous version:

v2: https://www.redhat.com/archives/dm-devel/2020-April/msg00270.html
v1: https://www.redhat.com/archives/dm-devel/2020-April/msg00176.html

This was tested primarily on a Google cloud SAN with real data and usage
patterns and with artificial benchmarks using fio.

Gabriel Krisman Bertazi (1):
  md: mpath: Pass IO start time to path selector

Khazhismel Kumykov (1):
  md: mpath: Add Historical Service Time Path Selector

 drivers/md/Kconfig                      |  11 +
 drivers/md/Makefile                     |   1 +
 drivers/md/dm-historical-service-time.c | 561 ++++++++++++++++++++++++
 drivers/md/dm-mpath.c                   |   9 +-
 drivers/md/dm-path-selector.h           |   2 +-
 drivers/md/dm-queue-length.c            |   2 +-
 drivers/md/dm-service-time.c            |   2 +-
 drivers/md/dm.c                         |  10 +
 include/linux/device-mapper.h           |   2 +
 9 files changed, 594 insertions(+), 6 deletions(-)
 create mode 100644 drivers/md/dm-historical-service-time.c

-- 
2.26.2
