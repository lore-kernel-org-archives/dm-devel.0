From: heinzm@sourceware.org
Subject: dmraid dmraid.spec
Date: 17 Sep 2009 11:52:42 -0000
Message-ID: <20090917115242.29707.qmail@sourceware.org>
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
Changes by:	heinzm@sourceware.org	2009-09-17 11:52:42

Modified files:
	.              : dmraid.spec 

Log message:
	Add device-mapper-event build dependency

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/dmraid.spec.diff?cvsroot=dm&r1=1.7&r2=1.8

--- dmraid/dmraid.spec	2009/09/16 13:17:09	1.7
+++ dmraid/dmraid.spec	2009/09/17 11:52:41	1.8
@@ -12,8 +12,13 @@
 Group: System Environment/Base
 URL: http://people.redhat.com/heinzm/sw/dmraid
 BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}-buildroot
-BuildRequires: device-mapper >= 1.02.02-2, device-mapper-devel, libselinux-devel, libsepol-devel
-Requires: dmraid-events kpartx
+BuildRequires: device-mapper >= 1.02.02-2
+BuildRequires: device-mapper-devel
+BuildRequires: device-mapper-event
+BuildRequires: libselinux-devel
+BuildRequires: libsepol-devel
+Requires: dmraid-events
+Requires: kpartx
 Requires(postun): ldconfig
 Requires(post): ldconfig
 Source: ftp://people.redhat.com/heinzm/sw/dmraid/src/%{name}-%{version}.tar.bz2
