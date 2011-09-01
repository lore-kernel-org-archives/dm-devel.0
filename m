From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH] multipath: systemd unit file
Date: Wed, 31 Aug 2011 22:00:28 -0500
Message-ID: <20110901030028.GE11793@ether.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
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

Here is a systemd unit file for managing multipathd.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 Makefile.inc                  |    1 +
 multipathd/Makefile           |    3 +++
 multipathd/multipathd.service |   14 ++++++++++++++
 3 files changed, 18 insertions(+)

Index: multipath-tools-110831/Makefile.inc
===================================================================
--- multipath-tools-110831.orig/Makefile.inc
+++ multipath-tools-110831/Makefile.inc
@@ -31,6 +31,7 @@ man5dir     = $(prefix)/usr/share/man/ma
 rcdir	    = $(prefix)/etc/init.d
 syslibdir   = $(prefix)/$(LIB)
 libdir	    = $(prefix)/$(LIB)/multipath
+unitdir     = $(prefix)/lib/systemd/system
 
 GZIP        = /bin/gzip -9 -c
 INSTALL_PROGRAM = install
Index: multipath-tools-110831/multipathd/Makefile
===================================================================
--- multipath-tools-110831.orig/multipathd/Makefile
+++ multipath-tools-110831/multipathd/Makefile
@@ -35,6 +35,8 @@ install:
 	$(INSTALL_PROGRAM) -d $(DESTDIR)$(bindir)
 	$(INSTALL_PROGRAM) -m 755 $(EXEC) $(DESTDIR)$(bindir)
 	$(INSTALL_PROGRAM) -d $(DESTDIR)$(rcdir)
+	$(INSTALL_PROGRAM) -d $(DESTDIR)$(unitdir)
+	$(INSTALL_PROGRAM) -m 644 $(EXEC).service $(DESTDIR)$(unitdir)
 	$(INSTALL_PROGRAM) -d $(DESTDIR)$(mandir)
 	$(INSTALL_PROGRAM) -m 644 $(EXEC).8.gz $(DESTDIR)$(mandir)
 
@@ -42,6 +44,7 @@ uninstall:
 	rm -f $(DESTDIR)$(bindir)/$(EXEC)
 	rm -f $(DESTDIR)$(rcdir)/$(EXEC)
 	rm -f $(DESTDIR)$(mandir)/$(EXEC).8.gz
+	rm -f $(DESTDIR)$(unitdir)/$(EXEC).service
 
 clean:
 	rm -f core *.o $(EXEC) *.gz
Index: multipath-tools-110831/multipathd/multipathd.service
===================================================================
--- /dev/null
+++ multipath-tools-110831/multipathd/multipathd.service
@@ -0,0 +1,14 @@
+[Unit]
+Description=Device-Mapper Multipath Device Controller
+Before=iscsi.service iscsid.service
+After=syslog.target
+
+[Service]
+Type=forking
+PIDFile=/var/run/multipathd.pid
+ExecStart=/sbin/multipathd
+ExecReload=/bin/kill -HUP $MAINPID
+#ExecStop=/path/to/scrip delete-me if not necessary
+
+[Install]
+WantedBy=multi-user.target
