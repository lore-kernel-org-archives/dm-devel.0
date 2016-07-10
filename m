From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: delete "$BUILD" from Makefile
Date: Sun, 10 Jul 2016 14:40:40 +0200
Message-ID: <1468154440-18075-1-git-send-email-xose.vazquez@gmail.com>
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
 Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index bd7cfc1..cf1acd9 100644
--- a/Makefile
+++ b/Makefile
@@ -40,7 +40,7 @@ all: recurse
 
 recurse:
 	@for dir in $(BUILDDIRS); do \
-	$(MAKE) -C $$dir BUILD=$(BUILD) VERSION=$(VERSION) \
+	$(MAKE) -C $$dir VERSION=$(VERSION) \
 		KRNLSRC=$(KRNLSRC) KRNLOBJ=$(KRNLOBJ) || exit $?; \
 	done
 
-- 
2.7.4
