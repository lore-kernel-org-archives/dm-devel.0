From: agk@sourceware.org
Subject: device-mapper/lib libdm-report.c
Date: 23 Jan 2007 23:58:55 -0000
Message-ID: <20070123235855.30464.qmail@sourceware.org>
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
Changes by:	agk@sourceware.org	2007-01-23 23:58:55

Modified files:
	lib            : libdm-report.c 

Log message:
	fix earlier checkin

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/libdm-report.c.diff?cvsroot=dm&r1=1.8&r2=1.9

--- device-mapper/lib/libdm-report.c	2007/01/23 19:18:52	1.8
+++ device-mapper/lib/libdm-report.c	2007/01/23 23:58:55	1.9
@@ -799,9 +799,10 @@
 						log_error("dm_report: right-aligned snprintf() failed");
 						goto bad;
 					}
-					if (!dm_pool_grow_object(rh->mem, buf, width))
+					if (!dm_pool_grow_object(rh->mem, buf, width)) {
 						log_error("dm_report: Unable to extend output line");
 						goto bad;
+					}
 				}
 			}
 
