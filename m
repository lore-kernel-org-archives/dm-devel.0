From: tang.wenjun3@zte.com.cn
Subject: [PATCH 24/94] multipath-tools: document vendor, product,
	revision and bl_product are POSIX Extended regex
Date: Fri, 14 Oct 2016 09:56:06 +0800
Message-ID: <1476410236-9368-24-git-send-email-tang.wenjun3@zte.com.cn>
References: <1476410236-9368-1-git-send-email-tang.wenjun3@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1476410236-9368-1-git-send-email-tang.wenjun3@zte.com.cn>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: 10144149@zte.com.cn
Cc: device-mapper development <dm-devel@redhat.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

From: Xose Vazquez Perez <xose.vazquez@gmail.com>

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c     | 4 ++--
 multipath/multipath.conf.5 | 2 ++
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 55ffc56..bb8be88 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -864,8 +864,8 @@ static struct hwentry default_hw[] = {
 	 *
 	 * Keep only mandatory and modified attributes.
 	 * Attributes with default values must be removed.
-	 * .vendor and .product are mandatory, all other are optional.
-	 * POSIX Extended regex can be used in .vendor, .product, .revision and .bl_product
+	 * Only .vendor and .product are mandatory, all other are optional.
+	 * .vendor, .product, .revision and .bl_product are POSIX Extended regex
 	 *
 	 * COMPANY_NAME
 	 *
diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index b34a320..8377d14 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -955,6 +955,8 @@ subsection.
 .
 .
 The \fIdevice\fR subsection recognizes the following attributes:
+.TP
+vendor, product, revision and product_blacklist are POSIX Extended regex.
 .TP 17
 .B vendor
 (Mandatory) Vendor identifier.
-- 
2.8.1.windows.1
