From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 7/9] multipath-tools: tips on adding new devices
	with proprietary handlers
Date: Tue, 21 Jun 2016 02:36:02 +0200
Message-ID: <1466469364-14446-7-git-send-email-xose.vazquez@gmail.com>
References: <1466469364-14446-1-git-send-email-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1466469364-14446-1-git-send-email-xose.vazquez@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>, device-mapper development <dm-devel@redhat.com>, Babu Moger <Babu.Moger@netapp.com>, Sean Stewart <sean.stewart@netapp.com>
List-Id: dm-devel.ids

kernel(SCSI) and multipath-tools should be in sync.
Currently in drivers/scsi/scsi_dh.c:

 {"DGC", "RAID",                 "clariion" },
 {"DGC", "DISK",                 "clariion" },
 {"DGC", "VRAID",                "clariion" },

 {"COMPAQ", "MSA1000 VOLUME",    "hp_sw" },
 {"COMPAQ", "HSV110",            "hp_sw" },
 {"HP", "HSV100",                "hp_sw"},
 {"DEC", "HSG80",                "hp_sw"},

 {"IBM", "1722",                 "rdac", },
 {"IBM", "1724",                 "rdac", },
 {"IBM", "1726",                 "rdac", },
 {"IBM", "1742",                 "rdac", },
 {"IBM", "1745",                 "rdac", },
 {"IBM", "1746",                 "rdac", },
 {"IBM", "1813",                 "rdac", }, -> missing in multipath-tools !!!

Added in 4df01b. It's an IBM DCS3860.

 {"IBM", "1814",                 "rdac", },
 {"IBM", "1815",                 "rdac", },
 {"IBM", "1818",                 "rdac", },
 {"IBM", "3526",                 "rdac", },
 {"SGI", "TP9",                  "rdac", },
 {"SGI", "IS",                   "rdac", },
 {"STK", "OPENstorage D280",     "rdac", },
 {"STK", "FLEXLINE 380",         "rdac", },
 {"SUN", "CSM",                  "rdac", },
 {"SUN", "LCSM100",              "rdac", },
 {"SUN", "STK6580_6780",         "rdac", },
 {"SUN", "SUN_6180",             "rdac", },
 {"SUN", "ArrayStorage",         "rdac", }, -> missing in multipath-tools !!!

Added in 66195f. Unknown device, too generic name.

 {"DELL", "MD3",                 "rdac", },
 {"NETAPP", "INF-01-00",         "rdac", },
 {"LSI", "INF-01-00",            "rdac", },
 {"ENGENIO", "INF-01-00",        "rdac", },

Cc: Babu Moger <Babu.Moger@netapp.com>
Cc: Sean Stewart <sean.stewart@netapp.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 62e284d..47a2e61 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -15,6 +15,11 @@
  * You are welcome to claim maintainership over a controller
  * family. Please mail the currently enlisted maintainer and
  * the upstream package maintainer.
+ *
+ * WARNING:
+ *
+ * Devices with a proprietary handler must also be included in
+ * the kernel side. Currently at drivers/scsi/scsi_dh.c
  */
 static struct hwentry default_hw[] = {
 	/*
-- 
2.5.5
