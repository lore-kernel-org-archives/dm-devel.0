From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 15/15] Makefile.inc: Enable -Wextra and
	-Wformat-nonliteral
Date: Tue, 4 Oct 2016 10:42:21 -0700
Message-ID: <4d3a965d-3caa-e596-8351-d0ae2465e54d@sandisk.com>
References: <157defac-6527-ab23-92f2-9c1926042885@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <157defac-6527-ab23-92f2-9c1926042885@sandisk.com>
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
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Instead of selecting some of the options enabled by -Wextra, enable
-Wextra and disable some of the options enabled by -Wextra. Enable
-Wformat-nonliteral.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
---
 Makefile.inc | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/Makefile.inc b/Makefile.inc
index 376f00a..be6b2bc 100644
--- a/Makefile.inc
+++ b/Makefile.inc
@@ -61,8 +61,10 @@ RM		= rm -f
 LN		= ln -sf
 INSTALL_PROGRAM	= install
 
-OPTFLAGS	= -Wunused -Wstrict-prototypes -O2 -g -pipe -Wformat-security -Wall \
-		  -Wp,-D_FORTIFY_SOURCE=2 -fstack-protector --param=ssp-buffer-size=4
+OPTFLAGS	= -O2 -g -pipe -Wall -Wextra -Wformat=2 \
+		  -Wno-sign-compare -Wno-unused-parameter -Wno-clobbered\
+		  -Wp,-D_FORTIFY_SOURCE=2 -fstack-protector \
+		  --param=ssp-buffer-size=4
 
 CFLAGS		= $(OPTFLAGS) -fPIC -DLIB_STRING=\"${LIB}\" -DRUN_DIR=\"${RUN}\"
 SHARED_FLAGS	= -shared
-- 
2.10.0
