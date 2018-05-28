From: Muneendra <muneendra.kumar@broadcom.com>
Subject: [PATCH] Update in the description of
	marginal_path_err_rate_threshold
Date: Mon, 28 May 2018 02:25:51 -0700
Message-ID: <20180528092551.16131-1-muneendra.kumar@broadcom.com>
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
To: dm-devel@redhat.com
Cc: muneendra.kumar@broadcom.com
List-Id: dm-devel.ids

The multipath.conf.5 description of marginal_path_err_rate_threshold,
states that the path will not reinstate for
\fImarginal_path_err_recheck_gap_time\fR seconds,
where it should be marginal_path_err_recheck_gap_time seconds.

Signed-off-by: Muneendra <muneendra.kumar@broadcom.com>
---
 multipath/multipath.conf.5 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index f689795..9f58520 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -900,7 +900,7 @@ The error rate threshold as a permillage (1/1000). One of the four parameters
 of supporting path check based on accounting IO error such as intermittent
 error. Refer to \fImarginal_path_err_sample_time\fR. If the rate of IO errors
 on a particular path is greater than this parameter, then the path will not
-reinstate for \fImarginal_path_err_rate_threshold\fR seconds unless there is
+reinstate for \fImarginal_path_err_recheck_gap_time\fR seconds unless there is
 only one active path.
 .RS
 .TP
-- 
1.8.3.1
