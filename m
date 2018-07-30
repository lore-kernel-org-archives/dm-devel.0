From: Mauricio Faria de Oliveira <mfo@canonical.com>
Subject: [PATCH 2/2] multipath-tools: check for C compiler option
	-Werror=discarded-qualifiers
Date: Mon, 30 Jul 2018 16:37:45 -0300
Message-ID: <20180730193745.21775-3-mfo@canonical.com>
References: <20180730193745.21775-1-mfo@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180730193745.21775-1-mfo@canonical.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: christophe.varoqui@opensvc.com
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

The -Werror=discarded-qualifiers option is not supported on GCC 4.8
(ships in Ubuntu 14.04 at least). Use TEST_CC_OPTION to detect that
and fix a build failure.

No regression on Ubuntu 18.04 (GCC 7.3, -Werror=discarded-qualifiers
used).

Fixes: ff307801
"multipath-tools: Makefile.inc: use -Werror=cast-qual"

Signed-off-by: Mauricio Faria de Oliveira <mfo@canonical.com>
---
 Makefile.inc | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/Makefile.inc b/Makefile.inc
index a12b46ef315e..a83f02c72ed6 100644
--- a/Makefile.inc
+++ b/Makefile.inc
@@ -86,11 +86,12 @@ TEST_CC_OPTION = $(shell \
 	fi)
 
 STACKPROT := $(call TEST_CC_OPTION,-fstack-protector-strong,-fstack-protector)
+ERROR_DISCARDED_QUALIFIERS := $(call TEST_CC_OPTION,-Werror=discarded-qualifiers,)
 
 OPTFLAGS	= -O2 -g -pipe -Wall -Wextra -Wformat=2 -Werror=implicit-int \
 		  -Werror=implicit-function-declaration -Werror=format-security \
 		  -Wno-sign-compare -Wno-unused-parameter -Wno-clobbered \
-		  -Werror=cast-qual -Werror=discarded-qualifiers \
+		  -Werror=cast-qual $(ERROR_DISCARDED_QUALIFIERS) \
 		  -Wp,-D_FORTIFY_SOURCE=2 $(STACKPROT) \
 		  --param=ssp-buffer-size=4
 
-- 
2.17.1
