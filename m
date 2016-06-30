From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 5/5] multipath-tools: make uninstall leaves
	traces behind
Date: Thu, 30 Jun 2016 15:42:16 +0200
Message-ID: <1467294136-19275-6-git-send-email-xose.vazquez@gmail.com>
References: <1467294136-19275-1-git-send-email-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1467294136-19275-1-git-send-email-xose.vazquez@gmail.com>
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

delete mpath_persist.h and libmpathpersist.so

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmpathpersist/Makefile | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/libmpathpersist/Makefile b/libmpathpersist/Makefile
index 70b2974..e6a7eb8 100644
--- a/libmpathpersist/Makefile
+++ b/libmpathpersist/Makefile
@@ -41,6 +41,8 @@ uninstall:
 	rm -f $(DESTDIR)$(syslibdir)/$(LIBS)
 	rm $(DESTDIR)$(man3dir)/mpath_persistent_reserve_in.3.gz
 	rm $(DESTDIR)$(man3dir)/mpath_persistent_reserve_out.3.gz
+	rm -f $(DESTDIR)$(incdir)/mpath_persist.h
+	rm -f $(DESTDIR)$(syslibdir)/$(DEVLIB)
 
 clean:
 	rm -f core *.a *.o
-- 
2.7.4
