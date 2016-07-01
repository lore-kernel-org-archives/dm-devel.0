From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 0/5] Makefiles housekeeping II
Date: Fri,  1 Jul 2016 19:17:27 +0200
Message-ID: <1467393452-1032-1-git-send-email-xose.vazquez@gmail.com>
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

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>

Xose Vazquez Perez (5):
  multipath-tools: replace rm with a variable in makefiles
  multipath-tools: replace install with its variable in makefiles
  multipath-tools: replace ln with a variable in makefiles
  multipath-tools: link libmpathcmd.so with full path
  multipath-tools: add a link for libmultipath.so

 Makefile.inc                       |  2 ++
 kpartx/Makefile                    | 12 ++++++------
 libmpathcmd/Makefile               | 12 ++++++------
 libmpathpersist/Makefile           | 28 ++++++++++++++--------------
 libmultipath/Makefile              |  8 +++++---
 libmultipath/checkers/Makefile     |  4 ++--
 libmultipath/prioritizers/Makefile |  4 ++--
 mpathpersist/Makefile              | 16 ++++++++--------
 multipath/Makefile                 | 12 ++++++------
 multipathd/Makefile                | 10 +++++-----
 10 files changed, 56 insertions(+), 52 deletions(-)

-- 
2.7.4
