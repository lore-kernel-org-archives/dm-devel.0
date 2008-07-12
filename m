From: bmarzins@sourceware.org
Subject: multipath-tools ./Makefile path_priority/pp_hp ...
Date: 12 Jul 2008 01:24:08 -0000
Message-ID: <20080712012408.10489.qmail@sourceware.org>
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
Branch: 	RHEL5_FC6
Changes by:	bmarzins@sourceware.org	2008-07-12 01:24:07

Modified files:
	.              : Makefile 
Added files:
	path_priority/pp_hp_sw: Makefile pp_hp_sw.c 

Log message:
	Fix for bz 434988. Dave Wysochanski's backported mpath_prio_hp_sw priority
	checker.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/Makefile.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.7.2.2&r2=1.7.2.3
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/path_priority/pp_hp_sw/Makefile.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=NONE&r2=1.1.4.1
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/path_priority/pp_hp_sw/pp_hp_sw.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=NONE&r2=1.1.4.1

--- multipath-tools/Makefile	2007/06/18 22:59:47	1.7.2.2
+++ multipath-tools/Makefile	2008/07/12 01:24:07	1.7.2.3
@@ -21,11 +21,13 @@
 export KRNLOBJ
 BUILDDIRS = multipath multipathd kpartx cciss_id path_priority/pp_alua \
 	    path_priority/pp_emc path_priority/pp_hds_modular \
-	    path_priority/pp_netapp path_priority/pp_rdac path_priority/pp_tpc
+	    path_priority/pp_netapp path_priority/pp_rdac \
+	    path_priority/pp_tpc path_priority/pp_hp_sw
 
 ALLDIRS = multipath multipathd kpartx cciss_id path_priority/pp_alua \
 	  path_priority/pp_emc path_priority/pp_hds_modular \
-	  path_priority/pp_netapp path_priority/pp_rdac path_priority/pp_tpc \
+	  path_priority/pp_netapp path_priority/pp_rdac \
+	  path_priority/pp_hp_sw path_priority/pp_tpc \
 	  libmultipath libcheckers
 
 VERSION = $(shell basename ${PWD} | cut -d'-' -f3)
