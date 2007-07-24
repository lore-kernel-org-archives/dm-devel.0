From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 4/8] dm:dm-hw-handler.c Convert  kmalloc + memset  to
	kzalloc
Date: Tue, 24 Jul 2007 12:58:08 +0400
Message-ID: <20070724085808.GD16507@dnb.sw.ru>
References: <20070724085106.GD20538@dnb.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S935155AbXGXI6F@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20070724085106.GD20538@dnb.sw.ru>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 drivers/md/dm-hw-handler.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-hw-handler.c b/drivers/md/dm-hw-handler.c
index baafaab..2ee84d8 100644
--- a/drivers/md/dm-hw-handler.c
+++ b/drivers/md/dm-hw-handler.c
@@ -91,12 +91,10 @@ void dm_put_hw_handler(struct hw_handler_type *hwht)
 
 static struct hwh_internal *_alloc_hw_handler(struct hw_handler_type *hwht)
 {
-	struct hwh_internal *hwhi = kmalloc(sizeof(*hwhi), GFP_KERNEL);
+	struct hwh_internal *hwhi = kzalloc(sizeof(*hwhi), GFP_KERNEL);
 
-	if (hwhi) {
-		memset(hwhi, 0, sizeof(*hwhi));
+	if (hwhi)
 		hwhi->hwht = *hwht;
-	}
 
 	return hwhi;
 }
-- 
1.5.2.2
