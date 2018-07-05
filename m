From: Gioh Kim <gi-oh.kim@profitbricks.com>
Subject: [PATCH] Makefile: include Makefile.inc
Date: Thu,  5 Jul 2018 14:11:56 +0200
Message-ID: <20180705121156.11954-1-gi-oh.kim@profitbricks.com>
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
To: christophe.varoqui@opensvc.com
Cc: dm-devel@redhat.com, Gioh Kim <gi-oh.kim@profitbricks.com>
List-Id: dm-devel.ids

Since ENABLE_LIBDMMP is defined in Makefile.inc, Makefile needs to include
Makefile.inc to disable building libdmmp.

Signed-off-by: Gioh Kim <gi-oh.kim@profitbricks.com>
---
 Makefile | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Makefile b/Makefile
index 4b145c59..4a224a76 100644
--- a/Makefile
+++ b/Makefile
@@ -2,6 +2,8 @@
 # Copyright (C) 2003 Christophe Varoqui, <christophe.varoqui@opensvc.com>
 #
 
+include Makefile.inc
+
 BUILDDIRS = \
 	libmpathcmd \
 	libmultipath \
-- 
2.14.1
