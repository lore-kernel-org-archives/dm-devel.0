From: heinzm@sourceware.org
Subject: dmraid ./dmraid.spec lib/format/ataraid/pdc.c  ...
Date: 2 Nov 2009 13:20:41 -0000
Message-ID: <20091102132041.6901.qmail@sourceware.org>
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
Module name:	dmraid
Changes by:	heinzm@sourceware.org	2009-11-02 13:20:41

Modified files:
	.              : dmraid.spec 
	lib/format/ataraid: pdc.c 
	lib/format/ddf : ddf1.c 

Log message:
	Fix manual pages and path. lsi metadata format handler DDF1 persistent name fix. pdc metadata format handler RAID10 number of devices in subset fix

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/dmraid.spec.diff?cvsroot=dm&r1=1.8&r2=1.9
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/format/ataraid/pdc.c.diff?cvsroot=dm&r1=1.6&r2=1.7
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/format/ddf/ddf1.c.diff?cvsroot=dm&r1=1.5&r2=1.6

--- dmraid/dmraid.spec	2009/09/17 11:52:41	1.8
+++ dmraid/dmraid.spec	2009/11/02 13:20:40	1.9
@@ -7,22 +7,26 @@
 Summary: dmraid (Device-mapper RAID tool and library)
 Name: dmraid
 Version: 1.0.0.rc16
-Release: 1%{?dist}
+Release: 2%{?dist}
 License: GPLv2+
 Group: System Environment/Base
 URL: http://people.redhat.com/heinzm/sw/dmraid
-BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}-buildroot
-BuildRequires: device-mapper >= 1.02.02-2
-BuildRequires: device-mapper-devel
-BuildRequires: device-mapper-event
+BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)
+BuildRequires: device-mapper-devel >= 1.02.02-2
+BuildRequires: device-mapper-event-devel
 BuildRequires: libselinux-devel
 BuildRequires: libsepol-devel
+Requires: device-mapper >= 1.02.02-2
 Requires: dmraid-events
 Requires: kpartx
-Requires(postun): ldconfig
-Requires(post): ldconfig
+Obsoletes: dmraid-libs < %{version}-%{release}
+Provides: dmraid-libs = %{version}-%{release}
 Source: ftp://people.redhat.com/heinzm/sw/dmraid/src/%{name}-%{version}.tar.bz2
 
+Patch0: dmraid-1.0.0.rc16-test_devices.patch
+Patch1: ddf1_lsi_persistent_name.patch
+Patch2: pdc_raid10_failure.patch
+
 %description
 DMRAID supports RAID device discovery, RAID set activation, creation,
 removal, rebuild and display of properties for ATARAID/DDF1 metadata on
@@ -31,9 +35,7 @@
 %package -n dmraid-devel
 Summary: Development libraries and headers for dmraid.
 Group: Development/Libraries
-License: GPLv2+
-Requires: %{name} = %{version}-%{release}
-Requires: %{name}-libs = %{version}-%{release}
+Requires: dmraid = %{version}-%{release}, sgpio
 
 %description -n dmraid-devel
 dmraid-devel provides a library interface for RAID device discovery,
@@ -43,6 +45,7 @@
 Summary: dmevent_tool (Device-mapper event tool) and DSO
 Group: System Environment/Base
 Requires: dmraid = %{version}-%{release}, sgpio
+Requires: device-mapper-event
 
 %description -n dmraid-events
 Provides a dmeventd DSO and the dmevent_tool to register devices with it
@@ -62,25 +65,26 @@
 
 %prep
 %setup -q -n dmraid/%{version}
+%patch0 -p1
+%patch1 -p1
+%patch2 -p1
 
 %build
