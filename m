From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 0/2] multipath-tools: Remove stealth whitespaces
Date: Sun, 10 Jul 2016 12:28:15 +0200
Message-ID: <1468146497-8170-1-git-send-email-xose.vazquez@gmail.com>
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
Cc: device-mapper development <dm-devel@redhat.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids


Xose Vazquez Perez (2):
  multipath-tools: clean stealth whitespaces *.[ch]
  multipath-tools: clean stealth whitespaces for the rest

 Makefile.inc                             |  1 -
 kpartx/crc32.c                           | 32 ++++++++---------
 kpartx/dasd.h                            |  4 +--
 kpartx/gpt.c                             |  2 +-
 kpartx/kpartx.8                          |  1 -
 kpartx/kpartx.rules                      |  2 --
 kpartx/ps3.c                             |  5 ---
 kpartx/solaris.c                         |  5 ++-
 kpartx/sun.c                             |  1 -
 kpartx/unixware.c                        |  6 ++--
 libmpathcmd/mpath_cmd.h                  | 60 ++++++++++++++++----------------
 libmpathpersist/mpath_persist.c          |  3 --
 libmpathpersist/mpath_persist.h          | 30 ++++++++--------
 libmpathpersist/mpath_pr_ioctl.c         |  2 +-
 libmpathpersist/mpath_pr_ioctl.h         |  2 --
 libmultipath/checkers/cciss.h            |  1 -
 libmultipath/config.c                    |  1 -
 libmultipath/list.h                      |  6 ++--
 libmultipath/lock.c                      |  1 -
 libmultipath/log_pthread.c               |  1 -
 libmultipath/print.c                     |  1 -
 libmultipath/print.h                     |  1 -
 libmultipath/prioritizers/alua_rtpg.c    |  1 -
 libmultipath/prioritizers/alua_rtpg.h    |  1 -
 libmultipath/prioritizers/alua_spc3.h    |  1 -
 libmultipath/prioritizers/datacore.c     |  1 -
 libmultipath/prioritizers/weightedpath.c |  1 -
 libmultipath/structs.c                   |  1 -
 libmultipath/structs_vec.c               |  1 -
 libmultipath/waiter.c                    |  1 -
 mpathpersist/main.c                      |  1 -
 mpathpersist/main.h                      |  1 -
 multipath/02_multipath                   |  1 -
 multipathd/Makefile                      |  1 -
 multipathd/cli.c                         |  1 -
 multipathd/cli_handlers.h                |  1 -
 multipathd/main.c                        |  1 -
 multipathd/uxlsnr.h                      |  1 -
 38 files changed, 73 insertions(+), 111 deletions(-)

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
-- 
2.7.4
