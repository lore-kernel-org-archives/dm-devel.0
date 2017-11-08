From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 5/6] multipath: fix doc typo
Date: Tue,  7 Nov 2017 18:15:15 -0600
Message-ID: <1510100116-6206-6-git-send-email-bmarzins@redhat.com>
References: <1510100116-6206-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1510100116-6206-1-git-send-email-bmarzins@redhat.com>
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
Cc: Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

The dev_loss_tmo cap if fast_io_fail_tmo isn't set is 600 seconds,
not 300 seconds.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipath/multipath.conf.5 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index 92ad8b1..4bd1a8d 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -653,7 +653,7 @@ seconds, or 68 years. It will be automatically adjusted to the overall
 retry interval \fIno_path_retry\fR * \fIpolling_interval\fR
 if a number of retries is given with \fIno_path_retry\fR and the
 overall retry interval is longer than the specified \fIdev_loss_tmo\fR value.
-The Linux kernel will cap this value to \fI300\fR if \fIfast_io_fail_tmo\fR
+The Linux kernel will cap this value to \fI600\fR if \fIfast_io_fail_tmo\fR
 is not set. See KNOWN ISSUES.
 .RS
 .TP
-- 
2.7.4