-%configure --prefix=${RPM_BUILD_ROOT}/usr --sbindir=${RPM_BUILD_ROOT}/sbin --libdir=${RPM_BUILD_ROOT}/%{_libdir} --mandir=${RPM_BUILD_ROOT}/%{_mandir} --includedir=${RPM_BUILD_ROOT}/%{_includedir} --enable-debug --enable-libselinux --enable-libsepol --enable-static_link --enable-led --enable-intel_led
-make DESTDIR=$RPM_BUILD_ROOT
-mv tools/dmraid tools/dmraid.static
-make clean
-%configure --prefix=${RPM_BUILD_ROOT}/usr --sbindir=${RPM_BUILD_ROOT}/sbin --libdir=${RPM_BUILD_ROOT}/%{_libdir} --mandir=${RPM_BUILD_ROOT}/%{_mandir} --includedir=${RPM_BUILD_ROOT}/%{_includedir} --enable-debug --enable-libselinux --enable-libsepol --disable-static_linko --enable-led --enable-intel_led
+%define _libdir /%{_lib}
+
+%configure --prefix=${RPM_BUILD_ROOT}/usr --sbindir=${RPM_BUILD_ROOT}/sbin --libdir=${RPM_BUILD_ROOT}/%{_libdir} --mandir=${RPM_BUILD_ROOT}/%{_mandir} --includedir=${RPM_BUILD_ROOT}/%{_includedir} --enable-debug --enable-libselinux --enable-libsepol --disable-static_link --enable-led --enable-intel_led
 make DESTDIR=$RPM_BUILD_ROOT
 
 %install
 rm -rf $RPM_BUILD_ROOT
 install -m 755 -d $RPM_BUILD_ROOT{%{_libdir},/sbin,%{_sbindir},%{_bindir},%{_libdir},%{_includedir}/dmraid/,/var/lock/dmraid,/etc/cron.d/,/etc/logwatch/conf/services/,/etc/logwatch/scripts/services/}
 make DESTDIR=$RPM_BUILD_ROOT install
-
-# Install static dmraid binary
-install -m 755 tools/dmraid.static $RPM_BUILD_ROOT/sbin/dmraid.static
+ln -s dmraid $RPM_BUILD_ROOT/sbin/dmraid.static
 
 # Provide convenience link from dmevent_tool
 (cd $RPM_BUILD_ROOT/sbin ; ln -f dmevent_tool dm_dso_reg_tool)
+(cd $RPM_BUILD_ROOT/%{_mandir}/man8 ; ln -f dmevent_tool.8 dm_dso_reg_tool.8 ; ln -f dmraid.8 dmraid.static.8)
+
 install -m 644 include/dmraid/*.h $RPM_BUILD_ROOT%{_includedir}/dmraid/
 
 # If requested, install the libdmraid and libdmraid-events (for dmeventd) DSO
@@ -124,6 +128,7 @@
 %files -n dmraid-events
 %defattr(-,root,root)
 /%{_mandir}/man8/dmevent_tool*
+/%{_mandir}/man8/dm_dso_reg_tool*
 /sbin/dmevent_tool
 /sbin/dm_dso_reg_tool
 
@@ -134,7 +139,16 @@
 %ghost /etc/logwatch/scripts/services/dmeventd_syslogpattern.txt
 
 %changelog
-* Wed Sep 09 2008 Heinz Mauelshagen <heinzm@redhat.com> - 1.0.0.rc16-
+* Mon Nov 2 2009  Heinz Mauelshagen <heinzm@redhat.com> - 1.0.0.rc16-2
+- Fix manual path in specfile
+- fix manual pages for dmraid.static and dm_dso_reg_tool
+- ddf1 metadata format handler LSI persistent name fix
+- fix pdc metadata format handler to report the correct number
+  of devices in a RAID10 subset
+- move libraries to /lib* in order to avoid catch22
+  with unmountable /usr
+
+* Wed Sep 09 2008 Heinz Mauelshagen <heinzm@redhat.com> - 1.0.0.rc16-1
 - Updated
 
 * Wed Sep 17 2008 Heinz Mauelshagen <heinzm@redhat.com> - 1.0.0.rc15
--- dmraid/lib/format/ataraid/pdc.c	2009/09/16 11:45:14	1.6
+++ dmraid/lib/format/ataraid/pdc.c	2009/11/02 13:20:40	1.7
@@ -490,7 +490,9 @@
 	if (context && pdc->raid.type != PDC_T_SPAN)
 		*((uint64_t *) context) += rd->sectors;
 
-	return pdc->raid.total_disks;
+	return is_raid10(pdc) ?
+	       pdc->raid.total_disks / 2 :
+	       pdc->raid.total_disks;
 }
 
 static int
--- dmraid/lib/format/ddf/ddf1.c	2009/09/16 11:45:14	1.5
+++ dmraid/lib/format/ddf/ddf1.c	2009/11/02 13:20:41	1.6
@@ -696,6 +696,16 @@
 			sprintf(b, "%02x%02x%02x%02x",
 				vd->guid[i], vd->guid[i + 1],
 				vd->guid[i + 2], vd->guid[i + 3]);
+
+		/*
+		 * Because the LSI bios changes the timestamp in the
+		 * metadata on every boot, we have to neutralize it
+		 * in order to allow for persistent names.
+		 *
+		 * Using a dummy string "47114711" for that.
+		 */
+		if (!strncmp((char *) vd->guid, "LSI", 3))
+			strncpy(buf + prefix + 32, "47114711", 8);
 	}
 
 out:
