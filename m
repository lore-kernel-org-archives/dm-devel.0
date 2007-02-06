From: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Subject: garbled output after rename map and rerun
Date: Tue, 6 Feb 2007 15:30:47 +0530
Message-ID: <20070206100047.GA2513@amitarora.in.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Last year in June, Lan Tran had submitted this patch. Unfortunately, it
didn't get any response. This problem is still hanging around.
I am resubmitting the same patch again, hoping that it may get some
attention this time.

This is a simple and straight forward fix. So, please include it in the
next release of multipath tools. Thanks!

Below is the original mail (with patch) that Lan had posted on 6th June,
2006:

-----------------------------------------------------------------------
There was some garbled output after renaming a multipath device and
rerunning multipath.
This is just a minor fix to add some actions that were missing.

Thanks,
lan

--- multipath-git/libmultipath/print.c	2006-06-05 14:26:52.000000000 -0700
+++ multipath-tools-2006.6.5-changed/libmultipath/print.c	2006-06-06 13:48:54.000000000 -0700
@@ -211,12 +211,16 @@
 snprint_action (char * buff, size_t len, struct multipath * mpp)
 {
 	switch (mpp->action) {
+	case ACT_REJECT: 
+		return snprint_str(buff, len, ACT_REJECT_STR); 
 	case ACT_RELOAD:
 		return snprint_str(buff, len, ACT_RELOAD_STR);
-	case ACT_CREATE:
-		return snprint_str(buff, len, ACT_CREATE_STR);
 	case ACT_SWITCHPG:
 		return snprint_str(buff, len, ACT_SWITCHPG_STR);
+	case ACT_RENAME: 
+		return snprint_str(buff, len, ACT_RENAME_STR); 
+	case ACT_CREATE:
+		return snprint_str(buff, len, ACT_CREATE_STR);
 	default:
 		return 0;
 	}
-----------------------------------------------------------------------

--
Regards,
Amit Arora <aarora@in.ibm.com>
