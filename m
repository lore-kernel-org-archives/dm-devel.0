From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 7/8] multipath.conf.5: Remove ??? and other
	minor fixes
Date: Tue, 20 Jun 2017 13:46:13 +0200
Message-ID: <20170620114614.26261-8-mwilck@suse.com>
References: <20170620114614.26261-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170620114614.26261-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Hannes Reinecke <hare@suse.de>
Cc: dm-devel@redhat.com, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

Remove the FIXME markers by filling in missing content,
and make some other minor fixes.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipath/multipath.conf.5 | 48 +++++++++++++++++++++++++---------------------
 1 file changed, 26 insertions(+), 22 deletions(-)

diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index 6959ba5c..d8856577 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -258,7 +258,7 @@ Return a constant priority of \fI1\fR.
 .I sysfs
 Use the sysfs attributes \fIaccess_state\fR and \fIpreferred_path\fR to
 generate the path priority. This prioritizer accepts the optional prio_arg
-\fIexclusive_pref_bit\fR
+\fIexclusive_pref_bit\fR.
 .TP
 .I emc
 (Hardware-dependent)
@@ -296,14 +296,19 @@ Generate the path priority based on the regular expression and the
 priority provided as argument. Requires prio_args keyword.
 .TP
 .I datacore
-.\" XXX
-???. Requires prio_args keyword.
+(Hardware-dependent)
+Generate the path priority for some Datacore storage arrays. Requires prio_args
+keyword.
 .TP
 .I iet
-.\" XXX
-???. Requires prio_args keyword.
-.TP
-The default is: \fBconst\fR
+(iSCSI only)
+Generate path priority for iSCSI targets based on IP address. Requires
+prio_args keyword.
+.PP
+The default depends on the \fBdetect_prio\fR setting: If \fBdetect_prio\fR is
+\fByes\fR (default), the default priority algorithm is \fBsysfs\fR (except for
+NetAPP E-Series, where it is \fBalua\fR). If \fBdetect_prio\fR is
+\fBno\fR, the default priority algorithm is \fBconst\fR.
 .RE
 .
 .
@@ -344,12 +349,12 @@ If \fIexclusive_pref_bit\fR is set, paths with the \fIpreferred path\fR bit
 set will always be in their own path group.
 .TP
 .I datacore
-.\" XXX
-\fIpreferredsds\fR ???.
+\fIpreferredsds\fR (required) denotes the preferred "SDS name" for datacore
+arrays. \fItimeout\fR (optional) is the timeout for the INQUIRY, in ms.
 .TP
 .I iet
-.\" XXX
-\fIpreferredip\fR ???.
+\fIpreferredip=...\fR (required) denotes the preferred IP address (in dotted decimal
+notation) for iSCSI targets.
 .TP
 The default is: \fB<unset>\fR
 .RE
@@ -364,29 +369,28 @@ Possible values for the feature list are:
 .TP 12
 .\" XXX
 .I queue_if_no_path
-(Superseded by \fIno_path_retry\fR) (Since ??? kernel) Queue I/O if no path is active.
+(Superseded by \fIno_path_retry\fR) Queue I/O if no path is active.
 Identical to the \fIno_path_retry\fR with \fIqueue\fR value. If both this
 feature and \fIno_path_retry\fR are set, the latter value takes
 precedence. See KNOWN ISSUES.
 .TP
-.I no_partitions
-Disable automatic partitions generation via kpartx.
-.TP
 .\" XXX
 .I pg_init_retries <times>
-(Since ??? kernel) Number of times to retry pg_init, it must be between 1 and 50.
+(Since kernel 2.6.24) Number of times to retry pg_init, it must be between 1 and 50.
 .TP
 .\" XXX
 .I pg_init_delay_msecs <msecs>
-(Since ??? kernel) Number of msecs before pg_init retry, it must be between 0 and 60000.
+(Since kernel 2.6.38) Number of msecs before pg_init retry, it must be between 0 and 60000.
 .TP
 .\" XXX
 .I queue_mode <mode>
-(Since ??? kernel) Select the the queue_mode per multipath device.
-Where <mode> can be \fIbio\fR, \fIrq\fR or \fImq\fR. Which corresponds to
-bio-based, request_fn rq-based, and blk-mq rq-based respectively.
-.TP
-The default is: \fB0\fR
+(Since kernel 4.8) Select the the queueing mode per multipath device.
+<mode> can be \fIbio\fR, \fIrq\fR or \fImq\f, which corresponds to
+bio-based, request-based, and block-multiqueue (blk-mq) request-based,
+respectively.
+
+The default depends on the kernel parameter \fBdm_mod.use_blk_mq\fR. It is
+\fImq\fR if the latter is set, and \fIrq\fR otherwise.
 .RE
 .
 .
-- 
2.13.1
