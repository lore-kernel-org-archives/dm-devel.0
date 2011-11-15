From: Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>
Subject: [PATCH] Update man page for multipath -r
Date: Tue, 15 Nov 2011 20:39:57 +0530
Message-ID: <20111115150715.10350.54227.stgit@arunaltc>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Signed-off-by: Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>
---
 multipath/multipath.8 |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/multipath/multipath.8 b/multipath/multipath.8
index d8adf41..a112df7 100644
--- a/multipath/multipath.8
+++ b/multipath/multipath.8
@@ -50,6 +50,9 @@ flush all unused multipath device maps
 .B \-t
 print internal hardware table to stdout
 .TP
+.B \-r
+force devmap reload
+.TP
 .B \-B
 treat the bindings file as read only
 .TP
