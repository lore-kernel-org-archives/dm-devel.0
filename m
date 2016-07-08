From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 2/3] multipath-tools: merge OPTFLAGS into CFLAGS
Date: Fri,  8 Jul 2016 18:28:20 +0200
Message-ID: <1467995301-14226-3-git-send-email-xose.vazquez@gmail.com>
References: <1467995301-14226-1-git-send-email-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1467995301-14226-1-git-send-email-xose.vazquez@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Cc: Mathieu Trudel-Lapierre <mathieu.trudel-lapierre@canonical.com>, Dragan Stancevic <dragan.stancevic@canonical.com>, device-mapper development <dm-devel@redhat.com>, Ritesh Raj Sarraf <rrs@debian.org>, Xose Vazquez Perez <xose.vazquez@gmail.com>, Louis Bouchard <louis.bouchard@canonical.com>
List-Id: dm-devel.ids

OPTFLAGS is not used anywhere, but maybe it's intrusive for distributions.

Cc: Mathieu Trudel-Lapierre <mathieu.trudel-lapierre@canonical.com>
Cc: Dragan Stancevic <dragan.stancevic@canonical.com>
Cc: Louis Bouchard <louis.bouchard@canonical.com>
Cc: Ritesh Raj Sarraf <rrs@debian.org>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 Makefile.inc | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/Makefile.inc b/Makefile.inc
index 01d743c..b7077fc 100644
--- a/Makefile.inc
+++ b/Makefile.inc
@@ -60,10 +60,9 @@ RM          = rm -f
 LN          = ln -sf
 INSTALL_PROGRAM = install
 
-OPTFLAGS     = -Wunused -Wstrict-prototypes -O2 -g -pipe -Wformat-security -Wall \
-		-Wp,-D_FORTIFY_SOURCE=2 -fexceptions -fstack-protector --param=ssp-buffer-size=4
-
-CFLAGS	     = $(OPTFLAGS) -fPIC -DLIB_STRING=\"${LIB}\" -DRUN_DIR=\"${RUN}\"
+CFLAGS      = -Wunused -Wstrict-prototypes -O2 -g -pipe -Wformat-security -Wall \
+		-Wp,-D_FORTIFY_SOURCE=2 -fexceptions -fstack-protector --param=ssp-buffer-size=4 \
+		-fPIC -DLIB_STRING=\"${LIB}\" -DRUN_DIR=\"${RUN}\"
 SHARED_FLAGS = -shared
 
 %.o:	%.c
-- 
2.7.4
