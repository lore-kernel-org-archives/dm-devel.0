From: hegdevasant <vahegde1@linux.vnet.ibm.com>
Subject: [PATCH] kpartx man page update
Date: Tue, 15 Nov 2011 14:06:12 +0530
Message-ID: <4EC2247C.5010001@linux.vnet.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
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
To: christophe.varoqui@opensvc.com, dm-devel@redhat.com
List-Id: dm-devel.ids

  This patch updates the kpartx man page.

Signed-off-by: Vasant Hegde <hegdevasant@in.ibm.com>
---
  kpartx/kpartx.8 |    9 +++++++++
  1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/kpartx/kpartx.8 b/kpartx/kpartx.8
index 795a2e0..8a37d4f 100644
--- a/kpartx/kpartx.8
+++ b/kpartx/kpartx.8
@@ -17,9 +17,15 @@ creation and deletion.
  .B \-a
  Add partition mappings
  .TP
+.B \-r
+Readonly partition mappings
+.TP
  .B \-d
  Delete partition mappings
  .TP
+.B \-u
+Update partition mappings
+.TP
  .B \-l
  List partition mappings that would be added -a
  .TP
@@ -34,6 +40,9 @@ force GUID partition table (GPT)
  .TP
  .B \-v
  Operate verbosely
+.TP
+.B \-s
+Sync mode. Don't return until the partitions are created
  .SH EXAMPLE
  To mount all the partitions in a raw disk image:
  .IP
-- 
1.7.3.4
