From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: replace -shared with its
	variable
Date: Sun, 10 Jul 2016 16:22:22 +0200
Message-ID: <1468160542-21375-1-git-send-email-xose.vazquez@gmail.com>
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
 libmpathpersist/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmpathpersist/Makefile b/libmpathpersist/Makefile
index 3996db8..07fcf70 100644
--- a/libmpathpersist/Makefile
+++ b/libmpathpersist/Makefile
@@ -18,7 +18,7 @@ all: $(LIBS)
 
 $(LIBS):
 	$(CC) -Wall -fPIC -c $(CFLAGS) *.c
-	$(CC)  -shared $(LIBDEPS) -Wl,-soname=$@ $(CFLAGS) -o $@ $(OBJS)
+	$(CC) $(SHARED_FLAGS) $(LIBDEPS) -Wl,-soname=$@ $(CFLAGS) -o $@ $(OBJS)
 	$(LN) $(LIBS) $(DEVLIB)
 	$(GZIP) mpath_persistent_reserve_in.3 > mpath_persistent_reserve_in.3.gz
 	$(GZIP) mpath_persistent_reserve_out.3 > mpath_persistent_reserve_out.3.gz
-- 
2.7.4
