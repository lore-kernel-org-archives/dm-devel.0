From: bmarzins@sourceware.org
Subject: multipath-tools/libmultipath structs.h
Date: 12 Jul 2012 17:08:48 -0000
Message-ID: <20120712170848.9457.qmail@sourceware.org>
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
Module name:	multipath-tools
Branch: 	RHEL5_FC6
Changes by:	bmarzins@sourceware.org	2012-07-12 17:08:47

Modified files:
	libmultipath   : structs.h 

Log message:
	fix for bz #744231. Change default setting for calculating pg_prio. Not
	applicable upstream

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/structs.h.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.18.2.11&r2=1.18.2.12

--- multipath-tools/libmultipath/structs.h	2012/07/11 23:03:34	1.18.2.11
+++ multipath-tools/libmultipath/structs.h	2012/07/12 17:08:47	1.18.2.12
@@ -86,8 +86,8 @@
 };
 
 enum pg_prio_calc_states {
-	PG_PRIO_CALC_SUM,
 	PG_PRIO_CALC_AVG,
+	PG_PRIO_CALC_SUM,
 };
 
 enum log_checker_err_states {
