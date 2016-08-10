From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 13/15] multipath-tools: document vendor, product,
	revision and bl_product are POSIX Extended regex
Date: Wed, 10 Aug 2016 18:20:36 +0200
Message-ID: <1470846038-6590-13-git-send-email-xose.vazquez@gmail.com>
References: <1470846038-6590-1-git-send-email-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1470846038-6590-1-git-send-email-xose.vazquez@gmail.com>
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
 libmultipath/hwtable.c     | 4 ++--
 multipath/multipath.conf.5 | 2 ++
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index c256d05..bc2d407 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -858,8 +858,8 @@ static struct hwentry default_hw[] = {
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
index 4602f31..8dc5d08 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -959,6 +959,8 @@ subsection.
 .
 .
 The \fIdevice\fR subsection recognizes the following attributes:
+.TP
+vendor, product, revision and product_blacklist are POSIX Extended regex.
 .TP 17
 .B vendor
 (Mandatory) Vendor identifier.
-- 
2.7.4
