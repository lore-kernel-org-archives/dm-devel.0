From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH v2] multipath-tools: add README.alua with
	instructions to enable ALUA
Date: Tue, 21 Nov 2017 19:52:13 +0100
Message-ID: <20171121185213.3737-1-xose.vazquez@gmail.com>
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
Cc: NetApp RDAC team <ng-eseries-upstream-maintainers@netapp.com>, device-mapper development <dm-devel@redhat.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

ALUA is supported in some storage devices, but usually it's disabled by default.

Cc: NetApp RDAC team <ng-eseries-upstream-maintainers@netapp.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
v2	add rdac info
---
 README.alua | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)
 create mode 100644 README.alua

diff --git a/README.alua b/README.alua
new file mode 100644
index 0000000..e39debd
--- /dev/null
+++ b/README.alua
@@ -0,0 +1,17 @@
+This is a rough guide, consult your storage device manufacturer documentation.
+
+ALUA is supported in some devices, but usually it's disabled by default.
+To enable ALUA, the following options should be changed:
+
+- EMC CLARiiON/VNX:
+   "Failover Mode" should be changed to "4".
+
+- HPE 3PAR:
+   "Host:" should be changed to "Generic-ALUA Persona 2 (UARepLun, SESLun, ALUA)".
+
+- Promise VTrak/Vess:
+   "LUN Affinity" and "ALUA" should be changed to "Enable", "Redundancy Type"
+   must be "Active-Active".
+
+- LSI/Engenio/NetApp RDAC class, as NetApp SANtricity E/EF Series and OEM arrays:
+   "Select operating system:" should be changed to "Linux DM-MP (Kernel 3.10 or later)".
-- 
2.14.3
