From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 06/14] multipath-tools: clarify ONTAP class info
	at multipath.conf.5
Date: Fri,  8 Jul 2016 19:49:51 +0200
Message-ID: <1468000199-15566-7-git-send-email-xose.vazquez@gmail.com>
References: <1468000199-15566-1-git-send-email-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1468000199-15566-1-git-send-email-xose.vazquez@gmail.com>
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

ontap prio is *exclusively* for NetApp ONTAP class and OEM arrays,
as IBM NSeries.

Cc: Martin George <marting@netapp.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 multipath/multipath.conf.5 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index 5e70315..33f7df8 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -221,7 +221,7 @@ accepts the optional prio_arg
 .I exclusive_pref_bit
 .TP
 .I ontap
-Generate the path priority for NetApp arrays.
+Generate the path priority for NetApp ONTAP class and OEM arrays as IBM NSeries.
 .TP
 .I rdac
 Generate the path priority for LSI/Engenio/NetApp E-Series RDAC controller.
-- 
2.7.4
