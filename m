From: Roel Kluin <roel.kluin@gmail.com>
Subject: [PATCH] dm: strncpy does not null terminate string
Date: Fri, 17 Jul 2009 17:35:59 +0200
Message-ID: <4A609A5F.70900@gmail.com>
References: <4A607185.6020302@gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4A607185.6020302@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Cc: dm-devel@redhat.com, Andrew Morton <akpm@linux-foundation.org>
List-Id: dm-devel.ids

strlcpy() will always null terminate the string.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index 7f77f18..8208b3a 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -634,9 +634,9 @@ static struct mapped_device *find_device(struct dm_ioctl *param)
 		 * Sneakily write in both the name and the uuid
 		 * while we have the cell.
 		 */
-		strncpy(param->name, hc->name, sizeof(param->name));
+		strlcpy(param->name, hc->name, sizeof(param->name));
 		if (hc->uuid)
-			strncpy(param->uuid, hc->uuid, sizeof(param->uuid)-1);
+			strlcpy(param->uuid, hc->uuid, sizeof(param->uuid));
 		else
 			param->uuid[0] = '\0';
 
