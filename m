From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: add info about how to enable
	ALUA in ONTAP
Date: Sun,  1 Jul 2018 01:02:55 +0200
Message-ID: <20180630230255.15709-1-xose.vazquez@gmail.com>
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
Cc: DM-DEV ML <dm-devel@redhat.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

Cc: Martin George <marting@netapp.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM-DEV ML <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 README.alua | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/README.alua b/README.alua
index e39debd..340ccba 100644
--- a/README.alua
+++ b/README.alua
@@ -15,3 +15,7 @@ To enable ALUA, the following options should be changed:
 
 - LSI/Engenio/NetApp RDAC class, as NetApp SANtricity E/EF Series and OEM arrays:
    "Select operating system:" should be changed to "Linux DM-MP (Kernel 3.10 or later)".
+
+- NetApp ONTAP:
+   To check ALUA state: "igroup show -v <igroup_name>", and to enable ALUA:
+   "igroup set <igroup_name> alua yes".
-- 
2.17.1
