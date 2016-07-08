From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 0/3] Makefiles housekeeping III
Date: Fri,  8 Jul 2016 18:28:18 +0200
Message-ID: <1467995301-14226-1-git-send-email-xose.vazquez@gmail.com>
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

Xose Vazquez Perez (3):
  multipath-tools: install libs in a standard way
  multipath-tools: merge OPTFLAGS into CFLAGS
  multipath-tools: delete INSTALL_PROGRAM from libmpathpersist/Makefile

 Makefile.inc             | 7 +++----
 libmpathpersist/Makefile | 4 +---
 libmultipath/Makefile    | 2 ++
 3 files changed, 6 insertions(+), 7 deletions(-)

-- 
2.7.4
