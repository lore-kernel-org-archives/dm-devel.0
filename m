From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 3/7] multipath-tools: stand out sections headings
	with comments at multipath.conf.5
Date: Sun,  7 Aug 2016 00:40:04 +0200
Message-ID: <1470523208-14067-3-git-send-email-xose.vazquez@gmail.com>
References: <1470523208-14067-1-git-send-email-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1470523208-14067-1-git-send-email-xose.vazquez@gmail.com>
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

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 multipath/multipath.conf.5 | 28 +++++++++++++++++++++++++++-
 1 file changed, 27 insertions(+), 1 deletion(-)

diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index ed5dd10..1a96acf 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -1,13 +1,19 @@
-.TH MULTIPATH.CONF 5 2016-07-08 "Linux"
+.TH MULTIPATH.CONF 5 2016-08-06 "Linux"
+.\" ----------------------------------------------------------------------------
 .SH NAME
+.\" ----------------------------------------------------------------------------
 multipath.conf \- multipath daemon configuration file.
+.\" ----------------------------------------------------------------------------
 .SH DESCRIPTION
+.\" ----------------------------------------------------------------------------
 .B "/etc/multipath.conf"
 is the configuration file for the multipath daemon. It is used to
 overwrite the built-in configuration table of \fBmultipathd\fP.
 Any line whose first non-white-space character is a '#' is considered
 a comment line. Empty lines are ignored.
+.\" ----------------------------------------------------------------------------
 .SH SYNTAX
+.\" ----------------------------------------------------------------------------
 The configuration file contains entries of the form:
 .RS
 .nf
@@ -67,7 +73,9 @@ This section defines values for attributes that should override the
 device-specific settings for all devices.
 .RE
 .LP
+.\" ----------------------------------------------------------------------------
 .SH "defaults section"
+.\" ----------------------------------------------------------------------------
 The \fIdefaults\fR section recognizes the following keywords:
 .TP 17
 .B verbosity
@@ -686,7 +694,9 @@ on a device until it receives a change uevent from the initial table load.
 Default value is: \fB30\fR
 .RE
 .
+.\" ----------------------------------------------------------------------------
 .SH "blacklist section"
+.\" ----------------------------------------------------------------------------
 The \fIblacklist\fR
 section is used to exclude specific device from inclusion in the
 multipath topology. It is most commonly used to exclude local disks or
@@ -710,7 +720,9 @@ and
 .B product
 keywords. For a full description of these keywords please see the
 \fIdevices\fR section description.
+.\" ----------------------------------------------------------------------------
 .SH "blacklist_exceptions section"
+.\" ----------------------------------------------------------------------------
 The \fIblacklist_exceptions\fR section is used to revert the actions of the
 \fIblacklist\fR section, for example to include specific device in the
 multipath topology. This allows one to selectively include devices which
@@ -744,7 +756,9 @@ The \fIproperty\fR blacklist and whitelist handling is different from the usual
 handling in the sense that the whitelist \fIhas\fR to be set, otherwise the
 device will be blacklisted. In these cases the message \fIblacklisted, udev
 property missing\fR will be displayed.
+.\" ----------------------------------------------------------------------------
 .SH "multipaths section"
+.\" ----------------------------------------------------------------------------
 The only recognized attribute for the \fImultipaths\fR section is the
 \fImultipath\fR subsection.
 .LP
@@ -797,7 +811,9 @@ section:
 .RE
 .PD
 .LP
+.\" ----------------------------------------------------------------------------
 .SH "devices section"
+.\" ----------------------------------------------------------------------------
 The only recognized attribute for the \fIdevices\fR section is the \fIdevice\fR
 subsection.
 .LP
@@ -894,7 +910,9 @@ section:
 .RE
 .PD
 .LP
+.\" ----------------------------------------------------------------------------
 .SH "overrides section"
+.\" ----------------------------------------------------------------------------
 The overrides section recognizes the following optional attributes; if not set
 the values are taken from the \fIdevices\fR or \fIdefaults\fR sections:
 .sp 1
@@ -949,7 +967,9 @@ the values are taken from the \fIdevices\fR or \fIdefaults\fR sections:
 .RE
 .PD
 .LP
+.\" ----------------------------------------------------------------------------
 .SH "WWID generation"
+.\" ----------------------------------------------------------------------------
 Multipath uses a \fIWorld Wide Identification\fR (WWID) to determine
 which paths belong to the same device. Each path presenting the same
 WWID is assumed to point to the same device.
@@ -973,7 +993,9 @@ variable.
 If none of the \fIgetuid_callout\fR or \fIuid_attribute\fR parameters
 are present multipath will try to use the sysfs attribute
 \fIvpd_pg83\fR to generate the WWID.
+.\" ----------------------------------------------------------------------------
 .SH "KNOWN ISSUES"
+.\" ----------------------------------------------------------------------------
 The usage of \fIqueue_if_no_path\fR option can lead to \fID state\fR
 processes being hung and not killable in situations where all the paths to the
 LUN go offline. It is advisable to use the \fIno_path_retry\fR option instead.
@@ -984,12 +1006,16 @@ while I/O is still queued. The multipath daemon will update the \fIdev_loss_tmo\
 setting accordingly to avoid this deadlock. Hence if both values are
 specified the order of precedence is \fIno_path_retry, queue_if_no_path, dev_loss_tmo.\fR
 
+.\" ----------------------------------------------------------------------------
 .SH "SEE ALSO"
+.\" ----------------------------------------------------------------------------
 .BR udev (8),
 .BR dmsetup (8),
 .BR multipath (8),
 .BR multipathd (8).
 
+.\" ----------------------------------------------------------------------------
 .SH AUTHORS
+.\" ----------------------------------------------------------------------------
 \fImultipath-tools\fR was developed by Christophe Varoqui, <christophe.varoqui@opensvc.com>
 and others.
-- 
2.7.4
