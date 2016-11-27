From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: minor edition of
	multipath/multipath.conf.5
Date: Sun, 27 Nov 2016 17:23:42 +0100
Message-ID: <20161127162342.7188-1-xose.vazquez@gmail.com>
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

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 multipath/multipath.conf.5 | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index 9a1ad04..36589f5 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -147,11 +147,11 @@ The default is: \fBno\fR
 .
 .TP
 .B multipath_dir
-Directory where the dynamic shared objects are stored.
+Directory where the dynamic shared objects are stored. Defined at compile time,
+commonly \fI/lib64/multipath/\fR or \fI/lib/multipath/\fR.
 .RS
 .TP
-The default is: \fB<system dependent>\fR. Defined at compile time, commonly
-\fI/lib64/multipath/\fR.
+The default is: \fB<system dependent>\fR
 .RE
 .
 .
@@ -884,7 +884,7 @@ Sets the max_sectors_kb device parameter on all path devices and the multipath
 device to the specified value.
 .RS
 .TP
-Default is device dependent.
+The default is: \fB<device dependent>\fR
 .RE
 .
 .
-- 
2.10.2
