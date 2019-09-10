From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH 2/4] libmultipath: EMC PowerMax NVMe device config
Date: Tue, 10 Sep 2019 17:39:19 -0500
Message-ID: <1568155161-9343-3-git-send-email-bmarzins@redhat.com>
References: <1568155161-9343-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1568155161-9343-1-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>, heyi <yi.he@dell.com>, Martin Wilck <Martin.Wilck@suse.com>
List-Id: dm-devel.ids

Got this config from Dell.

Cc: heyi <yi.he@dell.com>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/hwtable.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 96e8b25d..ca217e65 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -360,6 +360,12 @@ static struct hwentry default_hw[] = {
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.no_path_retry = 30,
 	},
+	{
+		/* EMC PowerMax NVMe */
+		.vendor        = "NVME",
+		.product       = "^EMC PowerMax_",
+		.pgpolicy      = MULTIBUS,
+	},
 	/*
 	 * Fujitsu
 	 */
-- 
2.17.2
