From: Thomas Deutschmann <whissi@gentoo.org>
Subject: [PATCH] multipath-tools: Makefile: Respect standard
	toolchain related envvars
Date: Thu, 30 Nov 2017 00:23:11 +0100
Message-ID: <20171129232311.95483-1-whissi@gentoo.org>
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

The Makefile overrides standard envvars that control the toolchain flags.
This patch should set things right without reducing default behavior.

Signed-off-by: Thomas Deutschmann <whissi@gentoo.org>
---
 Makefile.inc | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/Makefile.inc b/Makefile.inc
index 29c290a2..951d58fc 100644
--- a/Makefile.inc
+++ b/Makefile.inc
@@ -90,11 +90,12 @@ OPTFLAGS	= -O2 -g -pipe -Wall -Wextra -Wformat=2 -Werror=implicit-int \
 		  -Wp,-D_FORTIFY_SOURCE=2 $(STACKPROT) \
 		  --param=ssp-buffer-size=4
 
-CFLAGS		= $(OPTFLAGS) -DLIB_STRING=\"${LIB}\" -DRUN_DIR=\"${RUN}\"
+CFLAGS		?= $(OPTFLAGS)
+CFLAGS		+= -DLIB_STRING=\"${LIB}\" -DRUN_DIR=\"${RUN}\"
 BIN_CFLAGS	= -fPIE -DPIE
 LIB_CFLAGS	= -fPIC
 SHARED_FLAGS	= -shared
-LDFLAGS		= -Wl,-z,relro -Wl,-z,now
+LDFLAGS		+= -Wl,-z,relro -Wl,-z,now
 BIN_LDFLAGS	= -pie
 
 # Check whether a function with name $1 has been declared in header file $2.
-- 
2.15.1
