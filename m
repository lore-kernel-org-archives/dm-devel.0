From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 2/2] multipath-tools: fix compilation with gcc
	< 4.9
Date: Wed, 17 May 2017 17:24:46 +0200
Message-ID: <20170517152446.2526-3-mwilck@suse.com>
References: <20170517152446.2526-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170517152446.2526-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Hannes Reinecke <hare@suse.de>, Bart Van Assche <Bart.VanAssche@sandisk.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

gcc supports -fstack-protector-strong since v4.9 only. Add a "poor man's
autoconf" test to check whether the option is supported on the given
build system.

Fixes: 596f51f3
"multipath-tools: Replace -fstack-protector with -fstack-protector-strong"

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 Makefile.inc | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/Makefile.inc b/Makefile.inc
index 8361e6c4..de69ab38 100644
--- a/Makefile.inc
+++ b/Makefile.inc
@@ -69,10 +69,23 @@ RM		= rm -f
 LN		= ln -sf
 INSTALL_PROGRAM	= install
 
+# $(call TEST_CC_OPTION,option,fallback)
+# Test if the C compiler supports the option.
+# Evaluates to "option" if yes, and "fallback" otherwise.
+TEST_CC_OPTION = $(shell \
+	if echo 'int main(void){return 0;}' | $(CC) -o /dev/null -c "$(1)" -xc - &>/dev/null; \
+	then \
+		echo "$(1)"; \
+	else \
+		echo "$(2)"; \
+	fi)
+
+STACKPROT := $(call TEST_CC_OPTION,-fstack-protector-strong,-fstack-protector)
+
 OPTFLAGS	= -O2 -g -pipe -Wall -Wextra -Wformat=2 -Werror=implicit-int \
 		  -Werror=implicit-function-declaration -Werror=format-security \
 		  -Wno-sign-compare -Wno-unused-parameter -Wno-clobbered \
-		  -Wp,-D_FORTIFY_SOURCE=2 -fstack-protector-strong \
+		  -Wp,-D_FORTIFY_SOURCE=2 $(STACKPROT) \
 		  --param=ssp-buffer-size=4
 
 CFLAGS		= $(OPTFLAGS) -fPIC -DLIB_STRING=\"${LIB}\" -DRUN_DIR=\"${RUN}\"
-- 
2.12.2
