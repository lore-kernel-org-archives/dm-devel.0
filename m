From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: clarify no_path_retry in
	multipath.conf.5
Date: Mon, 17 Oct 2016 23:18:15 +0200
Message-ID: <20161017211815.2581-1-xose.vazquez@gmail.com>
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
Cc: device-mapper development <dm-devel@redhat.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

no_path_retry    Specify what to do when all paths are down. Possible values are:

    value > 0   number of retries until disable I/O queueing.

    fail        for immediate failure (no I/O queueing).

    queue       for never stop I/O queueing. Similar to queue_if_no_path.

    See KNOWN ISSUES.

    Default value is: fail

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 multipath/multipath.conf.5 | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index 367688e..4ab2917 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -498,14 +498,21 @@ Default value is: \fBuniform\fR
 .
 .TP
 .B no_path_retry
-Specify the number of retries until disable queueing, or
+Specify what to do when all paths are down. Possible values are:
+.RS
+.TP 12
+.I value > 0
+number of retries until disable I/O queueing.
+.TP
 .I fail
-for immediate failure (no queueing),
+for immediate failure (no I/O queueing).
+.TP
 .I queue
-for never stop queueing. If unset no queueing is attempted. See KNOWN ISSUES.
-.RS
+for never stop I/O queueing. Similar to \fIqueue_if_no_path\fR.
 .TP
-Default value is: \fB<unset>\fR
+See KNOWN ISSUES.
+.TP
+Default value is: \fBfail\fR
 .RE
 .
 .
-- 
2.10.1
