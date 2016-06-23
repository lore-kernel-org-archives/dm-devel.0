From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 2/4] multipath-tools: update path checker info in
	multipath.conf.5
Date: Thu, 23 Jun 2016 15:42:18 +0200
Message-ID: <1466689340-5590-3-git-send-email-xose.vazquez@gmail.com>
References: <1466689340-5590-1-git-send-email-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1466689340-5590-1-git-send-email-xose.vazquez@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Cc: Matthias Rudolph <matthias.rudolph@hds.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>, Yacine Kheddache <yacine@alyseo.com>, device-mapper development <dm-devel@redhat.com>, "Brian King,
	IBM" <brking@linux.vnet.ibm.com>, Srinivasan Ramani <srinivas.ramani@oracle.com>, Sean Stewart <sean.stewart@netapp.com>, Shyam Sundar <g.shyamsundar@yahoo.co.in>, "Bart Brooks,
	Pivot3" <bartb@pivot3.com>, "Edward Goggin, EMC" <egoggin@emc.com>
List-Id: dm-devel.ids

From now on tur is by default, and warn about directio drawbacks.

Cc: Shyam Sundar <g.shyamsundar@yahoo.co.in>
Cc: Edward Goggin, EMC <egoggin@emc.com>
Cc: Matthias Rudolph <matthias.rudolph@hds.com>
Cc: Brian King, IBM <brking@linux.vnet.ibm.com>
Cc: Yacine Kheddache <yacine@alyseo.com>
Cc: Srinivasan Ramani <srinivas.ramani@oracle.com>
Cc: Bart Brooks, Pivot3 <bartb@pivot3.com>
Cc: Martin George <marting@netapp.com>
Cc: Sean Stewart <sean.stewart@netapp.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 multipath/multipath.conf.5 | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index e57b8e6..9f0d194 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -271,7 +271,7 @@ are
 .TP 12
 .B readsector0
 (Deprecated) Read the first sector of the device. This checker is being
-deprecated, please use \fIdirectio\fR instead
+deprecated, please use \fItur\fR instead
 .TP
 .B tur
 Issue a
@@ -289,9 +289,11 @@ Check the path state for HP storage arrays with Active/Standby firmware.
 Check the path state for LSI/Engenio/NetApp E-Series RDAC storage controller.
 .TP
 .B directio
-Read the first sector with direct I/O.
+(Deprecated) Read the first sector with direct I/O. This checker is being
+deprecated, it will cause spurious path failures under high load.
+Please use \fItur\fR instead.
 .TP
-Default value is \fIdirectio\fR.
+Default value is \fItur\fR.
 .RE
 .TP
 .B failback
-- 
2.5.5
