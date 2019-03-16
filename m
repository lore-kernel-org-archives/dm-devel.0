From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: maintain the uniformity in the
	multipath.conf.5 page
Date: Sat, 16 Mar 2019 23:25:56 +0100
Message-ID: <20190316222556.21437-1-xose.vazquez@gmail.com>
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
Cc: DM-DEVEL ML <dm-devel@redhat.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM-DEVEL ML <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 multipath/multipath.conf.5 | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index 0fe8461..b0648cc 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -260,11 +260,11 @@ The default is: \fB<unset>\fR
 The udev attribute providing a unique path identifier.
 .RS
 .TP
-The default is: for SCSI devices \fBID_SERIAL\fR
+The default is: \fBID_SERIAL\fR, for SCSI devices
 .TP
-The default is: for DASD devices \fBID_UID\fR
+The default is: \fBID_UID\fR, for DASD devices
 .TP
-The default is: for NVME devices \fBID_WWN\fR
+The default is: \fBID_WWN\fR, for NVMe devices
 .RE
 .
 .
@@ -670,7 +670,7 @@ This should be smaller than dev_loss_tmo. Setting this to
 will disable the timeout.
 .RS
 .TP
-The default is: in \fB5\fR
+The default is: \fB5\fR
 .RE
 .
 .
@@ -718,7 +718,7 @@ track of the persistent reservation key used for a specific WWID, when
 \fIreservation_key\fR is set to \fBfile\fR.
 .RS
 .TP
-The default is \fB/etc/multipath/prkeys\fR
+The default is: \fB/etc/multipath/prkeys\fR
 .RE
 .
 .
@@ -1186,7 +1186,7 @@ to switch the ghost paths to active ones. Setting this to \fI0\fR or \fIon\fR
 makes multipath immediately mark a device with only ghost paths as ready.
 .RS
 .TP
-The default is \fBno\fR
+The default is: \fBno\fR
 .RE
 .
 .
-- 
2.20.1
