From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 04/11] multipath-tools: Edward Goggin no longer
	works at EMC
Date: Thu, 11 Aug 2016 20:32:20 +0200
Message-ID: <1470940345-4441-4-git-send-email-xose.vazquez@gmail.com>
References: <1470940345-4441-1-git-send-email-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1470940345-4441-1-git-send-email-xose.vazquez@gmail.com>
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
 libmultipath/hwtable.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index cd052e4..7d1f85e 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -161,9 +161,6 @@ static struct hwentry default_hw[] = {
 	},
 	/*
 	 * EMC
-	 *
-	 * Maintainer : Edward Goggin
-	 * Mail : egoggin@emc.com
 	 */
 	{
 		/* Symmetrix / DMX / VMAX */
-- 
2.7.4
