From: Stephen Boyd <swboyd@chromium.org>
Subject: [PATCH] dm init: Remove trailing newline from DM*()
Date: Tue,  4 Jun 2019 18:27:29 -0700
Message-ID: <20190605012729.30770-1-swboyd@chromium.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com, Helen Koike <helen.koike@collabora.com>
List-Id: dm-devel.ids

These printing macros already add a trailing newline, so having another
one here just makes for blank lines when these prints are enabled.
Remove them to match style of the rest of the uses of the macros.

Cc: Helen Koike <helen.koike@collabora.com>
Fixes: 6bbc923dfcf5 ("dm: add support to directly boot to a mapped device")
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
---
 drivers/md/dm-init.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-init.c b/drivers/md/dm-init.c
index 352e803f566e..54b78c68bf0b 100644
--- a/drivers/md/dm-init.c
+++ b/drivers/md/dm-init.c
@@ -272,7 +272,7 @@ static int __init dm_init_init(void)
 		return 0;
 
 	if (strlen(create) >= DM_MAX_STR_SIZE) {
-		DMERR("Argument is too big. Limit is %d\n", DM_MAX_STR_SIZE);
+		DMERR("Argument is too big. Limit is %d", DM_MAX_STR_SIZE);
 		return -EINVAL;
 	}
 	str = kstrndup(create, GFP_KERNEL, DM_MAX_STR_SIZE);
@@ -283,7 +283,7 @@ static int __init dm_init_init(void)
 	if (r)
 		goto out;
 
-	DMINFO("waiting for all devices to be available before creating mapped devices\n");
+	DMINFO("waiting for all devices to be available before creating mapped devices");
 	wait_for_device_probe();
 
 	list_for_each_entry(dev, &devices, list) {
-- 
Sent by a computer through tubes
