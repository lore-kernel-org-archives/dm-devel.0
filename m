From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: space \ at Makefile.inc
Date: Wed, 19 Oct 2016 00:49:41 +0200
Message-ID: <20161018224941.4451-1-xose.vazquez@gmail.com>
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

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 Makefile.inc | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile.inc b/Makefile.inc
index be6b2bc..1cc8f44 100644
--- a/Makefile.inc
+++ b/Makefile.inc
@@ -62,7 +62,7 @@ LN		= ln -sf
 INSTALL_PROGRAM	= install
 
 OPTFLAGS	= -O2 -g -pipe -Wall -Wextra -Wformat=2 \
-		  -Wno-sign-compare -Wno-unused-parameter -Wno-clobbered\
+		  -Wno-sign-compare -Wno-unused-parameter -Wno-clobbered \
 		  -Wp,-D_FORTIFY_SOURCE=2 -fstack-protector \
 		  --param=ssp-buffer-size=4
 
-- 
2.10.1
