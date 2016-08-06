From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 1/7] multipath-tools: remove "Optional" from some
	attributes in multipath.conf.5
Date: Sun,  7 Aug 2016 00:40:02 +0200
Message-ID: <1470523208-14067-1-git-send-email-xose.vazquez@gmail.com>
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

Mandatory ones were already identified. Optional is redundant.

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 multipath/multipath.conf.5 | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index aaf2705..c4a5bd4 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -804,7 +804,7 @@ subsection recognizes the following attributes:
 (Mandatory) Index of the container.
 .TP
 .B alias
-(Optional) Symbolic name for the multipath map.
+Symbolic name for the multipath map.
 .LP
 The following attributes are optional; if not set the default values
 are taken from the
@@ -868,17 +868,17 @@ subsection recognizes the following attributes:
 (Mandatory) Product identifier.
 .TP
 .B revision
-(Optional) Revision identfier.
+Revision identfier.
 .TP
 .B product_blacklist
-(Optional) Product strings to blacklist for this vendor.
+Product strings to blacklist for this vendor.
 .TP
 .B alias_prefix
-(Optional) The user_friendly_names prefix to use for this
+The user_friendly_names prefix to use for this
 device type, instead of the default "mpath".
 .TP
 .B hardware_handler
-(Optional) The hardware handler to use for this device type.
+The hardware handler to use for this device type.
 The following hardware handler are implemented:
 .RS
 .TP 12
-- 
2.7.4
