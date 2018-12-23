From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 06/20] multipath.conf.5: man page fixes for
	san_path_err_xy
Date: Sun, 23 Dec 2018 23:21:12 +0100
Message-ID: <20181223222126.30882-7-mwilck@suse.com>
References: <20181223222126.30882-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20181223222126.30882-1-mwilck@suse.com>
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

This adds a paragraph about the san_path_err algorithm to the
"shaky paths" section of the man page.

Cc: Guan Junxiong <guanjunxiong@huawei.com>
Cc: M Muneendra Kumar <mmandala@brocade.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipath/multipath.conf.5 | 35 ++++++++++++++++++++++++++---------
 1 file changed, 26 insertions(+), 9 deletions(-)

diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index 35e6d37c..c7f59147 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -894,10 +894,10 @@ The default is: \fB/etc/multipath/conf.d/\fR
 .B san_path_err_threshold
 If set to a value greater than 0, multipathd will watch paths and check how many
 times a path has been failed due to errors.If the number of failures on a particular
-path is greater then the san_path_err_threshold then the path will not  reinstante
-till san_path_err_recovery_time.These path failures should occur within a
+path is greater then the san_path_err_threshold, then the path will not reinstate
+till san_path_err_recovery_time. These path failures should occur within a
 san_path_err_forget_rate checks, if not we will consider the path is good enough
-to reinstantate.
+to reinstantate. See "Shaky paths detection" below.
 .RS
 .TP
 The default is: \fBno\fR
@@ -909,7 +909,7 @@ The default is: \fBno\fR
 If set to a value greater than 0, multipathd will check whether the path failures
 has exceeded  the san_path_err_threshold within this many checks i.e
 san_path_err_forget_rate . If so we will not reinstante the path till
-san_path_err_recovery_time.
+san_path_err_recovery_time. See "Shaky paths detection" below.
 .RS
 .TP
 The default is: \fBno\fR
@@ -923,6 +923,7 @@ has exceeded the san_path_err_threshold within san_path_err_forget_rate then the
 will be placed in failed state for san_path_err_recovery_time duration.Once san_path_err_recovery_time
 has timeout  we will reinstante the failed path .
 san_path_err_recovery_time value should be in secs.
+See "Shaky paths detection" below.
 .RS
 .TP
 The default is: \fBno\fR
@@ -1642,14 +1643,14 @@ A common problem in SAN setups is the occurence of intermittent errors: a
 path is unreachable, then reachable again for a short time, disappears again,
 and so forth. This happens typically on unstable interconnects. It is
 undesirable to switch pathgroups unnecessarily on such frequent, unreliable
-events. \fImultipathd\fR supports two different methods for detecting this
+events. \fImultipathd\fR supports three different methods for detecting this
 situation and dealing with it. All methods share the same basic mode of
 operation: If a path is found to be \(dqshaky\(dq or \(dqflipping\(dq,
 and appears to be in healthy status, it is not reinstated (put back to use)
 immediately. Instead, it is watched for some time, and only reinstated
 if the healthy state appears to be stable. The logic of determining
 \(dqshaky\(dq condition, as well as the logic when to reinstate,
-differs between the methods.
+differs between the three methods.
 .TP 8
 .B \(dqdelay_checks\(dq failure tracking
 If a path fails again within a
@@ -1671,14 +1672,30 @@ monitoring period, the path is reinstated. Otherwise, it
 is kept in failed state for \fImarginal_path_err_recheck_gap_time\fR, and
 after that, it is monitored again. For this method, time intervals are measured
 in seconds.
+.TP
+.B \(dqsan_path_err\(dq failure tracking
+multipathd counts path failures for each path. Once the number of failures
+exceeds the value given by \fIsan_path_err_threshold\fR, the path is not
+reinstated for \fIsan_path_err_recovery_time\fR ticks. While counting
+failures, multipathd \(dqforgets\(dq one past failure every
+\(dqsan_path_err_forget_rate\(dq ticks; thus if errors don't occur more
+often then once in the forget rate interval, the failure count doesn't
+increase and the threshold is never reached. As for the \fIdelay_xy\fR method,
+intervals are measured in \(dqticks\(dq.
+.
+.RS 8
+.LP
+This method is \fBdeprecated\fR in favor of the \(dqmarginal_path\(dq failure
+tracking method, and only offered for backward compatibility.
 .
 .RE
 .LP
-.
-See the documentation of the individual options above for details.
+See the documentation
+of the individual options above for details.
 It is \fBstrongly discouraged\fR to use more than one of these methods for any
 given multipath map, because the two concurrent methods may interact in
-unpredictable ways.
+unpredictable ways. If the \(dqmarginal_path\(dq method is active, the
+\(dqsan_path_err\(dq parameters are implicitly set to 0.
 .
 .
 .\" ----------------------------------------------------------------------------
-- 
2.19.2
