From: zkabelac@sourceware.org
Subject: dmraid make.tmpl.in
Date: 27 May 2010 13:29:47 -0000
Message-ID: <20100527132947.10076.qmail@sourceware.org>
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
Changes by:	zkabelac@sourceware.org	2010-05-27 13:29:46

Modified files:
	.              : make.tmpl.in 

Log message:
	remove  DESTDIR path from INCLUDES
	(compilation should be the same for  make DESTDIR=path as without it)

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/make.tmpl.in.diff?cvsroot=dm&r1=1.4&r2=1.5

--- dmraid/make.tmpl.in	2010/05/27 13:27:29	1.4
+++ dmraid/make.tmpl.in	2010/05/27 13:29:45	1.5
@@ -87,10 +87,6 @@
 
 STRIP=
 
-ifdef DESTDIR
-  INCLUDES+=-I$(DESTDIR)/usr/include
-endif
-
 DEPS=$(top_srcdir)/make.tmpl $(top_srcdir)/tools/VERSION Makefile
 
 OBJECTS=$(SOURCES:%.c=%.o)
