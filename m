From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 6/8] dm: dm-emc.c Convert  kmalloc + memset  to kzalloc
Date: Tue, 24 Jul 2007 12:58:57 +0400
Message-ID: <20070724085857.GF16507@dnb.sw.ru>
References: <20070724085106.GD20538@dnb.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S933919AbXGXI6w@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20070724085106.GD20538@dnb.sw.ru>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 drivers/md/dm-emc.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-emc.c b/drivers/md/dm-emc.c
index 265c467..f04e950 100644
--- a/drivers/md/dm-emc.c
+++ b/drivers/md/dm-emc.c
@@ -224,12 +224,10 @@ fail_path:
 
 static struct emc_handler *alloc_emc_handler(void)
 {
-	struct emc_handler *h = kmalloc(sizeof(*h), GFP_KERNEL);
+	struct emc_handler *h = kzalloc(sizeof(*h), GFP_KERNEL);
 
-	if (h) {
-		memset(h, 0, sizeof(*h));
+	if (h)
 		spin_lock_init(&h->lock);
-	}
 
 	return h;
 }
-- 
1.5.2.2
