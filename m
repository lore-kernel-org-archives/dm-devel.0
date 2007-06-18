From: bmarzins@sourceware.org
Subject: multipath-tools libcheckers/rdac.c multipathd/ ...
Date: 18 Jun 2007 21:12:55 -0000
Message-ID: <20070618211255.591.qmail@sourceware.org>
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
Changes by:	bmarzins@sourceware.org	2007-06-18 21:12:55

Modified files:
	libcheckers    : rdac.c 
	multipathd     : multipathd.init.redhat 

Log message:
	Pulled in a fix from upstream, and modified the redhat init script to
	standardise return codes for bz #242723

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libcheckers/rdac.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.1.2.1&r2=1.1.2.2
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipathd/multipathd.init.redhat.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.2.4.1&r2=1.2.4.2

--- multipath-tools/libcheckers/Attic/rdac.c	2007/04/24 18:50:42	1.1.2.1
+++ multipath-tools/libcheckers/Attic/rdac.c	2007/06/18 21:12:54	1.1.2.2
@@ -18,7 +18,7 @@
 #define INQUIRY_CMDLEN		6
 #define INQUIRY_CMD		0x12
 #define SENSE_BUFF_LEN		32
-#define DEF_TIMEOUT		60000
+#define RDAC_DEF_TIMEOUT	60000
 #define SCSI_CHECK_CONDITION	0x2
 #define SCSI_COMMAND_TERMINATED	0x22
 #define SG_ERR_DRIVER_SENSE	0x08
@@ -61,7 +61,7 @@
 	io_hdr.dxferp = resp;
 	io_hdr.cmdp = inqCmdBlk;
 	io_hdr.sbp = sense_b;
-	io_hdr.timeout = DEF_TIMEOUT;
+	io_hdr.timeout = RDAC_DEF_TIMEOUT;
 
 	if (ioctl(sg_fd, SG_IO, &io_hdr) < 0)
 		return 1;
--- multipath-tools/multipathd/multipathd.init.redhat	2007/04/30 18:06:52	1.2.4.1
+++ multipath-tools/multipathd/multipathd.init.redhat	2007/06/18 21:12:54	1.2.4.2
@@ -22,7 +22,6 @@
 	. $initdir/functions
 fi
  
-test -x $DAEMON || exit 0
 test -r $sysconfig/$prog && . $sysconfig/$prog
 
 RETVAL=0
@@ -32,6 +31,7 @@
 #
 
 start() {
+	test -x $DAEMON || exit 5
 	echo -n $"Starting $prog daemon: "
 	daemon $DAEMON
 	RETVAL=$?
@@ -84,7 +84,7 @@
 	;;
 *)
 	echo $"Usage: $0 {start|stop|status|restart|condrestart|reload}"
-	RETVAL=1
+	RETVAL=3
 esac
 
 exit $RETVAL
