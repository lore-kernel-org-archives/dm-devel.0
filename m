From: Frank Meinl <frank.meinl@live.de>
Subject: [PATCH v2 2/2] multipath: Extend program description in
	manpage
Date: Sat, 26 Sep 2020 18:29:47 +0200
Message-ID: <AM0PR09MB2897B99544634CA56DA930D1FE370@AM0PR09MB2897.eurprd09.prod.outlook.com>
References: <AM0PR09MB289702395C44596866E4B9C3FE370@AM0PR09MB2897.eurprd09.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <AM0PR09MB289702395C44596866E4B9C3FE370@AM0PR09MB2897.eurprd09.prod.outlook.com>
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
Cc: Frank Meinl <frank.meinl@live.de>, mwilck@suse.com
List-Id: dm-devel.ids

Add two paragraphs which list some advantages of multipath and explain
the benefit for single path devices. The text has been partly composed
by Benjamin Marzinski. - Refer to
https://www.redhat.com/archives/dm-devel/2020-September/msg00431.html

Signed-off-by: Frank Meinl <frank.meinl@live.de>
---
 multipath/multipath.8 | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/multipath/multipath.8 b/multipath/multipath.8
index 5b29a5d9..a580630a 100644
--- a/multipath/multipath.8
+++ b/multipath/multipath.8
@@ -89,7 +89,20 @@ multipath \- Device mapper target autoconfig.
 .\" ----------------------------------------------------------------------------
 .
 .B multipath
-is used to detect and coalesce multiple paths to devices, for fail-over or performance reasons.
+is used to detect and coalesce multiple paths to devices, for fail-over or
+performance reasons.
+.PP
+.B multipath
+works with devices as they are, instead of needing special metadata, like
+\fBlvm\fR devices. Plus, multipath deals with devices that have partitions or
+logical volumes on top of them. Consequently, multipath can be easily employed
+after the device is already set up, without the need to alter logical volumes
+or partition tables.
+.PP
+Despite its name, \fBmultipath\fR may be useful for single path devices, too.
+It offers the possibility to queue I/O if no path to the physical device is
+available. With queuing, a running application may tolerate a temporary device
+disconnect, because outstanding I/O will not fail immediately.
 .
 .\" ----------------------------------------------------------------------------
 .SH ARGUMENTS
-- 
2.25.1
