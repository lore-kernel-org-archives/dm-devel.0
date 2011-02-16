From: bmarzins@sourceware.org
Subject: multipath-tools/libmultipath configure.c struc ...
Date: 16 Feb 2011 19:00:53 -0000
Message-ID: <20110216190053.12944.qmail@sourceware.org>
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
Changes by:	bmarzins@sourceware.org	2011-02-16 19:00:52

Modified files:
	libmultipath   : configure.c structs_vec.c 

Log message:
	Fix for bz 677821.  Multipathd was not aways going into recovery mode when all
	paths went down, and no_path_retry was set to timeout because of two bugs.
	First off, multipathd was always resetting the hardware entry when it was
	updating the multipath device.  This caused problems when no paths were
	available to get the hardware information from.  Second, in one place,
	multipathd forgot to count ghost paths in nr_active paths, this allowed
	nr_active paths to go negative.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/configure.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.2.2.9&r2=1.2.2.10
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/structs_vec.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.1.2.5&r2=1.1.2.6

--- multipath-tools/libmultipath/configure.c	2010/06/23 16:28:07	1.2.2.9
+++ multipath-tools/libmultipath/configure.c	2011/02/16 19:00:51	1.2.2.10
@@ -77,7 +77,7 @@
 	if (mpp->pgpolicyfn && mpp->pgpolicyfn(mpp))
 		return 1;
 
-	mpp->nr_active = pathcount(mpp, PATH_UP);
+	mpp->nr_active = pathcount(mpp, PATH_UP) + pathcount(mpp, PATH_GHOST);
 
 	/*
 	 * ponders each path group and determine highest prio pg
--- multipath-tools/libmultipath/structs_vec.c	2010/06/23 16:28:07	1.1.2.5
+++ multipath-tools/libmultipath/structs_vec.c	2011/02/16 19:00:51	1.1.2.6
@@ -285,7 +285,8 @@
 	}
 
 	//adopt_paths(vecs->pathvec, mpp);
-	mpp->hwe = extract_hwe_from_path(mpp);
+	if (!mpp->hwe)
+		mpp->hwe = extract_hwe_from_path(mpp);
 	select_rr_weight(mpp);
 	select_pgfailback(mpp);
 	set_no_path_retry(mpp);
