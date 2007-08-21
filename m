From: agk@sourceware.org
Subject: device-mapper ./COPYING.LIB ./WHATS_NEW dmeven ...
Date: 21 Aug 2007 16:26:13 -0000
Message-ID: <20070821162613.1866.qmail@sourceware.org>
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
Module name:	device-mapper
Changes by:	agk@sourceware.org	2007-08-21 16:26:08

Modified files:
	.              : COPYING.LIB WHATS_NEW 
	dmeventd       : Makefile.in dmeventd.h libdevmapper-event.c 
	                 libdevmapper-event.h 
	dmsetup        : Makefile.in dmsetup.c 
	include        : .symlinks Makefile.in intl.h kdev_t.h lib.h 
	                 list.h log.h 
	lib            : Makefile.in libdevmapper.h libdm-common.c 
	                 libdm-common.h libdm-deptree.c libdm-file.c 
	                 libdm-report.c libdm-string.c 
	lib/datastruct : bitset.c bitset.h hash.c hash.h 
	lib/ioctl      : libdm-compat.h libdm-iface.c libdm-targets.h 
	lib/mm         : dbg_malloc.c dbg_malloc.h pool-debug.c 
	                 pool-fast.c pool.c pool.h 
	lib/regex      : matcher.c parse_rx.c parse_rx.h ttree.c ttree.h 
	multilog       : libmultilog.c 
	multilog/pthread_lock: pthread_lock.c 
	po             : Makefile.in pogen.h 
Removed files:
	lib            : libdm-file.h 

Log message:
	Fix inconsistent licence notices: executables are GPLv2; libraries LGPLv2.1.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/COPYING.LIB.diff?cvsroot=dm&r1=1.1&r2=1.2
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/WHATS_NEW.diff?cvsroot=dm&r1=1.199&r2=1.200
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/dmeventd/Makefile.in.diff?cvsroot=dm&r1=1.18&r2=1.19
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/dmeventd/dmeventd.h.diff?cvsroot=dm&r1=1.4&r2=1.5
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/dmeventd/libdevmapper-event.c.diff?cvsroot=dm&r1=1.24&r2=1.25
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/dmeventd/libdevmapper-event.h.diff?cvsroot=dm&r1=1.13&r2=1.14
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/dmsetup/Makefile.in.diff?cvsroot=dm&r1=1.16&r2=1.17
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/dmsetup/dmsetup.c.diff?cvsroot=dm&r1=1.94&r2=1.95
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/include/.symlinks.diff?cvsroot=dm&r1=1.8&r2=1.9
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/include/Makefile.in.diff?cvsroot=dm&r1=1.6&r2=1.7
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/include/intl.h.diff?cvsroot=dm&r1=1.2&r2=1.3
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/include/kdev_t.h.diff?cvsroot=dm&r1=1.2&r2=1.3
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/include/lib.h.diff?cvsroot=dm&r1=1.5&r2=1.6
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/include/list.h.diff?cvsroot=dm&r1=1.5&r2=1.6
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/include/log.h.diff?cvsroot=dm&r1=1.10&r2=1.11
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/Makefile.in.diff?cvsroot=dm&r1=1.33&r2=1.34
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/libdevmapper.h.diff?cvsroot=dm&r1=1.73&r2=1.74
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/libdm-common.c.diff?cvsroot=dm&r1=1.45&r2=1.46
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/libdm-common.h.diff?cvsroot=dm&r1=1.3&r2=1.4
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/libdm-deptree.c.diff?cvsroot=dm&r1=1.31&r2=1.32
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/libdm-file.c.diff?cvsroot=dm&r1=1.8&r2=1.9
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/libdm-report.c.diff?cvsroot=dm&r1=1.14&r2=1.15
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/libdm-string.c.diff?cvsroot=dm&r1=1.8&r2=1.9
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/libdm-file.h.diff?cvsroot=dm&r1=1.1&r2=NONE
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/datastruct/bitset.c.diff?cvsroot=dm&r1=1.3&r2=1.4
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/datastruct/bitset.h.diff?cvsroot=dm&r1=1.2&r2=1.3
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/datastruct/hash.c.diff?cvsroot=dm&r1=1.6&r2=1.7
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/datastruct/hash.h.diff?cvsroot=dm&r1=1.2&r2=1.3
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/ioctl/libdm-compat.h.diff?cvsroot=dm&r1=1.9&r2=1.10
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/ioctl/libdm-iface.c.diff?cvsroot=dm&r1=1.45&r2=1.46
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/ioctl/libdm-targets.h.diff?cvsroot=dm&r1=1.20&r2=1.21
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/mm/dbg_malloc.c.diff?cvsroot=dm&r1=1.10&r2=1.11
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/mm/dbg_malloc.h.diff?cvsroot=dm&r1=1.3&r2=1.4
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/mm/pool-debug.c.diff?cvsroot=dm&r1=1.2&r2=1.3
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/mm/pool-fast.c.diff?cvsroot=dm&r1=1.3&r2=1.4
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/mm/pool.c.diff?cvsroot=dm&r1=1.2&r2=1.3
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/mm/pool.h.diff?cvsroot=dm&r1=1.2&r2=1.3
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/regex/matcher.c.diff?cvsroot=dm&r1=1.1&r2=1.2
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/regex/parse_rx.c.diff?cvsroot=dm&r1=1.1&r2=1.2
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/regex/parse_rx.h.diff?cvsroot=dm&r1=1.1&r2=1.2
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/regex/ttree.c.diff?cvsroot=dm&r1=1.1&r2=1.2
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/regex/ttree.h.diff?cvsroot=dm&r1=1.1&r2=1.2
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/multilog/libmultilog.c.diff?cvsroot=dm&r1=1.18&r2=1.19
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/multilog/pthread_lock/pthread_lock.c.diff?cvsroot=dm&r1=1.2&r2=1.3
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/po/Makefile.in.diff?cvsroot=dm&r1=1.3&r2=1.4
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/po/pogen.h.diff?cvsroot=dm&r1=1.2&r2=1.3

--- device-mapper/COPYING.LIB	2001/12/11 15:53:38	1.1
+++ device-mapper/COPYING.LIB	2007/08/21 16:26:06	1.2
@@ -1,14 +1,14 @@
+		  GNU LESSER GENERAL PUBLIC LICENSE
+		       Version 2.1, February 1999
 
