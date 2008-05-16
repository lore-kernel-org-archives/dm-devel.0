From: bmarzins@sourceware.org
Subject: multipath-tools ./Makefile path_priority/pp_hp ...
Date: 16 May 2008 20:07:29 -0000
Message-ID: <20080516200729.31347.qmail@sourceware.org>
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
Module name:	multipath-tools
Branch: 	RHEL4_FC5
Changes by:	bmarzins@sourceware.org	2008-05-16 20:07:27

Modified files:
	.              : Makefile 
Added files:
	path_priority/pp_hp_sw: Makefile pp_hp_sw.c 

Log message:
	Fix for bz #438037
	added Dave Wysochanski's hp storageworks priority callout patch

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/Makefile.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.6.2.2&r2=1.6.2.3
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/path_priority/pp_hp_sw/Makefile.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=NONE&r2=1.1.2.1
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/path_priority/pp_hp_sw/pp_hp_sw.c.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=NONE&r2=1.1.2.1

--- multipath-tools/Makefile	2007/07/24 20:35:24	1.6.2.2
+++ multipath-tools/Makefile	2008/05/16 20:07:26	1.6.2.3
@@ -23,13 +23,15 @@
 BUILDDIRS = libmultipath libcheckers path_priority/pp_emc \
 	    path_priority/pp_alua path_priority/pp_netapp \
 	    path_priority/pp_hds_modular path_priority/pp_tpc \
+	    path_priority/pp_hp_sw \
 	    multipath multipathd kpartx cciss_id
 ALLDIRS	= $(shell find . -type d -maxdepth 1 -mindepth 1)
 
 VERSION = $(shell basename ${PWD} | cut -d'-' -f3)
 INSTALLDIRS = multipath multipathd kpartx path_priority/pp_emc \
 	     path_priority/pp_alua path_priority/pp_netapp \
-	     path_priority/pp_hds_modular path_priority/pp_tpc cciss_id
+	     path_priority/pp_hds_modular path_priority/pp_tpc \
+	     path_priority/pp_hp_sw cciss_id
 
 
 all: recurse
