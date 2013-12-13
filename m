From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 2/3] Use correct systemd unit directory
Date: Fri, 13 Dec 2013 10:11:18 +0100
Message-ID: <1386925879-31225-3-git-send-email-hare@suse.de>
References: <1386925879-31225-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1386925879-31225-1-git-send-email-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

The systemd unit directory has been moved to /usr/lib/systemd.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 Makefile.inc | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile.inc b/Makefile.inc
index 7186484..f445160 100644
--- a/Makefile.inc
+++ b/Makefile.inc
@@ -38,7 +38,7 @@ man3dir      = $(prefix)/usr/share/man/man3
 rcdir	    = $(prefix)/etc/init.d
 syslibdir   = $(prefix)/$(LIB)
 libdir	    = $(prefix)/$(LIB)/multipath
-unitdir     = $(prefix)/lib/systemd/system
+unitdir     = $(prefix)/usr/lib/systemd/system
 mpathpersistdir = $(TOPDIR)/libmpathpersist
 
 GZIP        = gzip -9 -c
-- 
1.8.1.4
