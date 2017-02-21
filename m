From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH v2] multipath-tools: add availability of
	service-time and queue-length to multipath.conf.5
Date: Tue, 21 Feb 2017 22:31:08 +0100
Message-ID: <20170221213108.4126-1-xose.vazquez@gmail.com>
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

https://kernelnewbies.org/Linux_2_6_31#head-7a4afa809f53cf9a2df884c745f4f8150e24645a

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
v2 - remove XXX tags
---
 multipath/multipath.conf.5 | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index 7de8bc7..4961c06 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -166,14 +166,12 @@ Loop through every path in the path group, sending the same amount of I/O to
 each. Some aspects of behavior can be controlled with the attributes:
 \fIrr_min_io\fR, \fIrr_min_io_rq\fR and \fIrr_weight\fR.
 .TP
-.\" XXX
 .I "queue-length 0"
-(Since ??? kernel) Choose the path for the next bunch of I/O based on the amount
+(Since 2.6.31 kernel) Choose the path for the next bunch of I/O based on the amount
 of outstanding I/O to the path.
 .TP
-.\" XXX
 .I "service-time 0"
-(Since ??? kernel) Choose the path for the next bunch of I/O based on the amount
+(Since 2.6.31 kernel) Choose the path for the next bunch of I/O based on the amount
 of outstanding I/O to the path and its relative throughput.
 .TP
 The default is: \fBservice-time 0\fR
-- 
2.11.1
