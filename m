From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH] Makefile.inc: Remove -fexceptions from CFLAGS
Date: Tue, 16 Aug 2016 12:56:22 -0700
Message-ID: <e832fbcf-dde0-5b84-980a-cd0745d027c6@sandisk.com>
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
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

No code in the multipath-tools project calls a C++ function that
generates an exception. Hence remove -fexceptions. From the gcc
manual:

-fexceptions

  Enable exception handling. Generates extra code needed to
  propagate exceptions. For some targets, this implies GCC
  generates frame unwind information for all functions, which can
  produce significant data size overhead, although it does not
  affect execution. If you do not specify this option, GCC
  enables it by default for languages like C++ that normally
  require exception handling, and disables it for languages like
  C that do not normally require it. However, you may need to
  enable this option when compiling C code that needs to
  interoperate properly with exception handlers written in
  C++. You may also wish to disable this option if you are
  compiling older C++ programs that don't use exception handling.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
---
 Makefile.inc | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile.inc b/Makefile.inc
index 0808e64..0631ca2 100644
--- a/Makefile.inc
+++ b/Makefile.inc
@@ -61,7 +61,7 @@ LN		= ln -sf
 INSTALL_PROGRAM	= install
 
 OPTFLAGS	= -Wunused -Wstrict-prototypes -O2 -g -pipe -Wformat-security -Wall \
-		  -Wp,-D_FORTIFY_SOURCE=2 -fexceptions -fstack-protector --param=ssp-buffer-size=4
+		  -Wp,-D_FORTIFY_SOURCE=2 -fstack-protector --param=ssp-buffer-size=4
 
 CFLAGS		= $(OPTFLAGS) -fPIC -DLIB_STRING=\"${LIB}\" -DRUN_DIR=\"${RUN}\"
 SHARED_FLAGS	= -shared
-- 
2.9.2
