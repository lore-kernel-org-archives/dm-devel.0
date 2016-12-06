From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 2/2] multipath-tools: Add -Werror compilation
	flags
Date: Tue,  6 Dec 2016 02:26:27 +0100
Message-ID: <20161206012627.10415-3-xose.vazquez@gmail.com>
References: <20161206012627.10415-1-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20161206012627.10415-1-xose.vazquez@gmail.com>
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

Add -Werror=format-security: GCC will refuse to compile code that could be
vulnerable to a string format security flaw. At present, this warns about
calls to "printf" and "scanf" from untrusted input and contains %n.

Add -Werror=implicit-function-declaration: Implicit function declarations
allows a programmer to call functions without declaring them (or including the
relevant header files). The official C language specification has not supported
implicit function declarations for almost two decades now. GCC still supports
them as a GNU extension. Implicit function declarations introduce bugs because
these functions use a different calling convention and have a fixed return type
of int. Resulting issues are pointer truncation (on 64-bit architectures),
exposure of padding bits (particular for bool-returning functions on x86_64),
and unexpected lack of hardening. Implicit function declarations are not part of
C++ (with or without GNU extensions), and adjusting C code accordingly
simplifies reuse in C++ projects.

Add -Werror=implicit-int: Implicit ints were removed from the C programming
language at the same time as implicit function definitions, and were also
retained as a GNU extension. Implicit ints are usually source code bugs, and the
presence of such code may interfere with future C language directions (for
example, consider how C++ reused the auto keyword and an omitted type
specifier).


These flags are used by default in Fedora. More info:
https://fedoraproject.org/wiki/Changes/FormatSecurity
https://fedoraproject.org/wiki/Format-Security-FAQ
https://fedoraproject.org/wiki/Changes/Fedora26CFlags


Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 Makefile.inc | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/Makefile.inc b/Makefile.inc
index fa3c595..8f8e53e 100644
--- a/Makefile.inc
+++ b/Makefile.inc
@@ -61,7 +61,8 @@ RM		= rm -f
 LN		= ln -sf
 INSTALL_PROGRAM	= install
 
-OPTFLAGS	= -O2 -g -pipe -Wall -Wextra -Wformat=2 \
+OPTFLAGS	= -O2 -g -pipe -Wall -Wextra -Wformat=2 -Werror=implicit-int \
+		  -Werror=implicit-function-declaration -Werror=format-security \
 		  -Wno-sign-compare -Wno-unused-parameter -Wno-clobbered \
 		  -Wp,-D_FORTIFY_SOURCE=2 -fstack-protector-strong \
 		  --param=ssp-buffer-size=4
-- 
2.11.0
