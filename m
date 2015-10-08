From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 15/18] libmpathpersist: uninstall man page
	correctly
Date: Thu,  8 Oct 2015 14:44:48 -0500
Message-ID: <1444333491-16265-16-git-send-email-bmarzins@redhat.com>
References: <1444333491-16265-1-git-send-email-bmarzins@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1444333491-16265-1-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

the libmpathpersist man pages were being installed to
/usr/share/man/man3, but uninstalled from /usr/share/man/man8.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmpathpersist/Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/libmpathpersist/Makefile b/libmpathpersist/Makefile
index 7dcfd26..e49cdb9 100644
--- a/libmpathpersist/Makefile
+++ b/libmpathpersist/Makefile
@@ -40,8 +40,8 @@ install: $(LIBS)
 
 uninstall:
 	rm -f $(DESTDIR)$(syslibdir)/$(LIBS)
-	rm $(DESTDIR)$(mandir)/mpath_persistent_reserve_in.3.gz	
-	rm $(DESTDIR)$(mandir)/mpath_persistent_reserve_out.3.gz	
+	rm $(DESTDIR)$(man3dir)/mpath_persistent_reserve_in.3.gz	
+	rm $(DESTDIR)$(man3dir)/mpath_persistent_reserve_out.3.gz	
 
 clean:
 	rm -f core *.a *.o 
-- 
1.8.3.1
