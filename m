From: bmarzins@sourceware.org
Subject: multipath-tools/kpartx Makefile kpartx.conf
Date: 22 Oct 2007 18:44:32 -0000
Message-ID: <20071022184432.17462.qmail@sourceware.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-cvs@sourceware.org, dm-devel@redhat.com
List-Id: dm-devel.ids

CVSROOT:	/cvs/dm
Module name:	multipath-tools
Branch: 	RHEL4_FC5
Changes by:	bmarzins@sourceware.org	2007-10-22 18:44:31

Modified files:
	kpartx         : Makefile 
Added files:
	kpartx         : kpartx.conf 

Log message:
	add default kpartx.conf.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/kpartx/kpartx.conf.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=NONE&r2=1.1.2.1
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/kpartx/Makefile.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.5.2.1&r2=1.5.2.2

--- multipath-tools/kpartx/Makefile	2006/09/19 21:06:40	1.5.2.1
+++ multipath-tools/kpartx/Makefile	2007/10/22 18:44:31	1.5.2.2
@@ -43,6 +43,9 @@
 	install -m 755 $(EXEC).static $(DESTDIR)$(bindir)
 	install -d $(DESTDIR)$(mandir)
 	install -m 644 $(EXEC).8 $(DESTDIR)$(mandir)
+	@if [ ! -e $(DESTDIR)/etc/kpartx.conf ]; then \
+		install -m 644 kpartx.conf $(DESTDIR)/etc/kpartx.conf; \
+	fi
 
 uninstall:
 	rm -f $(DESTDIR)$(bindir)/$(EXEC)
