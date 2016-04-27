From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 18/57] libmpathpersist: Fixup whitespaces in
	Makefile
Date: Wed, 27 Apr 2016 13:10:19 +0200
Message-ID: <1461755458-29225-19-git-send-email-hare@suse.de>
References: <1461755458-29225-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1461755458-29225-1-git-send-email-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@gmail.com>
Cc: Hannes Reinecke <hare@suse.com>, dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 libmpathpersist/Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/libmpathpersist/Makefile b/libmpathpersist/Makefile
index e49cdb9..59db73a 100644
--- a/libmpathpersist/Makefile
+++ b/libmpathpersist/Makefile
@@ -40,8 +40,8 @@ install: $(LIBS)
 
 uninstall:
 	rm -f $(DESTDIR)$(syslibdir)/$(LIBS)
-	rm $(DESTDIR)$(man3dir)/mpath_persistent_reserve_in.3.gz	
-	rm $(DESTDIR)$(man3dir)/mpath_persistent_reserve_out.3.gz	
+	rm $(DESTDIR)$(man3dir)/mpath_persistent_reserve_in.3.gz
+	rm $(DESTDIR)$(man3dir)/mpath_persistent_reserve_out.3.gz
 
 clean:
 	rm -f core *.a *.o 
-- 
2.6.6
