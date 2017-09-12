From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: add info about adding new
	hardware
Date: Tue, 12 Sep 2017 18:24:01 +0200
Message-ID: <20170912162401.10093-1-xose.vazquez@gmail.com>
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
 README | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/README b/README
index a18b325..570224d 100644
--- a/README
+++ b/README
@@ -29,6 +29,11 @@ To get latest devel code: git clone https://git.opensvc.com/multipath-tools/.git
 Gitweb: https://git.opensvc.com/?p=multipath-tools/.git
 
 
+Add storage devices
+===================
+Follow the instructions in the libmultipath/hwtable.c header.
+
+
 Mailing list (subscribers-only)
 ============
 To subscribe and archives: https://www.redhat.com/mailman/listinfo/dm-devel
-- 
2.13.5
