From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 5/5] multipath-tools: add queue_mode to the
	features list in multipath/multipath.conf.5
Date: Tue, 16 Aug 2016 14:38:53 +0200
Message-ID: <1471351133-7892-5-git-send-email-xose.vazquez@gmail.com>
References: <1471351133-7892-1-git-send-email-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1471351133-7892-1-git-send-email-xose.vazquez@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Cc: device-mapper development <dm-devel@redhat.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

New undocumented feature, added in e83068a5f:

    dm mpath: add optional "queue_mode" feature

    Allow a user to specify an optional feature 'queue_mode <mode>' where
    <mode> may be "bio", "rq" or "mq" -- which corresponds to bio-based,
    request_fn rq-based, and blk-mq rq-based respectively.

    If the queue_mode feature isn't specified the default for the
    "multipath" target is still "rq" but if dm_mod.use_blk_mq is set to Y
    it'll default to mode "mq".

    This new queue_mode feature introduces the ability for each multipath
    device to have its own queue_mode (whereas before this feature all
    multipath devices effectively had to have the same queue_mode).

Also add more info to other features.

Cc: Mike Snitzer <snitzer@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 multipath/multipath.conf.5 | 36 ++++++++++++++++++++++++------------
 1 file changed, 24 insertions(+), 12 deletions(-)

diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index fd4b1f2..40df315 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -3,11 +3,11 @@
 .\" Make sure there are no errors with:
 .\" groff -z -wall -b -e -t multipath/multipath.conf.5
 .\"
-.\" TODO: Look for XXX
+.\" TODO: Look for XXX and ???
 .\"
 .\" ----------------------------------------------------------------------------
 .
-.TH MULTIPATH.CONF 5 2016-08-09 "Linux"
+.TH MULTIPATH.CONF 5 2016-08-12 "Linux"
 .
 .
 .\" ----------------------------------------------------------------------------
@@ -166,12 +166,15 @@ Loop through every path in the path group, sending the same amount of IO to
 each. Some aspects of behavior can be controlled with the attributes:
 \fIrr_min_io\fR, \fIrr_min_io_rq\fR and \fIrr_weight\fR.
 .TP
+.\" XXX
 .I "queue-length 0"
-Send the next bunch of IO down the path with the least amount of outstanding IO.
+(Since ??? kernel) Choose the path for the next bunch of IO based on the amount
+of outstanding IO to the path.
 .TP
+.\" XXX
 .I "service-time 0"
-Choose the path for the next bunch of IO based on the amount of outstanding IO
-to the path and its relative throughput.
+(Since ??? kernel) Choose the path for the next bunch of IO based on the amount
+of outstanding IO to the path and its relative throughput.
 .TP
 Default value is: \fBservice-time 0\fR
 .RE
@@ -333,22 +336,31 @@ Default value is: \fB<unset>\fR
 .TP
 .B features
 Specify any device-mapper features to be used. Syntax is \fInum list\fR
-where \fInum\fR is the number, between 0 and 6, of features in \fIlist\fR.
+where \fInum\fR is the number, between 0 and 8, of features in \fIlist\fR.
 Possible values for the feature list are:
 .RS
 .TP 12
+.\" XXX
 .I queue_if_no_path
-(Superseded by \fIno_path_retry\fR) Queue IO if no path is active. Identical to
-the \fIno_path_retry\fR with \fIqueue\fR value. See KNOWN ISSUES.
+(Superseded by \fIno_path_retry\fR) (Since ??? kernel) Queue IO if no path is active.
+Identical to the \fIno_path_retry\fR with \fIqueue\fR value. See KNOWN ISSUES.
 .TP
 .I no_partitions
 Disable automatic partitions generation via kpartx.
 .TP
-.I pg_init_retries
-Number of times to retry pg_init, it must be between 1 and 50.
+.\" XXX
+.I pg_init_retries <times>
+(Since ??? kernel) Number of times to retry pg_init, it must be between 1 and 50.
 .TP
-.I pg_init_delay_msecs
-Number of msecs before pg_init retry, it must be between 0 and 60000.
+.\" XXX
+.I pg_init_delay_msecs <msecs>
+(Since ??? kernel) Number of msecs before pg_init retry, it must be between 0 and 60000.
+.TP
+.\" XXX
+.I queue_mode <mode>
+(Since ??? kernel) Select the the queue_mode per multipath device.
+Where <mode> can be \fIbio\fR, \fIrq\fR or \fImq\fR. Which corresponds to
+bio-based, request_fn rq-based, and blk-mq rq-based respectively.
 .TP
 Default value is: \fB0\fR
 .RE
-- 
2.7.4
