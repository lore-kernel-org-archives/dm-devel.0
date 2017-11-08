From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 4/6] mutipath: updated Huawei storage config
Date: Tue,  7 Nov 2017 18:15:14 -0600
Message-ID: <1510100116-6206-5-git-send-email-bmarzins@redhat.com>
References: <1510100116-6206-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1510100116-6206-1-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

I was given this updated built-in config by Zhou Weigang from
Huawei.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/hwtable.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index b018ddf..78de1fa 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -940,7 +940,8 @@ static struct hwentry default_hw[] = {
 		/* OceanStor V3 */
 		.vendor        = "HUAWEI",
 		.product       = "XSG1",
-		.pgpolicy      = MULTIBUS,
+		.pgpolicy      = GROUP_BY_PRIO,
+		.prio_name     = PRIO_ALUA,
 	},
 	/*
 	 * Red Hat
-- 
2.7.4
