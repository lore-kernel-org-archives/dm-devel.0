From: Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 42/72] multipath-tools: Makefile.inc: remove
 -Wno-unused-parameter
Date: Sat, 12 Oct 2019 21:28:29 +0000
Message-ID: <20191012212703.12989-43-martin.wilck@suse.com>
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

All warnings have been eliminated now.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 Makefile.inc | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile.inc b/Makefile.inc
index 56c3eda0..da9a3d7d 100644
--- a/Makefile.inc
+++ b/Makefile.inc
@@ -93,7 +93,7 @@ ERROR_DISCARDED_QUALIFIERS := $(call TEST_CC_OPTION,-Werror=discarded-qualifiers
 
 OPTFLAGS	= -O2 -g -pipe -Wall -Wextra -Wformat=2 -Werror=implicit-int \
 		  -Werror=implicit-function-declaration -Werror=format-security \
-		  -Wno-sign-compare -Wno-unused-parameter -Wno-clobbered \
+		  -Wno-sign-compare -Wno-clobbered \
 		  -Werror=cast-qual $(ERROR_DISCARDED_QUALIFIERS) \
 		  -Wp,-D_FORTIFY_SOURCE=2 $(STACKPROT) \
 		  --param=ssp-buffer-size=4
-- 
2.23.0
