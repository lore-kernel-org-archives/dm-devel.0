From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 11/11] kpartx: Deinstall kpartx_id
Date: Thu, 17 Jan 2013 15:59:33 +0100
Message-ID: <1358434773-2002-12-git-send-email-hare@suse.de>
References: <1358434773-2002-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1358434773-2002-1-git-send-email-hare@suse.de>
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
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

We've installed it, so we should be uninstalling it, too.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 kpartx/Makefile |    1 +
 1 file changed, 1 insertion(+)

diff --git a/kpartx/Makefile b/kpartx/Makefile
index 1287053..b0d73a3 100644
--- a/kpartx/Makefile
+++ b/kpartx/Makefile
@@ -36,6 +36,7 @@ install: $(EXEC) $(EXEC).8
 uninstall:
 	rm -f $(DESTDIR)$(bindir)/$(EXEC)
 	rm -f $(DESTDIR)$(mandir)/$(EXEC).8.gz
+	rm -f $(DESTDIR)$(libudevdir)/kpartx_id
 
 clean:
 	rm -f core *.o $(EXEC) *.gz
-- 
1.7.10.4
