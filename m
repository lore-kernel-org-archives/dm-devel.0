From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: replace IO by I/O in
	multipath.conf.5
Date: Mon, 17 Oct 2016 23:29:32 +0200
Message-ID: <20161017212932.2811-1-xose.vazquez@gmail.com>
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
Cc: device-mapper development <dm-devel@redhat.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

to be consistent with the rest of the text.

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 multipath/multipath.conf.5 | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index 4ab2917..eec319f 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -7,7 +7,7 @@
 .\"
 .\" ----------------------------------------------------------------------------
 .
-.TH MULTIPATH.CONF 5 2016-08-12 "Linux"
+.TH MULTIPATH.CONF 5 2016-10-18 "Linux"
 .
 .
 .\" ----------------------------------------------------------------------------
@@ -162,19 +162,19 @@ kernel multipath target. There are three selector algorithms:
 .RS
 .TP 12
 .I "round-robin 0"
-Loop through every path in the path group, sending the same amount of IO to
+Loop through every path in the path group, sending the same amount of I/O to
 each. Some aspects of behavior can be controlled with the attributes:
 \fIrr_min_io\fR, \fIrr_min_io_rq\fR and \fIrr_weight\fR.
 .TP
 .\" XXX
 .I "queue-length 0"
-(Since ??? kernel) Choose the path for the next bunch of IO based on the amount
-of outstanding IO to the path.
+(Since ??? kernel) Choose the path for the next bunch of I/O based on the amount
+of outstanding I/O to the path.
 .TP
 .\" XXX
 .I "service-time 0"
-(Since ??? kernel) Choose the path for the next bunch of IO based on the amount
-of outstanding IO to the path and its relative throughput.
+(Since ??? kernel) Choose the path for the next bunch of I/O based on the amount
+of outstanding I/O to the path and its relative throughput.
 .TP
 Default value is: \fBservice-time 0\fR
 .RE
@@ -342,7 +342,7 @@ Possible values for the feature list are:
 .TP 12
 .\" XXX
 .I queue_if_no_path
-(Superseded by \fIno_path_retry\fR) (Since ??? kernel) Queue IO if no path is active.
+(Superseded by \fIno_path_retry\fR) (Since ??? kernel) Queue I/O if no path is active.
 Identical to the \fIno_path_retry\fR with \fIqueue\fR value. See KNOWN ISSUES.
 .TP
 .I no_partitions
@@ -448,7 +448,7 @@ Default value is: \fBmanual\fR
 .
 .TP
 .B  rr_min_io
-Number of IO requests to route to a path before switching to the next in the
+Number of I/O requests to route to a path before switching to the next in the
 same path group. This is only for \fIBlock I/O\fR(BIO) based multipath and 
 only apply to \fIround-robin\fR path_selector.
 .RS
@@ -459,7 +459,7 @@ Default value is: \fB1000\fR
 .
 .TP
 .B rr_min_io_rq
-Number of IO requests to route to a path before switching to the next in the
+Number of I/O requests to route to a path before switching to the next in the
 same path group. This is only for \fIRequest\fR based multipath and
 only apply to \fIround-robin\fR path_selector.
 .RS
@@ -523,9 +523,9 @@ If set to
 , when multipathd stops, queueing will be turned off for all devices.
 This is useful for devices that set no_path_retry. If a machine is
 shut down while all paths to a device are down, it is possible to hang waiting
-for IO to return from the device after multipathd has been stopped. Without
+for I/O to return from the device after multipathd has been stopped. Without
 multipathd running, access to the paths cannot be restored, and the kernel
-cannot be told to stop queueing IO. Setting queue_without_daemon to
+cannot be told to stop queueing I/O. Setting queue_without_daemon to
 .I no
 , avoids this problem.
 .RS
@@ -574,7 +574,7 @@ Default value is: \fBno\fR
 .TP
 .B fast_io_fail_tmo
 Specify the number of seconds the SCSI layer will wait after a problem has been
-detected on a FC remote port before failing IO to devices on that remote port.
+detected on a FC remote port before failing I/O to devices on that remote port.
 This should be smaller than dev_loss_tmo. Setting this to
 .I off
 will disable the timeout.
-- 
2.10.1
