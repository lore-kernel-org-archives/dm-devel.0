From: Guido =?iso-8859-1?Q?G=FCnther?= <agx@sigxcpu.org>
Subject: [PATCH] [multipath-tools] Dots are special in groff
Date: Sun, 10 Jan 2010 18:14:59 +0100
Message-ID: <20100110171459.GA10604@bogon.sigxcpu.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
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
List-Id: dm-devel.ids

so don't start a line with it or the rest of the line will be dropped.

---
 multipath/multipath.conf.5 |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index 33b8747..a2864c6 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -207,9 +207,9 @@ If set to \fIpriorities\fR the multipath configurator will assign
 path weights as "path prio * rr_min_io". Possible values are
 .I priorities
 or
-.I uniform
-. Default is
-.I uniform
+.IR uniform .
+Default is
+.IR uniform .
 .TP
 .B no_path_retry
 Specify the number of retries until disable queueing, or
-- 
