From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 8/8] dm: dm-target.c Convert  kmalloc + memset  to kzalloc
Date: Tue, 24 Jul 2007 12:59:47 +0400
Message-ID: <20070724085947.GH16507@dnb.sw.ru>
References: <20070724085106.GD20538@dnb.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S935391AbXGXI7i@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20070724085106.GD20538@dnb.sw.ru>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 drivers/md/dm-target.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-target.c b/drivers/md/dm-target.c
index 477a041..835cf95 100644
--- a/drivers/md/dm-target.c
+++ b/drivers/md/dm-target.c
@@ -88,12 +88,10 @@ void dm_put_target_type(struct target_type *t)
 
 static struct tt_internal *alloc_target(struct target_type *t)
 {
-	struct tt_internal *ti = kmalloc(sizeof(*ti), GFP_KERNEL);
+	struct tt_internal *ti = kzalloc(sizeof(*ti), GFP_KERNEL);
 
-	if (ti) {
-		memset(ti, 0, sizeof(*ti));
+	if (ti)
 		ti->tt = *t;
-	}
 
 	return ti;
 }
-- 
1.5.2.2
