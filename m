From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 2/5] multipath-tools: merge RPM_OPT_FLAGS into
	OPTFLAGS
Date: Thu, 30 Jun 2016 15:42:13 +0200
Message-ID: <1467294136-19275-3-git-send-email-xose.vazquez@gmail.com>
References: <1467294136-19275-1-git-send-email-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1467294136-19275-1-git-send-email-xose.vazquez@gmail.com>
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
---
 Makefile.inc | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/Makefile.inc b/Makefile.inc
index d7fc444..c4bea67 100644
--- a/Makefile.inc
+++ b/Makefile.inc
@@ -59,11 +59,9 @@ mpathcmddir = $(TOPDIR)/libmpathcmd
 GZIP        = gzip -9 -c
 INSTALL_PROGRAM = install
 
-ifndef RPM_OPT_FLAGS
-	RPM_OPT_FLAGS = -O2 -g -pipe -Wformat-security -Wall -Wp,-D_FORTIFY_SOURCE=2 -fexceptions -fstack-protector --param=ssp-buffer-size=4
-endif
+OPTFLAGS     = -Wunused -Wstrict-prototypes -O2 -g -pipe -Wformat-security -Wall \
+		-Wp,-D_FORTIFY_SOURCE=2 -fexceptions -fstack-protector --param=ssp-buffer-size=4
 
-OPTFLAGS     = $(RPM_OPT_FLAGS) -Wunused -Wstrict-prototypes
 CFLAGS	     = $(OPTFLAGS) -fPIC -DLIB_STRING=\"${LIB}\" -DRUN_DIR=\"${RUN}\"
 SHARED_FLAGS = -shared
 
-- 
2.7.4
