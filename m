From: mwilck@suse.com
Subject: [PATCH 02/11] multipath-tools: Makefile.inc: separate
	out OPTFLAGS
Date: Tue, 12 May 2020 00:39:22 +0200
Message-ID: <20200511223931.18261-3-mwilck@suse.com>
References: <20200511223931.18261-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200511223931.18261-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

From: Martin Wilck <mwilck@suse.com>

OPTFLAGS is what distribution builds would typically override. That
should not include the warning flags we use.

Moreover, in the definition of CFLAGS, put $(CFLAGS) first to make it
easier for the user to spot her input in the build logs.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 Makefile.inc | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/Makefile.inc b/Makefile.inc
index d4d1e0dd..7a59db85 100644
--- a/Makefile.inc
+++ b/Makefile.inc
@@ -93,14 +93,14 @@ STACKPROT := $(call TEST_CC_OPTION,-fstack-protector-strong,-fstack-protector)
 ERROR_DISCARDED_QUALIFIERS := $(call TEST_CC_OPTION,-Werror=discarded-qualifiers,)
 WNOCLOBBERED := $(call TEST_CC_OPTION,-Wno-clobbered,)
 
-OPTFLAGS	= -O2 -g -pipe -Werror -Wall -Wextra -Wformat=2 -Werror=implicit-int \
+OPTFLAGS	:= -O2 -g $(STACKPROT) --param=ssp-buffer-size=4
+WARNFLAGS	:= -Werror -Wall -Wextra -Wformat=2 -Werror=implicit-int \
 		  -Werror=implicit-function-declaration -Werror=format-security \
-		  $(WNOCLOBBERED) \
-		  -Werror=cast-qual $(ERROR_DISCARDED_QUALIFIERS) \
-		  $(STACKPROT) --param=ssp-buffer-size=4
+		  $(WNOCLOBBERED) -Werror=cast-qual $(ERROR_DISCARDED_QUALIFIERS)
 CPPFLAGS	:= -Wp,-D_FORTIFY_SOURCE=2 
-CFLAGS		:= $(OPTFLAGS) -DBIN_DIR=\"$(bindir)\" -DLIB_STRING=\"${LIB}\" -DRUN_DIR=\"${RUN}\" \
-		   -MMD -MP $(CFLAGS)
+CFLAGS		:= $(CFLAGS) $(OPTFLAGS) $(WARNFLAGS) -pipe \
+		   -DBIN_DIR=\"$(bindir)\" -DLIB_STRING=\"${LIB}\" -DRUN_DIR=\"${RUN}\" \
+		   -MMD -MP
 BIN_CFLAGS	= -fPIE -DPIE
 LIB_CFLAGS	= -fPIC
 SHARED_FLAGS	= -shared
-- 
2.26.2
