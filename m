From: heinzm@sourceware.org
Subject: dmraid ./dmraid.spec lib/device/scan.c tools/V ...
Date: 2 Dec 2011 14:12:30 -0000
Message-ID: <20111202141230.9012.qmail@sourceware.org>
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
Changes by:	heinzm@sourceware.org	2011-12-02 14:12:29

Modified files:
	.              : dmraid.spec 
	lib/device     : scan.c 
	tools          : VERSION 

Log message:
	Avoid error messages for sector sizes != 512 bytes

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/dmraid.spec.diff?cvsroot=dm&r1=1.14&r2=1.15
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/device/scan.c.diff?cvsroot=dm&r1=1.5&r2=1.6
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/tools/VERSION.diff?cvsroot=dm&r1=1.9&r2=1.10

--- dmraid/dmraid.spec	2010/03/16 18:22:37	1.14
+++ dmraid/dmraid.spec	2011/12/02 14:12:28	1.15
@@ -7,7 +7,7 @@
 Summary: dmraid (Device-mapper RAID tool and library)
 Name: dmraid
 Version: 1.0.0.rc16
-Release: 5%{?dist}
+Release: 6%{?dist}
 License: GPLv2+
 Group: System Environment/Base
 URL: http://people.redhat.com/heinzm/sw/dmraid
@@ -65,7 +65,7 @@
 %build
 %define _libdir /%{_lib}
 
-%configure --prefix=/usr --sbindir=/sbin --libdir=%{_libdir} --mandir=%{_mandir} --includedir=%{_includedir} --enable-debug --enable-libselinux --enable-libsepol --disable-static_link --enable-led --enable-intel_led
+%configure --prefix=/usr --sbindir=/sbin --libdir=%{_libdir} --mandir=%{_mandir} --includedir=%{_includedir} --enable-debug --disable-static_link --enable-led --enable-intel_led
 make
 
 %install
@@ -125,6 +125,12 @@
 %ghost /var/cache/logwatch/dmeventd/syslogpattern.txt
 
 %changelog
+* Fri Dex 2 2011  Heinz Mauelshagen <heinzm@redhat.com> - 1.0.0.rc16-7
+- Avoid error message for sector sizes != 512 bytes
+
+* Mon May 31 2010  Heinz Mauelshagen <heinzm@redhat.com> - 1.0.0.rc16-6
+- remove superfluous libselinux/libsepol configure options
+
 * Tue Jan 12 2010  Heinz Mauelshagen <heinzm@redhat.com> - 1.0.0.rc16-5
 - Support DESTDIR in all Makefiles
 - Fix handling spares in RAID names in vendor metadata
--- dmraid/lib/device/scan.c	2010/07/13 20:11:21	1.5
+++ dmraid/lib/device/scan.c	2011/12/02 14:12:28	1.6
@@ -148,8 +148,11 @@
 		sector_size = DMRAID_SECTOR_SIZE;
 
 	if (sector_size != DMRAID_SECTOR_SIZE)
+		return 0;
+#if 0
 		LOG_ERR(lc, 0, "unsupported sector size %d on %s.",
 			sector_size, di->path);
+#endif
 
 	/* Use size device ioctl in case we didn't get the size from sysfs. */
 	if (!di->sectors && !ioctl(fd, BLKGETSIZE, &size))
--- dmraid/tools/VERSION	2010/01/12 12:23:26	1.9
+++ dmraid/tools/VERSION	2011/12/02 14:12:29	1.10
@@ -1 +1 @@
-1.0.0.rc16-3 (2010.01.12)
+1.0.0.rc16-3 (2010.11.12)
