From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH v2 0/5] Multipath Follow-up patches
Date: Wed, 19 Feb 2020 14:21:40 -0600
Message-ID: <1582143705-20886-1-git-send-email-bmarzins@redhat.com>
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
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>, Martin Wilck <Martin.Wilck@suse.com>
List-Id: dm-devel.ids

These patches resolve various minor issues that Martin had with my
previous patch set.

Changes in v2:

0001:	now uses memcmp() instead of strncmp(), and safe_sprintf()
	instead of strlcpy(), as suggested by Martin Wilck.

Benjamin Marzinski (5):
  multipath: fix issues found by compiling with gcc 10
  libmultipath: turn pp->vpd_data into a pointer
  libmultipath: change loading and resetting in directio
  libmultipath: change directio get_events() timeout handling
  libmultipath: cleanup old issues with directio checker

 kpartx/dasd.c                    |   6 +-
 libmultipath/checkers.c          |  26 ++---
 libmultipath/checkers.h          |   2 +-
 libmultipath/checkers/directio.c |  66 ++----------
 libmultipath/discovery.c         |  17 ++-
 libmultipath/print.c             |  20 ++--
 libmultipath/structs.c           |   3 +
 libmultipath/structs.h           |   2 +-
 multipath/main.c                 |   2 +-
 tests/directio.c                 | 178 ++++++++++++-------------------
 tests/vpd.c                      |   3 +-
 11 files changed, 125 insertions(+), 200 deletions(-)

-- 
2.17.2
