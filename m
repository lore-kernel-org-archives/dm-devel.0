From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 08/18] multipath-tools: add FUJITSU/ETERNUS
	2000/4000/8000 to hwtable
Date: Sat, 30 Jul 2016 02:28:16 +0200
Message-ID: <1469838506-15689-8-git-send-email-xose.vazquez@gmail.com>
References: <1469838506-15689-1-git-send-email-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1469838506-15689-1-git-send-email-xose.vazquez@gmail.com>
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

Based on documentation provided by the manufacturer:
http://storage-system.fujitsu.com/global/manual/diskarray/pdf/p3am-3192-en.pdf

For SUSE Linux Enterprise Server 11

vendor                  "FUJITSU"
product                 "E[248]000"
prio                    alua
path_grouping_policy    group_by_prio
path_selector           "round-robin 0"
failback                immediate
no_path_retry           10

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index d1e9c81..1845881 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -257,6 +257,13 @@ static struct hwentry default_hw[] = {
 		.product       = "FC2502",
 		.pgfailback    = FAILBACK_UNDEF,
 	},
+	{
+		.vendor        = "FUJITSU",
+		.product       = "E[248]000",
+		.prio_name     = PRIO_ALUA,
+		.no_path_retry = 10,
+		.selector      = "round-robin 0",
+	},
 	/*
 	 * Hitachi
 	 *
-- 
2.7.4
