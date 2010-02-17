From: heinzm@sourceware.org
Subject: dmraid ./dmraid.spec lib/version.h lib/misc/li ...
Date: 17 Feb 2010 11:51:55 -0000
Message-ID: <20100217115155.28893.qmail@sourceware.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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
Module name:	dmraid
Changes by:	heinzm@sourceware.org	2010-02-17 11:51:54

Modified files:
	.              : dmraid.spec 
	lib            : version.h 
	lib/misc       : lib_context.c 

Log message:
	Change library version to '1' and enhance display of internal extended version

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/dmraid.spec.diff?cvsroot=dm&r1=1.11&r2=1.12
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/version.h.diff?cvsroot=dm&r1=1.9&r2=1.10
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/misc/lib_context.c.diff?cvsroot=dm&r1=1.3&r2=1.4

--- dmraid/dmraid.spec	2010/01/12 12:21:09	1.11
+++ dmraid/dmraid.spec	2010/02/17 11:51:53	1.12
@@ -7,7 +7,7 @@
 Summary: dmraid (Device-mapper RAID tool and library)
 Name: dmraid
 Version: 1.0.0.rc16
-Release: 3%{?dist}
+Release: 4%{?dist}
 License: GPLv2+
 Group: System Environment/Base
 URL: http://people.redhat.com/heinzm/sw/dmraid
@@ -23,10 +23,6 @@
 Provides: dmraid-libs = %{version}-%{release}
 Source: ftp://people.redhat.com/heinzm/sw/dmraid/src/%{name}-%{version}.tar.bz2
 
-Patch0: dmraid-1.0.0.rc16-test_devices.patch
-Patch1: ddf1_lsi_persistent_name.patch
-Patch2: pdc_raid10_failure.patch
-
 %description
 DMRAID supports RAID device discovery, RAID set activation, creation,
 removal, rebuild and display of properties for ATARAID/DDF1 metadata on
@@ -65,9 +61,6 @@
 
 %prep
 %setup -q -n dmraid/%{version}
-%patch0 -p1
-%patch1 -p1
-%patch2 -p1
 
 %build
 %define _libdir /%{_lib}
@@ -90,10 +83,10 @@
 # If requested, install the libdmraid and libdmraid-events (for dmeventd) DSO
 install -m 755 lib/libdmraid.so \
 	$RPM_BUILD_ROOT%{_libdir}/libdmraid.so.%{version}
-(cd $RPM_BUILD_ROOT/%{_libdir} ; ln -sf libdmraid.so.%{version} libdmraid.so)
+(cd $RPM_BUILD_ROOT/%{_libdir} ; ln -sf libdmraid.so.%{version} libdmraid.so ; ln -sf libdmraid.so.%{version} libdmraid.so.1)
 install -m 755 lib/libdmraid-events-isw.so \
 	$RPM_BUILD_ROOT%{_libdir}/libdmraid-events-isw.so.%{version}
-(cd $RPM_BUILD_ROOT/%{_libdir} ; ln -sf libdmraid-events-isw.so.%{version} libdmraid-events-isw.so)
+(cd $RPM_BUILD_ROOT/%{_libdir} ; ln -sf libdmraid-events-isw.so.%{version} libdmraid-events-isw.so ; ln -sf libdmraid-events-isw.so.%{version} libdmraid-events-isw.so.1)
 
 # Install logwatch config file and script for dmeventd
 install -m 644 logwatch/dmeventd.conf $RPM_BUILD_ROOT/etc/logwatch/conf/services/dmeventd.conf
@@ -140,6 +133,10 @@
 %ghost /var/cache/logwatch/dmeventd/syslogpattern.txt
 
 %changelog
+* Tue Jan 12 2010  Heinz Mauelshagen <heinzm@redhat.com> - 1.0.0.rc16-4
+- Change dmraid DSO version to "1" and allow for display of 
+  extended internal library version
+
 * Tue Jan 12 2010  Heinz Mauelshagen <heinzm@redhat.com> - 1.0.0.rc16-3
 - Add logwatch files and move pattern file to /var/cache
 - Fix multiple options (eg. "-ccc") not recognized properly
--- dmraid/lib/version.h	2010/01/12 12:23:26	1.9
+++ dmraid/lib/version.h	2010/02/17 11:51:53	1.10
@@ -1,12 +1,12 @@
 #ifndef	DMRAID_LIB_VERSION
 
-#define	DMRAID_LIB_VERSION		"1.0.0.rc16-3"
+#define	DMRAID_LIB_VERSION		"1"
 
 #define	DMRAID_LIB_MAJOR_VERSION	1
 #define	DMRAID_LIB_MINOR_VERSION	0
 #define	DMRAID_LIB_SUBMINOR_VERSION	0
-#define	DMRAID_LIB_VERSION_SUFFIX	"rc16-3"
+#define	DMRAID_LIB_VERSION_SUFFIX	"rc16-4"
 
-#define	DMRAID_LIB_DATE			"(2010.01.12)"
+#define	DMRAID_LIB_DATE			"(2010.02.17)"
 
 #endif
--- dmraid/lib/misc/lib_context.c	2008/06/20 21:52:18	1.3
+++ dmraid/lib/misc/lib_context.c	2010/02/17 11:51:54	1.4
@@ -138,25 +138,30 @@
 static void
 init_version(struct lib_context *lc, void *arg)
 {
-	lc->version.text = DMRAID_LIB_VERSION;
+	static char version[80];
+
+	lc->version.text = version;
 	lc->version.date = DMRAID_LIB_DATE;
 	lc->version.v.major = DMRAID_LIB_MAJOR_VERSION;
 	lc->version.v.minor = DMRAID_LIB_MINOR_VERSION;
 	lc->version.v.sub_minor = DMRAID_LIB_SUBMINOR_VERSION;
 	lc->version.v.suffix = DMRAID_LIB_VERSION_SUFFIX;
+	snprintf(version, sizeof(version), "%d.%d.%d.%s",
+		 lc->version.v.major, lc->version.v.minor,
+		 lc->version.v.sub_minor, lc->version.v.suffix);
 }
 
 /* Put init functions into an array because of the potentially growing list. */
 struct init_fn {
 	void (*func) (struct lib_context * lc, void *arg);
 } init_fn[] = {
-	{
-	init_options}, {
-	init_cmd}, {
-	init_lists}, {
-	init_mode}, {
-	init_paths}, {
-init_version},};
+	{ init_options},
+	{ init_cmd},
+	{ init_lists},
+	{ init_mode},
+	{ init_paths},
+	{ init_version},
+};
 
 struct lib_context *
 alloc_lib_context(char **argv)
