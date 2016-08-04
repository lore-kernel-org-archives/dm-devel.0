From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 2/2] multipath-tools: inform that regex can be
	used in vendor, product and bl_product
Date: Thu,  4 Aug 2016 19:31:41 +0200
Message-ID: <1470331901-10846-2-git-send-email-xose.vazquez@gmail.com>
References: <1470331901-10846-1-git-send-email-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1470331901-10846-1-git-send-email-xose.vazquez@gmail.com>
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

Right now they are too wide regex, for example: "HITACHI"/"DF" or "SGI"/"IS".
It should be used more extensively, at least, in product-ID.
As I did in 34e345e8

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 6180751..a5d7402 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -868,6 +868,7 @@ static struct hwentry default_hw[] = {
 	 * Keep only mandatory and modified attributes.
 	 * Attributes with default values must be removed.
 	 * .vendor and .product are mandatory, all other are optional.
+	 * POSIX regex can be used in .vendor, .product and .bl_product
 	 *
 	 * COMPANY_NAME
 	 *
-- 
2.7.4
