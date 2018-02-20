From: Martin Wilck <mwilck@suse.com>
Subject: [RFC PATCH 09/20] multipath-tools: Makefile.inc: use
	-Werror=cast-qual
Date: Tue, 20 Feb 2018 14:26:47 +0100
Message-ID: <20180220132658.22295-10-mwilck@suse.com>
References: <20180220132658.22295-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180220132658.22295-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Hannes Reinecke <hare@suse.de>
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

Casting "const" away is often an indicator for wrong code.
Add a compiler flag to warn about such possible breakage.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 Makefile.inc | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Makefile.inc b/Makefile.inc
index eb99c36010c1..a5b9d4e3fa74 100644
--- a/Makefile.inc
+++ b/Makefile.inc
@@ -87,6 +87,7 @@ STACKPROT := $(call TEST_CC_OPTION,-fstack-protector-strong,-fstack-protector)
 OPTFLAGS	= -O2 -g -pipe -Wall -Wextra -Wformat=2 -Werror=implicit-int \
 		  -Werror=implicit-function-declaration -Werror=format-security \
 		  -Wno-sign-compare -Wno-unused-parameter -Wno-clobbered \
+		  -Werror=cast-qual -Werror=discarded-qualifiers \
 		  -Wp,-D_FORTIFY_SOURCE=2 $(STACKPROT) \
 		  --param=ssp-buffer-size=4
 
-- 
2.16.1