-		  GNU LIBRARY GENERAL PUBLIC LICENSE
-		       Version 2, June 1991
-
- Copyright (C) 1991 Free Software Foundation, Inc.
- 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA
+ Copyright (C) 1991, 1999 Free Software Foundation, Inc.
+ 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
  Everyone is permitted to copy and distribute verbatim copies
  of this license document, but changing it is not allowed.
 
-[This is the first released version of the library GPL.  It is
- numbered 2 because it goes with version 2 of the ordinary GPL.]
+[This is the first released version of the Lesser GPL.  It also counts
+ as the successor of the GNU Library Public License, version 2, hence
+ the version number 2.1.]
 
 			    Preamble
 
@@ -17,97 +17,109 @@
 Licenses are intended to guarantee your freedom to share and change
 free software--to make sure the software is free for all its users.
 
-  This license, the Library General Public License, applies to some
-specially designated Free Software Foundation software, and to any
-other libraries whose authors decide to use it.  You can use it for
-your libraries, too.
-
-  When we speak of free software, we are referring to freedom, not
-price.  Our General Public Licenses are designed to make sure that you
-have the freedom to distribute copies of free software (and charge for
-this service if you wish), that you receive source code or can get it
-if you want it, that you can change the software or use pieces of it
-in new free programs; and that you know you can do these things.
+  This license, the Lesser General Public License, applies to some
+specially designated software packages--typically libraries--of the
+Free Software Foundation and other authors who decide to use it.  You
+can use it too, but we suggest you first think carefully about whether
+this license or the ordinary General Public License is the better
+strategy to use in any particular case, based on the explanations below.
+
+  When we speak of free software, we are referring to freedom of use,
+not price.  Our General Public Licenses are designed to make sure that
+you have the freedom to distribute copies of free software (and charge
+for this service if you wish); that you receive source code or can get
+it if you want it; that you can change the software and use pieces of
+it in new free programs; and that you are informed that you can do
+these things.
 
   To protect your rights, we need to make restrictions that forbid
-anyone to deny you these rights or to ask you to surrender the rights.
-These restrictions translate to certain responsibilities for you if
-you distribute copies of the library, or if you modify it.
+distributors to deny you these rights or to ask you to surrender these
+rights.  These restrictions translate to certain responsibilities for
+you if you distribute copies of the library or if you modify it.
 
   For example, if you distribute copies of the library, whether gratis
 or for a fee, you must give the recipients all the rights that we gave
 you.  You must make sure that they, too, receive or can get the source
-code.  If you link a program with the library, you must provide
-complete object files to the recipients so that they can relink them
-with the library, after making changes to the library and recompiling
+code.  If you link other code with the library, you must provide
+complete object files to the recipients, so that they can relink them
+with the library after making changes to the library and recompiling
 it.  And you must show them these terms so they know their rights.
 
-  Our method of protecting your rights has two steps: (1) copyright
-the library, and (2) offer you this license which gives you legal
+  We protect your rights with a two-step method: (1) we copyright the
+library, and (2) we offer you this license, which gives you legal
 permission to copy, distribute and/or modify the library.
 
-  Also, for each distributor's protection, we want to make certain
-that everyone understands that there is no warranty for this free
-library.  If the library is modified by someone else and passed on, we
-want its recipients to know that what they have is not the original
-version, so that any problems introduced by others will not reflect on
-the original authors' reputations.
+  To protect each distributor, we want to make it very clear that
+there is no warranty for the free library.  Also, if the library is
+modified by someone else and passed on, the recipients should know
+that what they have is not the original version, so that the original
+author's reputation will not be affected by problems that might be
+introduced by others.
 
-  Finally, any free program is threatened constantly by software
-patents.  We wish to avoid the danger that companies distributing free
-software will individually obtain patent licenses, thus in effect
-transforming the program into proprietary software.  To prevent this,
-we have made it clear that any patent must be licensed for everyone's
-free use or not licensed at all.
-
-  Most GNU software, including some libraries, is covered by the ordinary
-GNU General Public License, which was designed for utility programs.  This
-license, the GNU Library General Public License, applies to certain
-designated libraries.  This license is quite different from the ordinary
-one; be sure to read it in full, and don't assume that anything in it is
-the same as in the ordinary license.
-
-  The reason we have a separate public license for some libraries is that
-they blur the distinction we usually make between modifying or adding to a
-program and simply using it.  Linking a program with a library, without
-changing the library, is in some sense simply using the library, and is
-analogous to running a utility program or application program.  However, in
-a textual and legal sense, the linked executable is a combined work, a
-derivative of the original library, and the ordinary General Public License
-treats it as such.
-
-  Because of this blurred distinction, using the ordinary General
-Public License for libraries did not effectively promote software
-sharing, because most developers did not use the libraries.  We
-concluded that weaker conditions might promote sharing better.
-
-  However, unrestricted linking of non-free programs would deprive the
-users of those programs of all benefit from the free status of the
-libraries themselves.  This Library General Public License is intended to
-permit developers of non-free programs to use free libraries, while
-preserving your freedom as a user of such programs to change the free
-libraries that are incorporated in them.  (We have not seen how to achieve
-this as regards changes in header files, but we have achieved it as regards
-changes in the actual functions of the Library.)  The hope is that this
-will lead to faster development of free libraries.
+  Finally, software patents pose a constant threat to the existence of
+any free program.  We wish to make sure that a company cannot
+effectively restrict the users of a free program by obtaining a
+restrictive license from a patent holder.  Therefore, we insist that
+any patent license obtained for a version of the library must be
+consistent with the full freedom of use specified in this license.
+
+  Most GNU software, including some libraries, is covered by the
+ordinary GNU General Public License.  This license, the GNU Lesser
+General Public License, applies to certain designated libraries, and
+is quite different from the ordinary General Public License.  We use
+this license for certain libraries in order to permit linking those
+libraries into non-free programs.
+
+  When a program is linked with a library, whether statically or using
+a shared library, the combination of the two is legally speaking a
+combined work, a derivative of the original library.  The ordinary
+General Public License therefore permits such linking only if the
+entire combination fits its criteria of freedom.  The Lesser General
+Public License permits more lax criteria for linking other code with
+the library.
+
+  We call this license the "Lesser" General Public License because it
+does Less to protect the user's freedom than the ordinary General
+Public License.  It also provides other free software developers Less
+of an advantage over competing non-free programs.  These disadvantages
+are the reason we use the ordinary General Public License for many
+libraries.  However, the Lesser license provides advantages in certain
+special circumstances.
+
+  For example, on rare occasions, there may be a special need to
+encourage the widest possible use of a certain library, so that it becomes
+a de-facto standard.  To achieve this, non-free programs must be
+allowed to use the library.  A more frequent case is that a free
+library does the same job as widely used non-free libraries.  In this
+case, there is little to gain by limiting the free library to free
+software only, so we use the Lesser General Public License.
+
+  In other cases, permission to use a particular library in non-free
+programs enables a greater number of people to use a large body of
+free software.  For example, permission to use the GNU C Library in
+non-free programs enables many more people to use the whole GNU
+operating system, as well as its variant, the GNU/Linux operating
+system.
+
+  Although the Lesser General Public License is Less protective of the
+users' freedom, it does ensure that the user of a program that is
+linked with the Library has the freedom and the wherewithal to run
+that program using a modified version of the Library.
 
   The precise terms and conditions for copying, distribution and
 modification follow.  Pay close attention to the difference between a
 "work based on the library" and a "work that uses the library".  The
