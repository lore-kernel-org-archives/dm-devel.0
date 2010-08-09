From: bmarzins@sourceware.org
Subject: multipath-tools/multipathd main.c
Date: 9 Aug 2010 16:16:10 -0000
Message-ID: <20100809161610.8643.qmail@sourceware.org>
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
Changes by:	bmarzins@sourceware.org	2010-08-09 16:16:10

Modified files:
	multipathd     : main.c 

Log message:
	Fix for bz #614966
	
	Occasionally, the kernel sends out remove uevents when the multipath device
	hasn't been removed.  multipathd should never remove the device when it gets
	these events, since they are only suspposed to be generated after the device
	has already been removed.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipathd/main.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.69.2.27&r2=1.69.2.28

--- multipath-tools/multipathd/main.c	2010/06/23 16:28:08	1.69.2.27
+++ multipath-tools/multipathd/main.c	2010/08/09 16:16:10	1.69.2.28
@@ -299,8 +299,18 @@
 static int
 uev_remove_map (char * devname, struct vectors * vecs)
 {
+	struct multipath * mpp;
+
 	condlog(2, "%s: remove map (uevent)", devname);
-	return ev_remove_map(devname, vecs);
+
+	mpp = find_mp_by_str(vecs->mpvec, devname);
+	if (!mpp) {
+		condlog(2, "%s: devmap not registered, can't remove", devname);
+		return 0;
+	}
+	orphan_paths(vecs->pathvec, mpp);
+	remove_map(mpp, vecs, stop_waiter_thread, 1);
+	return 0;
 }
 
 int
