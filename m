From: neilb@suse.de
Subject: [dmraid 1/3] Remove incorrect quoting from pattern in
	lib/Makefile.in
Date: Tue, 02 Feb 2010 18:25:45 +1100
Message-ID: <20100202072751.083034080@suse.de>
References: <20100202072544.305994749@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline; filename=lib-install-1
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

The 
   [[ string =~ pattern ]]
command in bash only treats unquoted characters in 'pattern'
as being pattern characters.  If they are quoted, they much match
literally.

So we need to remove the quota for this match to work correctly.

This removes the need to explicitly install in dmraid.spec.


---
 dmraid.spec     |    8 --------
 lib/Makefile.in |    2 +-
 2 files changed, 1 insertion(+), 9 deletions(-)

--- dmraid.orig/dmraid.spec
+++ dmraid/dmraid.spec
@@ -87,14 +87,6 @@ ln -s dmraid $RPM_BUILD_ROOT/sbin/dmraid
 
 install -m 644 include/dmraid/*.h $RPM_BUILD_ROOT%{_includedir}/dmraid/
 
-# If requested, install the libdmraid and libdmraid-events (for dmeventd) DSO
-install -m 755 lib/libdmraid.so \
-	$RPM_BUILD_ROOT%{_libdir}/libdmraid.so.%{version}
-(cd $RPM_BUILD_ROOT/%{_libdir} ; ln -sf libdmraid.so.%{version} libdmraid.so)
-install -m 755 lib/libdmraid-events-isw.so \
-	$RPM_BUILD_ROOT%{_libdir}/libdmraid-events-isw.so.%{version}
-(cd $RPM_BUILD_ROOT/%{_libdir} ; ln -sf libdmraid-events-isw.so.%{version} libdmraid-events-isw.so)
-
 # Install logwatch config file and script for dmeventd
 install -m 644 logwatch/dmeventd.conf $RPM_BUILD_ROOT/etc/logwatch/conf/services/dmeventd.conf
 install -m 755 logwatch/dmeventd $RPM_BUILD_ROOT/etc/logwatch/scripts/services/dmeventd
--- dmraid.orig/lib/Makefile.in
+++ dmraid/lib/Makefile.in
@@ -82,7 +82,7 @@ install_dmraid_libs: $(INSTALL_TARGETS)
 	for f in $(INSTALL_TARGETS); \
 	do \
 		n=$$(basename $${f}) ; \
-		if [[ "$$n" =~ '.so$$' ]]; then \
+		if [[ "$$n" =~ .so$$ ]]; then \
 			$(INSTALL) -m 555 $(STRIP) \
 				$$f $(libdir)/$${n}.@DMRAID_LIB_VERSION@; \
 			$(LN_S) -f $${n}.@DMRAID_LIB_VERSION@ $(libdir)/$${n}; \
