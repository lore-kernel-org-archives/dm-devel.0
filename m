From: heinzm@sourceware.org
Subject: dmraid dmraid.spec
Date: 16 Sep 2009 13:17:09 -0000
Message-ID: <20090916131709.9740.qmail@sourceware.org>
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
Changes by:	heinzm@sourceware.org	2009-09-16 13:17:09

Modified files:
	.              : dmraid.spec 

Log message:
	device-mapper-devel build requirement

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/dmraid.spec.diff?cvsroot=dm&r1=1.6&r2=1.7

--- dmraid/dmraid.spec	2009/09/16 11:45:11	1.6
+++ dmraid/dmraid.spec	2009/09/16 13:17:09	1.7
@@ -12,7 +12,7 @@
 Group: System Environment/Base
 URL: http://people.redhat.com/heinzm/sw/dmraid
 BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}-buildroot
-BuildRequires: device-mapper >= 1.02.02-2, libselinux-devel, libsepol-devel
+BuildRequires: device-mapper >= 1.02.02-2, device-mapper-devel, libselinux-devel, libsepol-devel
 Requires: dmraid-events kpartx
 Requires(postun): ldconfig
 Requires(post): ldconfig
