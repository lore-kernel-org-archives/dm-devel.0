From: heinzm@sourceware.org
Subject: dmraid/lib/events libdmraid-events-isw.c
Date: 19 Nov 2009 11:37:26 -0000
Message-ID: <20091119113726.4030.qmail@sourceware.org>
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
Module name:	dmraid
Changes by:	heinzm@sourceware.org	2009-11-19 11:37:25

Modified files:
	lib/events     : libdmraid-events-isw.c 

Log message:
	Fix: spare LED is still in rebuilding state even after manual rebuilding has finished

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/events/libdmraid-events-isw.c.diff?cvsroot=dm&r1=1.1&r2=1.2

--- dmraid/lib/events/libdmraid-events-isw.c	2009/09/16 11:45:13	1.1
+++ dmraid/lib/events/libdmraid-events-isw.c	2009/11/19 11:37:25	1.2
@@ -729,7 +729,7 @@
 			      _dso_perform(lc, lib_argv + lib_argc, action);
 
 			if (!ret &&
-			    action == GET_MEMBERS)
+			    action == GET_MEMBERS) 
 				ret = _repopulate(device, (char *)OPT_STR(lc, LC_REBUILD_SET));
 		}
 
@@ -1034,14 +1034,16 @@
 		break;
 
 	case REBUILD_END:
-		if (!_lib_main('F', dev_name) ||
-		    !_lib_main('r', dev_name))
+		if (!_lib_main('F', dev_name)) {
 			syslog(LOG_NOTICE, "Rebuild of RAID set %s complete",
-			       dev_name);
-
+					dev_name);
+			_lib_main('r', dev_name); 
+		} 
+			
 		/* Turn all RAID set LEDs off anyway, since it's in-sync.*/
 		/* Used also for manual rebuild. */
 		_dev_led_all(DSO_LED_OFF, rs);
+		break;
 	}
 
 	return ret;
