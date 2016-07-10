From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: drop "BUILD = glibc" from
	libmpathpersist/Makefile
Date: Sun, 10 Jul 2016 14:10:57 +0200
Message-ID: <1468152657-15470-1-git-send-email-xose.vazquez@gmail.com>
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
Cc: device-mapper development <dm-devel@redhat.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

Useless.

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmpathpersist/Makefile | 1 -
 1 file changed, 1 deletion(-)

diff --git a/libmpathpersist/Makefile b/libmpathpersist/Makefile
index a2dd7ed..3996db8 100644
--- a/libmpathpersist/Makefile
+++ b/libmpathpersist/Makefile
@@ -1,6 +1,5 @@
 # Makefile
 #
-BUILD = glibc
 include ../Makefile.inc
 
 SONAME=0
-- 
2.7.4
