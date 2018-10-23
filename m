From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 10/10] multipath.8: fix description of
	"device" argument
Date: Tue, 23 Oct 2018 15:43:48 +0200
Message-ID: <20181023134348.17915-5-mwilck@suse.com>
References: <20181023134348.17915-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20181023134348.17915-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

Describe the fact that we can refer to path devices by WWID, and
to multipath maps by devnode.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipath/multipath.8 | 32 ++++++++++++++++++--------------
 1 file changed, 18 insertions(+), 14 deletions(-)

diff --git a/multipath/multipath.8 b/multipath/multipath.8
index c9bd23aa..9cdd05a3 100644
--- a/multipath/multipath.8
+++ b/multipath/multipath.8
@@ -95,21 +95,25 @@ is used to detect and coalesce multiple paths to devices, for fail-over or perfo
 .SH ARGUMENTS
 .\" ----------------------------------------------------------------------------
 .
+The \fBdevice\fR argument restricts \fBmultipath\fR's operation to devices matching the given
+expression. The argument may refer either to a multipath map or to
+its components ("paths"). The expression may be in one of the following formats:
+.
+.TP 1.4i
+.B device node
+file name of a device node, e.g. \fI/dev/dm-10\fR or \fI/dev/sda\fR. If the node refers
+to an existing device mapper device representing a multipath map, this selects
+the map or its paths, depending on the operation mode. Otherwise, it selects a path device.
+.
 .TP
-.BI device
-Act only on the multipath map specified by
-.IR device ,
-which is either:
-.RS 1.2i
-.IP \[bu]
-A multipath map name.
-.IP \[bu]
-A path (low-level device) associated with the desired multipath map; the path may be in one of the following formats:
-.RS 1.2i
-.IP \[bu]
-.B /dev/sdX
-.IP \[bu]
-.B major:minor
+.B device ID
+kernel device number specified by major:minor numbers, e.g. \fI65:16\fR. This
+format can only be used for path devices.
+.
+.TP
+.B WWID
+a World Wide Identifier matching a multipath map or its paths. To list WWIDs of devices
+present in the system, use e.g. the command "\fImultipath -d -v3 2>/dev/null\fR".
 .
 .\" ----------------------------------------------------------------------------
 .SH OPERATION MODES
-- 
2.19.1
