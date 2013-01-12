From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH V3 11/18] multipath: update documentation
Date: Sat, 12 Jan 2013 00:04:48 -0600
Message-ID: <1357970695-3396-11-git-send-email-bmarzins@redhat.com>
References: <1357970695-3396-1-git-send-email-bmarzins@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1357970695-3396-1-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

Add some missing options to the documentation.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipath/main.c           |  1 +
 multipath/multipath.8      | 14 +++++++++++++-
 multipath/multipath.conf.5 | 31 +++++++++++++++++++++++++++++++
 3 files changed, 45 insertions(+), 1 deletion(-)

diff --git a/multipath/main.c b/multipath/main.c
index 396c4b9..e526f7c 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -101,6 +101,7 @@ usage (char * progname)
 		"  -d      dry run, do not create or update devmaps\n" \
 		"  -t      dump internal hardware table\n" \
 		"  -r      force devmap reload\n" \
+		"  -B      treat the bindings file as read only\n" \
 		"  -p      policy failover|multibus|group_by_serial|group_by_prio\n" \
 		"  -b fil  bindings file location\n" \
 		"  -p pol  force all maps to specified path grouping policy :\n" \
diff --git a/multipath/multipath.8 b/multipath/multipath.8
index a112df7..a63a9f1 100644
--- a/multipath/multipath.8
+++ b/multipath/multipath.8
@@ -5,8 +5,10 @@ multipath \- Device mapper target autoconfig
 .B multipath
 .RB [\| \-v\ \c
 .IR verbosity \|]
+.RB [\| \-b\ \c
+.IR bindings_file \|]
 .RB [\| \-d \|]
-.RB [\| \-h | \-l | \-ll | \-f | \-t | \-F \| \-B \|]
+.RB [\| \-h | \-l | \-ll | \-f | \-t | \-F | \-B | \-c | \-q | \|-r \|]
 .RB [\| \-p\ \c
 .BR failover | multibus | group_by_serial | group_by_prio | group_by_node_name \|]
 .RB [\| device \|]
@@ -56,6 +58,16 @@ force devmap reload
 .B \-B
 treat the bindings file as read only
 .TP
+.B \-b " bindings_file"
+set user_friendly_names bindings file location.  The default is
+/etc/multipath/bindings
+.TP
+.B \-c
+check if a block device should be a path in a multipath device
+.TP
+.B \-q
+allow device tables with queue_if_no_path when multipathd is not running
+.TP
 .BI \-p " policy"
 force new maps to use the specified policy:
 .RS 1.2i
diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index 92fb0c1..38c08f4 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -375,6 +375,31 @@ errors are logged at level 3 until the device is restored. If set to
 .I always
 , multipathd always logs the path checker error at logging level 2. Default is
 .I always
+.TP
+.B reservation_key
+This is the service action reservation key used by mpathpersist.  It must be
+set for all multipath devices using persistent reservations, and it must be
+the same as the RESERVATION KEY field of the PERSISTENT RESERVE OUT parameter
+list which contains an 8-byte value provided by the application client to the
+device server to identify the I_T nexus. It is unset by default.
+.TP
+.B retain_attached_hw_handler
+If set to
+.I yes
+and the scsi layer has already attached a hardware_handler to the device,
+multipath will not force the device to use the hardware_handler specified by
+mutipath.conf. If the scsi layer has not attached a hardware handler,
+multipath will continue to use its configured hardware handler. Default is
+.I no
+.TP
+.B detect_prio
+If set to
+.I yes
+, multipath will try to detect if the device supports ALUA. If so, the device
+will automatically use the
+.I alua
+prioritizer. If not, the prioritizer will be selected as usual. Default is
+.I no
 .
 .SH "blacklist section"
 The
@@ -474,6 +499,8 @@ section:
 .B rr_min_io_q
 .TP
 .B features
+.TP
+.B reservation_key
 .RE
 .PD
 .LP
@@ -560,6 +587,10 @@ section:
 .B dev_loss_tmo
 .TP
 .B flush_on_last_del
+.TP
+.B retain_attached_hw_handler
+.TP
+.B detect_prio
 .RE
 .PD
 .LP
-- 
1.8.0
