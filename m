From: heinzm@sourceware.org
Subject: dmraid CHANGELOG
Date: 19 Dec 2011 14:34:48 -0000
Message-ID: <20111219143448.18282.qmail@sourceware.org>
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
Changes by:	heinzm@sourceware.org	2011-12-19 14:34:48

Modified files:
	.              : CHANGELOG 

Log message:
	

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/CHANGELOG.diff?cvsroot=dm&r1=1.7&r2=1.8

--- dmraid/CHANGELOG	2009/09/16 11:45:11	1.7
+++ dmraid/CHANGELOG	2011/12/19 14:34:48	1.8
@@ -1,4 +1,18 @@
 
+Changelog from dmraid 1.0.0.rc16-1 to 1.0.0.rc16-4	2011.12.19
+o Added Ubuntu upstream patches [Philip Susi]
+  - fix hyphen used as minus sign in man pages
+  - support for checking virtio devices for dmraid metadata
+  - activate multiple raid sets
+  - probe isw disks with [some] HPA awareness
+  - fix isw raid0 sector calculation
+  - fix jmicron name
+  - dump all 4 sets of PDC metadata
+  - make partition separator follow standards
+
+
+....
+
 Changelog from dmraid 1.0.0.rc12 to 1.0.0.rc13		2006.10.11
 
 