-former contains code derived from the library, while the latter only
-works together with the library.
-
-  Note that it is possible for a library to be covered by the ordinary
-General Public License rather than by this special one.
+former contains code derived from the library, whereas the latter must
+be combined with the library in order to run.
 
-		  GNU LIBRARY GENERAL PUBLIC LICENSE
+		  GNU LESSER GENERAL PUBLIC LICENSE
    TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
 
-  0. This License Agreement applies to any software library which
-contains a notice placed by the copyright holder or other authorized
-party saying it may be distributed under the terms of this Library
-General Public License (also called "this License").  Each licensee is
-addressed as "you".
+  0. This License Agreement applies to any software library or other
+program which contains a notice placed by the copyright holder or
+other authorized party saying it may be distributed under the terms of
+this Lesser General Public License (also called "this License").
+Each licensee is addressed as "you".
 
   A "library" means a collection of software functions and/or data
 prepared so as to be conveniently linked with application programs
@@ -256,7 +268,7 @@
 Any executables containing that work also fall under Section 6,
 whether or not they are linked directly with the Library itself.
 
-  6. As an exception to the Sections above, you may also compile or
+  6. As an exception to the Sections above, you may also combine or
 link a "work that uses the Library" with the Library to produce a
 work containing portions of the Library, and distribute that work
 under terms of your choice, provided that the terms permit
@@ -283,23 +295,31 @@
     Library will not necessarily be able to recompile the application
     to use the modified definitions.)
 
-    b) Accompany the work with a written offer, valid for at
+    b) Use a suitable shared library mechanism for linking with the
+    Library.  A suitable mechanism is one that (1) uses at run time a
+    copy of the library already present on the user's computer system,
+    rather than copying library functions into the executable, and (2)
+    will operate properly with a modified version of the library, if
+    the user installs one, as long as the modified version is
+    interface-compatible with the version that the work was made with.
+
+    c) Accompany the work with a written offer, valid for at
     least three years, to give the same user the materials
     specified in Subsection 6a, above, for a charge no more
     than the cost of performing this distribution.
 
-    c) If distribution of the work is made by offering access to copy
+    d) If distribution of the work is made by offering access to copy
     from a designated place, offer equivalent access to copy the above
     specified materials from the same place.
 
-    d) Verify that the user has already received a copy of these
+    e) Verify that the user has already received a copy of these
     materials or that you have already sent this user a copy.
 
   For an executable, the required form of the "work that uses the
 Library" must include any data and utility programs needed for
 reproducing the executable from it.  However, as a special exception,
-the source code distributed need not include anything that is normally
-distributed (in either source or binary form) with the major
+the materials to be distributed need not include anything that is
+normally distributed (in either source or binary form) with the major
 components (compiler, kernel, and so on) of the operating system on
 which the executable runs, unless that component itself accompanies
 the executable.
@@ -348,7 +368,7 @@
 original licensor to copy, distribute, link with or modify the Library
 subject to these terms and conditions.  You may not impose any further
 restrictions on the recipients' exercise of the rights granted herein.
-You are not responsible for enforcing compliance by third parties to
+You are not responsible for enforcing compliance by third parties with
 this License.
 
   11. If, as a consequence of a court judgment or allegation of patent
@@ -391,7 +411,7 @@
 written in the body of this License.
 
   13. The Free Software Foundation may publish revised and/or new
-versions of the Library General Public License from time to time.
+versions of the Lesser General Public License from time to time.
 Such new versions will be similar in spirit to the present version,
 but may differ in detail to address new problems or concerns.
 
@@ -437,7 +457,7 @@
 
 		     END OF TERMS AND CONDITIONS
 
-     Appendix: How to Apply These Terms to Your New Libraries
+           How to Apply These Terms to Your New Libraries
 
   If you develop a new library, and you want it to be of the greatest
 possible use to the public, we recommend making it free software that
@@ -454,19 +474,18 @@
     Copyright (C) <year>  <name of author>
 
     This library is free software; you can redistribute it and/or
-    modify it under the terms of the GNU Library General Public
+    modify it under the terms of the GNU Lesser General Public
     License as published by the Free Software Foundation; either
-    version 2 of the License, or (at your option) any later version.
+    version 2.1 of the License, or (at your option) any later version.
 
     This library is distributed in the hope that it will be useful,
     but WITHOUT ANY WARRANTY; without even the implied warranty of
     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
-    Library General Public License for more details.
+    Lesser General Public License for more details.
 
-    You should have received a copy of the GNU Library General Public
-    License along with this library; if not, write to the Free
-    Software Foundation, Inc., 59 Temple Place - Suite 330, Boston,
-    MA 02111-1307, USA
+    You should have received a copy of the GNU Lesser General Public
+    License along with this library; if not, write to the Free Software
+    Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
 
 Also add information on how to contact you by electronic and paper mail.
 
