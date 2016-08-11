From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 02/11] multipath-tools: minor edit of
	multipath/multipath.conf.5
Date: Thu, 11 Aug 2016 20:32:18 +0200
Message-ID: <1470940345-4441-2-git-send-email-xose.vazquez@gmail.com>
References: <1470940345-4441-1-git-send-email-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1470940345-4441-1-git-send-email-xose.vazquez@gmail.com>
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

Split long lines, and change a text from place.

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 multipath/multipath.conf.5 | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index 3b66ddb..fd4b1f2 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -147,10 +147,11 @@ Default value is: \fBno\fR
 .
 .TP
 .B multipath_dir
-Directory where the dynamic shared objects are stored. Defined at compile time.
+Directory where the dynamic shared objects are stored.
 .RS
 .TP
-Default value is: \fB<system dependent>\fR, commonly \fI/lib64/multipath/\fR
+Default value is: \fB<system dependent>\fR. Defined at compile time, commonly
+\fI/lib64/multipath/\fR.
 .RE
 .
 .
@@ -303,8 +304,9 @@ regex can be of SCSI H:B:T:L format. For example: 1:0:.:. , *:0:0:.
 regex can be of device name format. For example: sda , sd.e
 .TP
 .I serial
-regex can be of serial number format. For example: .*J1FR.*324 . The serial can be looked
-up through sysfs or by running multipathd show paths format "%z". For example: 0395J1FR904324
+regex can be of serial number format. For example: .*J1FR.*324 . The serial can
+be looked up through sysfs or by running multipathd show paths format "%z". For
+example: 0395J1FR904324
 .TP
 .I wwn
 regex can be of the form \fI"host_wwnn:host_wwpn:target_wwnn:target_wwpn"\fR
@@ -336,8 +338,8 @@ Possible values for the feature list are:
 .RS
 .TP 12
 .I queue_if_no_path
-(Superseded by \fIno_path_retry\fR) Queue IO if no path is active. Identical to the \fIno_path_retry\fR with
-\fIqueue\fR value. See KNOWN ISSUES.
+(Superseded by \fIno_path_retry\fR) Queue IO if no path is active. Identical to
+the \fIno_path_retry\fR with \fIqueue\fR value. See KNOWN ISSUES.
 .TP
 .I no_partitions
 Disable automatic partitions generation via kpartx.
@@ -580,7 +582,8 @@ Default value is: \fB600\fR
 .
 .TP
 .B bindings_file
-The full pathname of the binding file to be used when the user_friendly_names option is set.
+The full pathname of the binding file to be used when the user_friendly_names
+option is set.
 .RS
 .TP
 Default value is: \fB/etc/multipath/bindings\fR
-- 
2.7.4
