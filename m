From: mwilck@suse.com
Subject: [PATCH v2 01/10] multipath-tools: Makefile.inc: fix
	compilation with gcc 4.x
Date: Wed, 26 Aug 2020 11:58:58 +0200
Message-ID: <20200826095907.5576-2-mwilck@suse.com>
References: <20200826095907.5576-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200826095907.5576-1-mwilck@suse.com>
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

GCC 4.x doesn't enable the "gnu99" standard by default, which is
required by the multipath-tools code. Tested with gcc 4, 7, 8,
9, 10 and clang 3.9, 7, 8, 9, 10.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 Makefile.inc | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile.inc b/Makefile.inc
index 8ea3352..e05f3a9 100644
--- a/Makefile.inc
+++ b/Makefile.inc
@@ -98,7 +98,7 @@ WARNFLAGS	:= -Werror -Wall -Wextra -Wformat=2 -Werror=implicit-int \
 		  -Werror=implicit-function-declaration -Werror=format-security \
 		  $(WNOCLOBBERED) -Werror=cast-qual $(ERROR_DISCARDED_QUALIFIERS)
 CPPFLAGS	:= -Wp,-D_FORTIFY_SOURCE=2 
-CFLAGS		:= $(CFLAGS) $(OPTFLAGS) $(WARNFLAGS) -pipe \
+CFLAGS		:= --std=gnu99 $(CFLAGS) $(OPTFLAGS) $(WARNFLAGS) -pipe \
 		   -DBIN_DIR=\"$(bindir)\" -DLIB_STRING=\"${LIB}\" -DRUN_DIR=\"${RUN}\" \
 		   -MMD -MP
 BIN_CFLAGS	= -fPIE -DPIE
-- 
2.28.0
