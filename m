From: Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 72/72] multipath-tools: Makefile.inc: test for
 -Wno-clobbered support
Date: Sat, 12 Oct 2019 21:29:07 +0000
Message-ID: <20191012212703.12989-73-martin.wilck@suse.com>
References: <20191012212703.12989-1-martin.wilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20191012212703.12989-1-martin.wilck@suse.com>
Content-Language: en-US
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
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, Martin Wilck <Martin.Wilck@suse.com>
List-Id: dm-devel.ids

From: Martin Wilck <mwilck@suse.com>

clang doesn't support this option.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 Makefile.inc | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/Makefile.inc b/Makefile.inc
index 59a36cd3..d4d1e0dd 100644
--- a/Makefile.inc
+++ b/Makefile.inc
@@ -91,10 +91,11 @@ TEST_CC_OPTION = $(shell \
 
 STACKPROT := $(call TEST_CC_OPTION,-fstack-protector-strong,-fstack-protector)
 ERROR_DISCARDED_QUALIFIERS := $(call TEST_CC_OPTION,-Werror=discarded-qualifiers,)
+WNOCLOBBERED := $(call TEST_CC_OPTION,-Wno-clobbered,)
 
 OPTFLAGS	= -O2 -g -pipe -Werror -Wall -Wextra -Wformat=2 -Werror=implicit-int \
 		  -Werror=implicit-function-declaration -Werror=format-security \
-		  -Wno-clobbered \
+		  $(WNOCLOBBERED) \
 		  -Werror=cast-qual $(ERROR_DISCARDED_QUALIFIERS) \
 		  $(STACKPROT) --param=ssp-buffer-size=4
 CPPFLAGS	:= -Wp,-D_FORTIFY_SOURCE=2 
-- 
2.23.0
