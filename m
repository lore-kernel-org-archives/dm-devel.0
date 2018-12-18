From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 02/19] multipath.conf.5: explain "shaky" path
	detection
Date: Wed, 19 Dec 2018 00:19:14 +0100
Message-ID: <20181218231931.10762-3-mwilck@suse.com>
References: <20181218231931.10762-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20181218231931.10762-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: Guan Junxiong <guanjunxiong@huawei.com>, dm-devel@redhat.com, M Muneendra Kumar <mmandala@brocade.com>, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

Explain the "shaky path" detection algorithms, and how they
relate to each other.

Cc: Guan Junxiong <guanjunxiong@huawei.com>
Cc: M Muneendra Kumar <mmandala@brocade.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipath/multipath.conf.5 | 59 ++++++++++++++++++++++++++++++++++----
 1 file changed, 53 insertions(+), 6 deletions(-)

diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index 63333669..68119baa 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -898,7 +898,7 @@ error such as intermittent error. When a path failed event occurs twice in
 other three parameters are set, multipathd will fail the path and enqueue
 this path into a queue of which members are sent a couple of continuous
 direct reading asynchronous IOs at a fixed sample rate of 10HZ to start IO
-error accounting process.
+error accounting process. See "Shaky paths detection" below.
 .RS
 .TP
 The default is: \fBno\fR
@@ -920,7 +920,7 @@ If the rate of IO error on a particular path is greater than the
 \fImarginal_path_err_recheck_gap_time\fR seconds unless there is only one
 active path. After \fImarginal_path_err_recheck_gap_time\fR expires, the path
 will be requeueed for rechecking. If checking result is good enough, the
-path will be reinstated.
+path will be reinstated. See "Shaky paths detection" below.
 .RS
 .TP
 The default is: \fBno\fR
@@ -934,7 +934,7 @@ of supporting path check based on accounting IO error such as intermittent
 error. Refer to \fImarginal_path_err_sample_time\fR. If the rate of IO errors
 on a particular path is greater than this parameter, then the path will not
 reinstate for \fImarginal_path_err_recheck_gap_time\fR seconds unless there is
-only one active path.
+only one active path. See "Shaky paths detection" below.
 .RS
 .TP
 The default is: \fBno\fR
@@ -951,7 +951,7 @@ value, the failed path of  which the IO error rate is larger than
 \fImarginal_path_err_recheck_gap_time\fR seconds. When
 \fImarginal_path_err_recheck_gap_time\fR seconds expires, the path will be
 requeueed for checking. If checking result is good enough, the path will be
-reinstated, or else it will keep failed.
+reinstated, or else it will keep failed. See "Shaky paths detection" below.
 .RS
 .TP
 The default is: \fBno\fR
@@ -963,7 +963,7 @@ The default is: \fBno\fR
 If set to a value greater than 0, multipathd will watch paths that have
 recently become valid for this many checks. If they fail again while they are
 being watched, when they next become valid, they will not be used until they
-have stayed up for \fIdelay_wait_checks\fR checks.
+have stayed up for \fIdelay_wait_checks\fR checks. See "Shaky paths detection" below.
 .RS
 .TP
 The default is: \fBno\fR
@@ -975,7 +975,7 @@ The default is: \fBno\fR
 If set to a value greater than 0, when a device that has recently come back
 online fails again within \fIdelay_watch_checks\fR checks, the next time it
 comes back online, it will marked and delayed, and not used until it has passed
-\fIdelay_wait_checks\fR checks.
+\fIdelay_wait_checks\fR checks. See "Shaky paths detection" below.
 .RS
 .TP
 The default is: \fBno\fR
@@ -1578,6 +1578,53 @@ are present multipath will try to use the sysfs attribute
 .
 .
 .\" ----------------------------------------------------------------------------
+.SH "Shaky paths detection"
+.\" ----------------------------------------------------------------------------
+.
+A common problem in SAN setups is the occurence of intermittent errors: a
+path is unreachable, then reachable again for a short time, disappears again,
+and so forth. This happens typically on unstable interconnects. It is
+undesirable to switch pathgroups unnecessarily on such frequent, unreliable
+events. \fImultipathd\fR supports two different methods for detecting this
+situation and dealing with it. All methods share the same basic mode of
+operation: If a path is found to be \(dqshaky\(dq or \(dqflipping\(dq,
+and appears to be in healthy status, it is not reinstated (put back to use)
+immediately. Instead, it is watched for some time, and only reinstated
+if the healthy state appears to be stable. The logic of determining
+\(dqshaky\(dq condition, as well as the logic when to reinstate,
+differs between the methods.
+.TP 8
+.B \(dqdelay_checks\(dq failure tracking
+If a path fails again within a
+\fIdelay_watch_checks\fR interval after a failure, don't
+reinstate it until it passes a \fIdelay_wait_checks\fR interval
+in always good status.
+The intervals are measured in \(dqticks\(dq, i.e. the
+time between path checks by multipathd, which is variable and controlled by the
+\fIpolling_interval\fR and \fImax_polling_interval\fR parameters.
+.TP
+.B \(dqmarginal_path\(dq failure tracking
+If a second failure event (good->bad transition) occurs within
+\fImarginal_path_double_failed_time\fR seconds after a failure, high-frequency
+monitoring is started for the affected path: I/O is sent at a rate of 10 per
+second. This is done for \fImarginal_path_err_sample_time\fR seconds. During
+this period, the path is not reinstated. If the
+rate of errors remains below \fImarginal_path_err_rate_threshold\fR during the
+monitoring period, the path is reinstated. Otherwise, it
+is kept in failed state for \fImarginal_path_err_recheck_gap_time\fR, and
+after that, it is monitored again. For this method, time intervals are measured
+in seconds.
+.
+.RE
+.LP
+.
+See the documentation of the individual options above for details.
+It is \fBstrongly discouraged\fR to use more than one of these methods for any
+given multipath map, because the two concurrent methods may interact in
+unpredictable ways.
+.
+.
+.\" ----------------------------------------------------------------------------
 .SH "KNOWN ISSUES"
 .\" ----------------------------------------------------------------------------
 .
-- 
2.19.2
