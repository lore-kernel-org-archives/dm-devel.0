From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 08/78] Make systemd installation path configurable
Date: Mon, 16 Mar 2015 13:35:55 +0100
Message-ID: <1426509425-15978-9-git-send-email-hare@suse.de>
References: <1426509425-15978-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1426509425-15978-1-git-send-email-hare@suse.de>
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

Older systems might have systemd installed in /lib, so make
the path for systemd and udev configurable.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 Makefile.inc | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/Makefile.inc b/Makefile.inc
index 20ae23e..c3ed73f 100644
--- a/Makefile.inc
+++ b/Makefile.inc
@@ -27,10 +27,14 @@ ifndef SYSTEMD
 	endif
 endif
 
+ifndef SYSTEMDPATH
+	SYSTEMDPATH=usr/lib
+endif
+
 prefix      = 
 exec_prefix = $(prefix)
 bindir      = $(exec_prefix)/sbin
-libudevdir  = ${prefix}/lib/udev
+libudevdir  = $(prefix)/$(SYSTEMDPATH)/udev
 udevrulesdir = $(libudevdir)/rules.d
 multipathdir = $(TOPDIR)/libmultipath
 mandir      = $(prefix)/usr/share/man/man8
@@ -39,7 +43,7 @@ man3dir      = $(prefix)/usr/share/man/man3
 rcdir	    = $(prefix)/etc/init.d
 syslibdir   = $(prefix)/$(LIB)
 libdir	    = $(prefix)/$(LIB)/multipath
-unitdir     = $(prefix)/usr/lib/systemd/system
+unitdir     = $(prefix)/$(SYSTEMDPATH)/systemd/system
 mpathpersistdir = $(TOPDIR)/libmpathpersist
 
 GZIP        = gzip -9 -c
-- 
1.8.4.5