@@ -481,3 +500,5 @@
   Ty Coon, President of Vice
 
 That's all there is to it!
+
+
--- device-mapper/WHATS_NEW	2007/08/14 19:11:31	1.199
+++ device-mapper/WHATS_NEW	2007/08/21 16:26:06	1.200
@@ -1,9 +1,10 @@
 Version 1.02.22 - 
 ================================
+  Fix inconsistent licence notices: executables are GPLv2; libraries LGPLv2.1.
   Update to use autoconf 2.61, while still supporting 2.57.
   Avoid repeated dm_task free on some dm_event_get_registered_device errors.
   Introduce log_sys_* macros from LVM2.
-  Export dm_fclose and dm_create_dir.
+  Export dm_fclose and dm_create_dir; remove libdm-file.h.
   Don't log EROFS mkdir failures in _create_dir_recursive (for LVM2).
   Add fclose wrapper dm_fclose that catches write failures (using ferror).
 
--- device-mapper/dmeventd/Makefile.in	2007/01/11 16:23:22	1.18
+++ device-mapper/dmeventd/Makefile.in	2007/08/21 16:26:06	1.19
@@ -1,5 +1,5 @@
 #
-# Copyright (C) 2005 Red Hat, Inc. All rights reserved.
+# Copyright (C) 2005-2007 Red Hat, Inc. All rights reserved.
 #
 # This file is part of the device-mapper userspace tools.
 #
