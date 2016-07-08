From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 13/14] multipath-tools: add undocumented features
	to multipath.conf.5
Date: Fri,  8 Jul 2016 19:49:58 +0200
Message-ID: <1468000199-15566-14-git-send-email-xose.vazquez@gmail.com>
References: <1468000199-15566-1-git-send-email-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1468000199-15566-1-git-send-email-xose.vazquez@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>, Chandra Seetharaman <sekharan@us.ibm.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

pg_init_retries - kernel commit c9e45581a
pg_init_delay_msecs - kernel commit 4e2d19e46

Cc: Dave Wysochanski <dwysocha@redhat.com>
Cc: Chandra Seetharaman <sekharan@us.ibm.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 multipath/multipath.conf.5 | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index 8ac9d5a..3e1a6db 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -296,9 +296,9 @@ Specify any device-mapper features to be used. Syntax is
 .I num list
 where
 .I num
-is the number of features in
+is the number, between 0 and 6, of features in
 .I list.
-Possible values for the feature list are
+Possible values for the feature list are:
 .RS
 .TP 12
 .I queue_if_no_path
@@ -309,6 +309,12 @@ keyword.
 .I no_partitions
 Disable automatic partitions generation via kpartx.
 .TP
+.I pg_init_retries
+Number of times to retry pg_init, it must be between 1 and 50.
+.TP
+.I pg_init_delay_msecs
+Number of msecs before pg_init retry, it must be between 0 and 60000.
+.TP
 Default value is: \fB0\fR
 .RE
 .TP
-- 
2.7.4
