From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 3/5] multipath-tools: delete libdmmp.pc in
	uninstall
Date: Sun, 24 Sep 2017 01:39:01 +0200
Message-ID: <20170923233903.24792-4-xose.vazquez@gmail.com>
References: <20170923233903.24792-1-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170923233903.24792-1-xose.vazquez@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Cc: Gris Ge <fge@redhat.com>, device-mapper development <dm-devel@redhat.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

Cc: Gris Ge <fge@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libdmmp/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/libdmmp/Makefile b/libdmmp/Makefile
index cdd26ed..1e2b8f9 100644
--- a/libdmmp/Makefile
+++ b/libdmmp/Makefile
@@ -54,6 +54,7 @@ uninstall:
 		$(RM) $$file; \
 	done
 	$(RM) $(DESTDIR)$(man3dir)/libdmmp.h*
+	$(RM) $(DESTDIR)$(pkgconfdir)/$(PKGFILE)
 
 clean:
 	$(RM) core *.a *.o *.gz *.so *.so.*
-- 
2.13.5
