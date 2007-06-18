From: bmarzins@sourceware.org
Subject: multipath-tools Makefile
Date: 18 Jun 2007 22:59:47 -0000
Message-ID: <20070618225947.26450.qmail@sourceware.org>
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
Changes by:	bmarzins@sourceware.org	2007-06-18 22:59:47

Modified files:
	.              : Makefile 

Log message:
	added missing pp_rdac directory to Makefile

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/Makefile.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.7.2.1&r2=1.7.2.2

--- multipath-tools/Makefile	2007/06/18 17:37:17	1.7.2.1
+++ multipath-tools/Makefile	2007/06/18 22:59:47	1.7.2.2
@@ -21,11 +21,11 @@
 export KRNLOBJ
 BUILDDIRS = multipath multipathd kpartx cciss_id path_priority/pp_alua \
 	    path_priority/pp_emc path_priority/pp_hds_modular \
-	    path_priority/pp_netapp path_priority/pp_tpc
+	    path_priority/pp_netapp path_priority/pp_rdac path_priority/pp_tpc
 
 ALLDIRS = multipath multipathd kpartx cciss_id path_priority/pp_alua \
 	  path_priority/pp_emc path_priority/pp_hds_modular \
-	  path_priority/pp_netapp path_priority/pp_tpc \
+	  path_priority/pp_netapp path_priority/pp_rdac path_priority/pp_tpc \
 	  libmultipath libcheckers
 
 VERSION = $(shell basename ${PWD} | cut -d'-' -f3)