--- device-mapper/dmeventd/dmeventd.h	2007/02/02 17:08:51	1.4
+++ device-mapper/dmeventd/dmeventd.h	2007/08/21 16:26:06	1.5
@@ -1,3 +1,17 @@
+/*
+ * Copyright (C) 2005-2007 Red Hat, Inc. All rights reserved.
+ *
+ * This file is part of the device-mapper userspace tools.
+ *
+ * This copyrighted material is made available to anyone wishing to use,
+ * modify, copy, or redistribute it subject to the terms and conditions
+ * of the GNU Lesser General Public License v.2.1.
+ *
+ * You should have received a copy of the GNU Lesser General Public License
+ * along with this program; if not, write to the Free Software Foundation,
+ * Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
 #ifndef __DMEVENTD_DOT_H__
 #define __DMEVENTD_DOT_H__
 
--- device-mapper/dmeventd/libdevmapper-event.c	2007/08/05 00:13:02	1.24
+++ device-mapper/dmeventd/libdevmapper-event.c	2007/08/21 16:26:06	1.25
@@ -1,5 +1,5 @@
 /*
- * Copyright (C) 2005 Red Hat, Inc. All rights reserved.
+ * Copyright (C) 2005-2007 Red Hat, Inc. All rights reserved.
  *
  * This file is part of the device-mapper userspace tools.
  *
--- device-mapper/dmeventd/libdevmapper-event.h	2007/01/23 17:38:39	1.13
+++ device-mapper/dmeventd/libdevmapper-event.h	2007/08/21 16:26:06	1.14
@@ -1,5 +1,5 @@
 /*
- * Copyright (C) 2005 Red Hat, Inc. All rights reserved.
+ * Copyright (C) 2005-2007 Red Hat, Inc. All rights reserved.
  *
  * This file is part of the device-mapper userspace tools.
  *
--- device-mapper/dmsetup/Makefile.in	2007/01/11 16:23:22	1.16
+++ device-mapper/dmsetup/Makefile.in	2007/08/21 16:26:06	1.17
@@ -1,6 +1,6 @@
 #
 # Copyright (C) 2001-2004 Sistina Software, Inc. All rights reserved.
-# Copyright (C) 2004 Red Hat, Inc. All rights reserved.
+# Copyright (C) 2004-2007 Red Hat, Inc. All rights reserved.
 #
 # This file is part of the device-mapper userspace tools.
 #
--- device-mapper/dmsetup/dmsetup.c	2007/06/19 16:50:38	1.94
+++ device-mapper/dmsetup/dmsetup.c	2007/08/21 16:26:06	1.95
@@ -1,7 +1,7 @@
 /*
  * Copyright (C) 2001-2004 Sistina Software, Inc. All rights reserved.
  * Copyright (C) 2004-2007 Red Hat, Inc. All rights reserved.
- * Copyright (C) 2005-2007 NEC Corperation
+ * Copyright (C) 2005-2007 NEC Corporation
  *
  * This file is part of the device-mapper userspace tools.
  *
--- device-mapper/include/.symlinks	2005/12/02 15:39:16	1.8
+++ device-mapper/include/.symlinks	2007/08/21 16:26:06	1.9
@@ -1,5 +1,4 @@
 ../lib/libdevmapper.h
-../lib/libdm-file.h
 ../dmeventd/libdevmapper-event.h
 ../multilog/libmultilog.h
 ../po/pogen.h
--- device-mapper/include/Makefile.in	2006/05/10 19:38:25	1.6
+++ device-mapper/include/Makefile.in	2007/08/21 16:26:06	1.7
@@ -1,6 +1,6 @@
 #
 # Copyright (C) 2001-2004 Sistina Software, Inc. All rights reserved.
-# Copyright (C) 2004 Red Hat, Inc. All rights reserved.
+# Copyright (C) 2004-2006 Red Hat, Inc. All rights reserved.
 #
 # This file is part of the device-mapper userspace tools.
 #
--- device-mapper/include/intl.h	2007/04/27 19:07:42	1.2
+++ device-mapper/include/intl.h	2007/08/21 16:26:06	1.3
@@ -1,14 +1,14 @@
 /*
  * Copyright (C) 2004 Sistina Software, Inc. All rights reserved.  
- * Copyright (C) 2004-2005 Red Hat, Inc. All rights reserved.
+ * Copyright (C) 2004-2007 Red Hat, Inc. All rights reserved.
  *
  * This file is part of the device-mapper userspace tools.
  *
  * This copyrighted material is made available to anyone wishing to use,
  * modify, copy, or redistribute it subject to the terms and conditions
- * of the GNU General Public License v.2.
+ * of the GNU Lesser General Public License v.2.1.
  *
- * You should have received a copy of the GNU General Public License
+ * You should have received a copy of the GNU Lesser General Public License
  * along with this program; if not, write to the Free Software Foundation,
  * Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
--- device-mapper/include/kdev_t.h	2007/04/27 19:07:43	1.2
+++ device-mapper/include/kdev_t.h	2007/08/21 16:26:06	1.3
@@ -1,5 +1,5 @@
 /*
- * Copyright (C) 2004 Red Hat, Inc. All rights reserved.
+ * Copyright (C) 2004-2007 Red Hat, Inc. All rights reserved.
  *
  * This file is part of the device-mapper userspace tools.
  *
--- device-mapper/include/lib.h	2007/04/27 19:07:43	1.5
+++ device-mapper/include/lib.h	2007/08/21 16:26:06	1.6
@@ -1,14 +1,14 @@
 /*
  * Copyright (C) 2001-2004 Sistina Software, Inc. All rights reserved.  
- * Copyright (C) 2004-2005 Red Hat, Inc. All rights reserved.
+ * Copyright (C) 2004-2007 Red Hat, Inc. All rights reserved.
  *
  * This file is part of the device-mapper userspace tools.
  *
  * This copyrighted material is made available to anyone wishing to use,
  * modify, copy, or redistribute it subject to the terms and conditions
- * of the GNU General Public License v.2.
+ * of the GNU Lesser General Public License v.2.1.
  *
- * You should have received a copy of the GNU General Public License
+ * You should have received a copy of the GNU Lesser General Public License
  * along with this program; if not, write to the Free Software Foundation,
  * Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
--- device-mapper/include/list.h	2007/04/27 19:07:43	1.5
+++ device-mapper/include/list.h	2007/08/21 16:26:06	1.6
@@ -1,6 +1,6 @@
 /*
  * Copyright (C) 2001-2004 Sistina Software, Inc. All rights reserved.
- * Copyright (C) 2004-2005 Red Hat, Inc. All rights reserved.
+ * Copyright (C) 2004-2007 Red Hat, Inc. All rights reserved.
  *
  * This file is part of the device-mapper userspace tools.
  *
--- device-mapper/include/log.h	2007/07/28 10:23:01	1.10
+++ device-mapper/include/log.h	2007/08/21 16:26:06	1.11
@@ -1,6 +1,6 @@
 /*
  * Copyright (C) 2001-2004 Sistina Software, Inc. All rights reserved.
- * Copyright (C) 2004 Red Hat, Inc. All rights reserved.
+ * Copyright (C) 2004-2007 Red Hat, Inc. All rights reserved.
  *
  * This file is part of the device-mapper userspace tools.
  *
--- device-mapper/lib/Makefile.in	2007/04/27 18:40:23	1.33
+++ device-mapper/lib/Makefile.in	2007/08/21 16:26:06	1.34
@@ -1,6 +1,6 @@
 #
 # Copyright (C) 2001-2004 Sistina Software, Inc. All rights reserved.
-# Copyright (C) 2004-2005 Red Hat, Inc. All rights reserved.
+# Copyright (C) 2004-2007 Red Hat, Inc. All rights reserved.
 #
 # This file is part of the device-mapper userspace tools.
 #
--- device-mapper/lib/libdevmapper.h	2007/08/06 13:09:46	1.73
+++ device-mapper/lib/libdevmapper.h	2007/08/21 16:26:06	1.74
@@ -1,6 +1,6 @@
 /*
  * Copyright (C) 2001-2004 Sistina Software, Inc. All rights reserved.
- * Copyright (C) 2004-2005 Red Hat, Inc. All rights reserved.
+ * Copyright (C) 2004-2007 Red Hat, Inc. All rights reserved.
  *
  * This file is part of the device-mapper userspace tools.
  *
--- device-mapper/lib/libdm-common.c	2007/07/28 10:23:01	1.45
+++ device-mapper/lib/libdm-common.c	2007/08/21 16:26:06	1.46
@@ -1,6 +1,6 @@
 /*
  * Copyright (C) 2001-2004 Sistina Software, Inc. All rights reserved.
- * Copyright (C) 2004-2005 Red Hat, Inc. All rights reserved.
+ * Copyright (C) 2004-2007 Red Hat, Inc. All rights reserved.
  *
  * This file is part of the device-mapper userspace tools.
  *
--- device-mapper/lib/libdm-common.h	2007/01/19 15:53:01	1.3
+++ device-mapper/lib/libdm-common.h	2007/08/21 16:26:06	1.4
@@ -1,6 +1,6 @@
 /*
  * Copyright (C) 2001-2004 Sistina Software, Inc. All rights reserved.
- * Copyright (C) 2004-2005 Red Hat, Inc. All rights reserved.
+ * Copyright (C) 2004-2007 Red Hat, Inc. All rights reserved.
  *
  * This file is part of the device-mapper userspace tools.
  *
--- device-mapper/lib/libdm-deptree.c	2007/01/22 15:03:57	1.31
+++ device-mapper/lib/libdm-deptree.c	2007/08/21 16:26:06	1.32
@@ -1,5 +1,5 @@
 /*
- * Copyright (C) 2005 Red Hat, Inc. All rights reserved.
+ * Copyright (C) 2005-2007 Red Hat, Inc. All rights reserved.
  *
  * This file is part of the device-mapper userspace tools.
  *
--- device-mapper/lib/libdm-file.c	2007/07/28 10:48:36	1.8
+++ device-mapper/lib/libdm-file.c	2007/08/21 16:26:06	1.9
@@ -1,20 +1,19 @@
 /*
  * Copyright (C) 2001-2004 Sistina Software, Inc. All rights reserved.  
- * Copyright (C) 2004-2005 Red Hat, Inc. All rights reserved.
+ * Copyright (C) 2004-2007 Red Hat, Inc. All rights reserved.
  *
  * This file is part of the device-mapper userspace tools.
  *
  * This copyrighted material is made available to anyone wishing to use,
  * modify, copy, or redistribute it subject to the terms and conditions
- * of the GNU General Public License v.2.
+ * of the GNU Lesser General Public License v.2.1.
  *
- * You should have received a copy of the GNU General Public License
+ * You should have received a copy of the GNU Lesser General Public License
  * along with this program; if not, write to the Free Software Foundation,
  * Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 
 #include "lib.h"
-#include "libdm-file.h"
 
 #include <sys/file.h>
 #include <fcntl.h>
--- device-mapper/lib/libdm-report.c	2007/04/27 15:22:27	1.14
+++ device-mapper/lib/libdm-report.c	2007/08/21 16:26:06	1.15
@@ -1,15 +1,14 @@
 /*
  * Copyright (C) 2002-2004 Sistina Software, Inc. All rights reserved.
- * Copyright (C) 2004 Red Hat, Inc. All rights reserved.
+ * Copyright (C) 2004-2007 Red Hat, Inc. All rights reserved.
  *
- * This file is part of device-mapper userspace tools.
- * The code is based on LVM2 report function.
+ * This file is part of the device-mapper userspace tools.
  *
  * This copyrighted material is made available to anyone wishing to use,
  * modify, copy, or redistribute it subject to the terms and conditions
- * of the GNU General Public License v.2.
+ * of the GNU Lesser General Public License v.2.1.
  *
- * You should have received a copy of the GNU General Public License
+ * You should have received a copy of the GNU Lesser General Public License
  * along with this program; if not, write to the Free Software Foundation,
  * Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
--- device-mapper/lib/libdm-string.c	2007/04/27 14:52:40	1.8
+++ device-mapper/lib/libdm-string.c	2007/08/21 16:26:06	1.9
@@ -1,13 +1,13 @@
 /*
- * Copyright (C) 2006 Red Hat, Inc. All rights reserved.
+ * Copyright (C) 2006-2007 Red Hat, Inc. All rights reserved.
  *
  * This file is part of the device-mapper userspace tools.
  *
  * This copyrighted material is made available to anyone wishing to use,
  * modify, copy, or redistribute it subject to the terms and conditions
- * of the GNU General Public License v.2.
+ * of the GNU Lesser General Public License v.2.1.
  *
- * You should have received a copy of the GNU General Public License
+ * You should have received a copy of the GNU Lesser General Public License
  * along with this program; if not, write to the Free Software Foundation,
  * Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
--- device-mapper/lib/datastruct/bitset.c	2006/01/31 14:50:38	1.3
+++ device-mapper/lib/datastruct/bitset.c	2007/08/21 16:26:06	1.4
@@ -1,14 +1,14 @@
 /*
  * Copyright (C) 2001-2004 Sistina Software, Inc. All rights reserved.  
- * Copyright (C) 2004-2005 Red Hat, Inc. All rights reserved.
+ * Copyright (C) 2004-2006 Red Hat, Inc. All rights reserved.
  *
  * This file is part of the device-mapper userspace tools.
  *
  * This copyrighted material is made available to anyone wishing to use,
  * modify, copy, or redistribute it subject to the terms and conditions
- * of the GNU General Public License v.2.
+ * of the GNU Lesser General Public License v.2.1.
  *
- * You should have received a copy of the GNU General Public License
+ * You should have received a copy of the GNU Lesser General Public License
  * along with this program; if not, write to the Free Software Foundation,
  * Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
--- device-mapper/lib/datastruct/bitset.h	2007/04/27 19:07:43	1.2
+++ device-mapper/lib/datastruct/bitset.h	2007/08/21 16:26:06	1.3
@@ -1,14 +1,14 @@
 /*
  * Copyright (C) 2001-2004 Sistina Software, Inc. All rights reserved.  
- * Copyright (C) 2004-2005 Red Hat, Inc. All rights reserved.
+ * Copyright (C) 2004-2007 Red Hat, Inc. All rights reserved.
  *
  * This file is part of the device-mapper userspace tools.
  *
  * This copyrighted material is made available to anyone wishing to use,
  * modify, copy, or redistribute it subject to the terms and conditions
- * of the GNU General Public License v.2.
+ * of the GNU Lesser General Public License v.2.1.
  *
- * You should have received a copy of the GNU General Public License
+ * You should have received a copy of the GNU Lesser General Public License
  * along with this program; if not, write to the Free Software Foundation,
  * Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
--- device-mapper/lib/datastruct/hash.c	2007/04/27 14:52:40	1.6
+++ device-mapper/lib/datastruct/hash.c	2007/08/21 16:26:06	1.7
@@ -1,14 +1,14 @@
 /*
  * Copyright (C) 2001-2004 Sistina Software, Inc. All rights reserved.
- * Copyright (C) 2004-2005 Red Hat, Inc. All rights reserved.
+ * Copyright (C) 2004-2007 Red Hat, Inc. All rights reserved.
  *
  * This file is part of the device-mapper userspace tools.
  *
  * This copyrighted material is made available to anyone wishing to use,
  * modify, copy, or redistribute it subject to the terms and conditions
- * of the GNU General Public License v.2.
+ * of the GNU Lesser General Public License v.2.1.
  *
- * You should have received a copy of the GNU General Public License
+ * You should have received a copy of the GNU Lesser General Public License
  * along with this program; if not, write to the Free Software Foundation,
  * Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
--- device-mapper/lib/datastruct/hash.h	2007/04/27 19:07:43	1.2
+++ device-mapper/lib/datastruct/hash.h	2007/08/21 16:26:06	1.3
@@ -1,14 +1,14 @@
 /*
  * Copyright (C) 2001-2004 Sistina Software, Inc. All rights reserved.
- * Copyright (C) 2004-2005 Red Hat, Inc. All rights reserved.
+ * Copyright (C) 2004-2007 Red Hat, Inc. All rights reserved.
  *
  * This file is part of the device-mapper userspace tools.
  *
  * This copyrighted material is made available to anyone wishing to use,
  * modify, copy, or redistribute it subject to the terms and conditions
- * of the GNU General Public License v.2.
+ * of the GNU Lesser General Public License v.2.1.
  *
- * You should have received a copy of the GNU General Public License
+ * You should have received a copy of the GNU Lesser General Public License
  * along with this program; if not, write to the Free Software Foundation,
  * Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
--- device-mapper/lib/ioctl/libdm-compat.h	2006/02/20 23:55:58	1.9
+++ device-mapper/lib/ioctl/libdm-compat.h	2007/08/21 16:26:07	1.10
@@ -1,6 +1,6 @@
 /*
  * Copyright (C) 2001-2004 Sistina Software, Inc. All rights reserved.
- * Copyright (C) 2004 Red Hat, Inc. All rights reserved.
+ * Copyright (C) 2004-2006 Red Hat, Inc. All rights reserved.
  *
  * This file is part of the device-mapper userspace tools.
  *
--- device-mapper/lib/ioctl/libdm-iface.c	2007/07/28 10:48:36	1.45
+++ device-mapper/lib/ioctl/libdm-iface.c	2007/08/21 16:26:07	1.46
@@ -1,6 +1,6 @@
 /*
  * Copyright (C) 2001-2004 Sistina Software, Inc. All rights reserved.
- * Copyright (C) 2004-2005 Red Hat, Inc. All rights reserved.
+ * Copyright (C) 2004-2007 Red Hat, Inc. All rights reserved.
  *
  * This file is part of the device-mapper userspace tools.
  *
@@ -16,7 +16,6 @@
 #include "lib.h"
 #include "libdm-targets.h"
 #include "libdm-common.h"
-#include "libdm-file.h"
 
 #ifdef DM_COMPAT
 #  include "libdm-compat.h"
--- device-mapper/lib/ioctl/libdm-targets.h	2006/10/12 17:29:05	1.20
+++ device-mapper/lib/ioctl/libdm-targets.h	2007/08/21 16:26:07	1.21
@@ -1,6 +1,6 @@
 /*
  * Copyright (C) 2001-2004 Sistina Software, Inc. All rights reserved.
- * Copyright (C) 2004 Red Hat, Inc. All rights reserved.
+ * Copyright (C) 2004-2006 Red Hat, Inc. All rights reserved.
  *
  * This file is part of the device-mapper userspace tools.
  *
--- device-mapper/lib/mm/dbg_malloc.c	2007/01/22 15:03:57	1.10
+++ device-mapper/lib/mm/dbg_malloc.c	2007/08/21 16:26:07	1.11
@@ -1,14 +1,14 @@
 /*
  * Copyright (C) 2001-2004 Sistina Software, Inc. All rights reserved.  
- * Copyright (C) 2004-2005 Red Hat, Inc. All rights reserved.
+ * Copyright (C) 2004-2007 Red Hat, Inc. All rights reserved.
  *
  * This file is part of the device-mapper userspace tools.
  *
  * This copyrighted material is made available to anyone wishing to use,
  * modify, copy, or redistribute it subject to the terms and conditions
- * of the GNU General Public License v.2.
+ * of the GNU Lesser General Public License v.2.1.
  *
- * You should have received a copy of the GNU General Public License
+ * You should have received a copy of the GNU Lesser General Public License
  * along with this program; if not, write to the Free Software Foundation,
  * Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
--- device-mapper/lib/mm/dbg_malloc.h	2007/04/27 19:07:43	1.3
+++ device-mapper/lib/mm/dbg_malloc.h	2007/08/21 16:26:07	1.4
@@ -1,14 +1,14 @@
 /*
  * Copyright (C) 2001-2004 Sistina Software, Inc. All rights reserved.  
- * Copyright (C) 2004-2005 Red Hat, Inc. All rights reserved.
+ * Copyright (C) 2004-2007 Red Hat, Inc. All rights reserved.
  *
  * This file is part of the device-mapper userspace tools.
  *
  * This copyrighted material is made available to anyone wishing to use,
  * modify, copy, or redistribute it subject to the terms and conditions
- * of the GNU General Public License v.2.
+ * of the GNU Lesser General Public License v.2.1.
  *
- * You should have received a copy of the GNU General Public License
+ * You should have received a copy of the GNU Lesser General Public License
  * along with this program; if not, write to the Free Software Foundation,
  * Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
--- device-mapper/lib/mm/pool-debug.c	2005/10/16 22:57:20	1.2
+++ device-mapper/lib/mm/pool-debug.c	2007/08/21 16:26:07	1.3
@@ -6,9 +6,9 @@
  *
  * This copyrighted material is made available to anyone wishing to use,
  * modify, copy, or redistribute it subject to the terms and conditions
- * of the GNU General Public License v.2.
+ * of the GNU Lesser General Public License v.2.1.
  *
- * You should have received a copy of the GNU General Public License
+ * You should have received a copy of the GNU Lesser General Public License
  * along with this program; if not, write to the Free Software Foundation,
  * Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
--- device-mapper/lib/mm/pool-fast.c	2006/01/31 14:50:38	1.3
+++ device-mapper/lib/mm/pool-fast.c	2007/08/21 16:26:07	1.4
@@ -1,14 +1,14 @@
 /*
  * Copyright (C) 2001-2004 Sistina Software, Inc. All rights reserved.   
- * Copyright (C) 2004-2005 Red Hat, Inc. All rights reserved.
+ * Copyright (C) 2004-2006 Red Hat, Inc. All rights reserved.
  *
  * This file is part of the device-mapper userspace tools.
  *
  * This copyrighted material is made available to anyone wishing to use,
  * modify, copy, or redistribute it subject to the terms and conditions
- * of the GNU General Public License v.2.
+ * of the GNU Lesser General Public License v.2.1.
  *
- * You should have received a copy of the GNU General Public License
+ * You should have received a copy of the GNU Lesser General Public License
  * along with this program; if not, write to the Free Software Foundation,
  * Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
--- device-mapper/lib/mm/pool.c	2005/10/16 22:57:20	1.2
+++ device-mapper/lib/mm/pool.c	2007/08/21 16:26:07	1.3
@@ -6,9 +6,9 @@
  *
  * This copyrighted material is made available to anyone wishing to use,
  * modify, copy, or redistribute it subject to the terms and conditions
- * of the GNU General Public License v.2.
+ * of the GNU Lesser General Public License v.2.1.
  *
- * You should have received a copy of the GNU General Public License
+ * You should have received a copy of the GNU Lesser General Public License
  * along with this program; if not, write to the Free Software Foundation,
  * Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
--- device-mapper/lib/mm/pool.h	2007/04/27 19:07:43	1.2
+++ device-mapper/lib/mm/pool.h	2007/08/21 16:26:07	1.3
@@ -1,14 +1,14 @@
 /*
  * Copyright (C) 2001-2004 Sistina Software, Inc. All rights reserved.  
- * Copyright (C) 2004-2005 Red Hat, Inc. All rights reserved.
+ * Copyright (C) 2004-2007 Red Hat, Inc. All rights reserved.
  *
  * This file is part of the device-mapper userspace tools.
  *
  * This copyrighted material is made available to anyone wishing to use,
  * modify, copy, or redistribute it subject to the terms and conditions
- * of the GNU General Public License v.2.
+ * of the GNU Lesser General Public License v.2.1.
  *
- * You should have received a copy of the GNU General Public License
+ * You should have received a copy of the GNU Lesser General Public License
  * along with this program; if not, write to the Free Software Foundation,
  * Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
--- device-mapper/lib/regex/matcher.c	2007/04/27 18:40:23	1.1
+++ device-mapper/lib/regex/matcher.c	2007/08/21 16:26:07	1.2
@@ -6,9 +6,9 @@
  *
  * This copyrighted material is made available to anyone wishing to use,
  * modify, copy, or redistribute it subject to the terms and conditions
- * of the GNU General Public License v.2.
+ * of the GNU Lesser General Public License v.2.1.
  *
- * You should have received a copy of the GNU General Public License
+ * You should have received a copy of the GNU Lesser General Public License
  * along with this program; if not, write to the Free Software Foundation,
  * Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
--- device-mapper/lib/regex/parse_rx.c	2007/04/27 18:40:23	1.1
+++ device-mapper/lib/regex/parse_rx.c	2007/08/21 16:26:07	1.2
@@ -6,9 +6,9 @@
  *
  * This copyrighted material is made available to anyone wishing to use,
  * modify, copy, or redistribute it subject to the terms and conditions
- * of the GNU General Public License v.2.
+ * of the GNU Lesser General Public License v.2.1.
  *
- * You should have received a copy of the GNU General Public License
+ * You should have received a copy of the GNU Lesser General Public License
  * along with this program; if not, write to the Free Software Foundation,
  * Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
--- device-mapper/lib/regex/parse_rx.h	2007/04/27 18:40:23	1.1
+++ device-mapper/lib/regex/parse_rx.h	2007/08/21 16:26:07	1.2
@@ -6,9 +6,9 @@
  *
  * This copyrighted material is made available to anyone wishing to use,
  * modify, copy, or redistribute it subject to the terms and conditions
- * of the GNU General Public License v.2.
+ * of the GNU Lesser General Public License v.2.1.
  *
- * You should have received a copy of the GNU General Public License
+ * You should have received a copy of the GNU Lesser General Public License
  * along with this program; if not, write to the Free Software Foundation,
  * Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
--- device-mapper/lib/regex/ttree.c	2007/04/27 18:40:23	1.1
+++ device-mapper/lib/regex/ttree.c	2007/08/21 16:26:07	1.2
@@ -6,9 +6,9 @@
  *
  * This copyrighted material is made available to anyone wishing to use,
  * modify, copy, or redistribute it subject to the terms and conditions
- * of the GNU General Public License v.2.
+ * of the GNU Lesser General Public License v.2.1.
  *
- * You should have received a copy of the GNU General Public License
+ * You should have received a copy of the GNU Lesser General Public License
  * along with this program; if not, write to the Free Software Foundation,
  * Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
--- device-mapper/lib/regex/ttree.h	2007/04/27 18:40:23	1.1
+++ device-mapper/lib/regex/ttree.h	2007/08/21 16:26:07	1.2
@@ -6,9 +6,9 @@
  *
  * This copyrighted material is made available to anyone wishing to use,
  * modify, copy, or redistribute it subject to the terms and conditions
- * of the GNU General Public License v.2.
+ * of the GNU Lesser General Public License v.2.1.
  *
- * You should have received a copy of the GNU General Public License
+ * You should have received a copy of the GNU Lesser General Public License
  * along with this program; if not, write to the Free Software Foundation,
  * Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
--- device-mapper/multilog/libmultilog.c	2007/03/16 14:36:16	1.18
+++ device-mapper/multilog/libmultilog.c	2007/08/21 16:26:07	1.19
@@ -1,5 +1,5 @@
 /*
- * Copyright (C) 2005 Red Hat, Inc. All rights reserved.
+ * Copyright (C) 2005-2007 Red Hat, Inc. All rights reserved.
  *
  * This file is part of the device-mapper userspace tools.
  *
--- device-mapper/multilog/pthread_lock/pthread_lock.c	2007/03/16 14:36:16	1.2
+++ device-mapper/multilog/pthread_lock/pthread_lock.c	2007/08/21 16:26:07	1.3
@@ -1,5 +1,5 @@
 /*
- * Copyright (C) 2005 Red Hat, Inc. All rights reserved.
+ * Copyright (C) 2005-2007 Red Hat, Inc. All rights reserved.
  *
  * This file is part of the device-mapper userspace tools.
  *
--- device-mapper/po/Makefile.in	2006/02/02 17:39:23	1.3
+++ device-mapper/po/Makefile.in	2007/08/21 16:26:07	1.4
@@ -1,5 +1,5 @@
 #
-# Copyright (C) 2004 Red Hat, Inc. All rights reserved.
+# Copyright (C) 2004-2006 Red Hat, Inc. All rights reserved.
 #
 # This file is part of the device-mapper userspace tools.
 #
--- device-mapper/po/pogen.h	2006/01/31 14:50:38	1.2
+++ device-mapper/po/pogen.h	2007/08/21 16:26:07	1.3
@@ -1,14 +1,14 @@
 /*
  * Copyright (C) 2001-2004 Sistina Software, Inc. All rights reserved.
- * Copyright (C) 2004 Red Hat, Inc. All rights reserved.
+ * Copyright (C) 2004-2006 Red Hat, Inc. All rights reserved.
  *
  * This file is part of the device-mapper userspace tools.
  *
  * This copyrighted material is made available to anyone wishing to use,
  * modify, copy, or redistribute it subject to the terms and conditions
- * of the GNU General Public License v.2.
+ * of the GNU Lesser General Public License v.2.1.
  *
- * You should have received a copy of the GNU General Public License
+ * You should have received a copy of the GNU Lesser General Public License
  * along with this program; if not, write to the Free Software Foundation,
  * Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
