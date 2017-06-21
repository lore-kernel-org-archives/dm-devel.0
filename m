From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v3 08/11] libmultipath: add deprecated warning
	for some features settings
Date: Wed, 21 Jun 2017 17:06:27 +0200
Message-ID: <20170621150630.25773-9-mwilck@suse.com>
References: <20170621150630.25773-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170621150630.25773-1-mwilck@suse.com>
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

The device-mapper features "queue_if_no_path" and
"retain_attached_hw_handler" should be set via the configuration
keywords "no_path_retry" and "retain_attached_hw_handler",
respectively, not via "features".
Print a warning if these "features" settings are encountered.

So far these "features" settings will only be ignored if the
respective other keyword is set, so in particular
'features "1 queue_if_no_path"' will still work as expected, but
cause the warning to be printed.

We should consider ignoring these completely in a future version.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/propsel.c     | 5 +++++
 multipath/multipath.conf.5 | 2 +-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index bc9e130b..e885a845 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -290,6 +290,9 @@ void reconcile_features_with_options(const char *id, char **features, int* no_pa
 	 * it's translated into "no_path_retry queue" here.
 	 */
 	if (strstr(*features, q_i_n_p)) {
+		condlog(0, "%s: option 'features \"1 %s\"' is deprecated, "
+			"please use 'no_path_retry queue' instead",
+			id, q_i_n_p);
 		if (*no_path_retry == NO_PATH_RETRY_UNDEF) {
 			*no_path_retry = NO_PATH_RETRY_QUEUE;
 			print_no_path_retry(buff, sizeof(buff),
@@ -307,6 +310,8 @@ void reconcile_features_with_options(const char *id, char **features, int* no_pa
 		remove_feature(features, q_i_n_p);
 	}
 	if (strstr(*features, r_a_h_h)) {
+		condlog(0, "%s: option 'features \"1 %s\"' is deprecated",
+			id, r_a_h_h);
 		if (*retain_hwhandler == RETAIN_HWHANDLER_UNDEF) {
 			condlog(3, "%s: %s = on (inherited setting from feature '%s')",
 				id, r_a_h_h, r_a_h_h);
diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index 000a42ec..b32d0383 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -389,7 +389,7 @@ Possible values for the feature list are:
 .TP 12
 .\" XXX
 .I queue_if_no_path
-(Superseded by \fIno_path_retry\fR) Queue I/O if no path is active.
+(Deprecated, superseded by \fIno_path_retry\fR) Queue I/O if no path is active.
 Identical to the \fIno_path_retry\fR with \fIqueue\fR value. If both this
 feature and \fIno_path_retry\fR are set, the latter value takes
 precedence. See KNOWN ISSUES.
-- 
2.13.1
