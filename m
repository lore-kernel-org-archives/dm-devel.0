From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 7/8] dm: dm-path-selector.c Convert  kmalloc + memset  to
	kzalloc
Date: Tue, 24 Jul 2007 12:59:21 +0400
Message-ID: <20070724085921.GG16507@dnb.sw.ru>
References: <20070724085106.GD20538@dnb.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S935205AbXGXI7V@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20070724085106.GD20538@dnb.sw.ru>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 drivers/md/dm-path-selector.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-path-selector.c b/drivers/md/dm-path-selector.c
index f10a0c8..ca1bb63 100644
--- a/drivers/md/dm-path-selector.c
+++ b/drivers/md/dm-path-selector.c
@@ -94,12 +94,10 @@ out:
 
 static struct ps_internal *_alloc_path_selector(struct path_selector_type *pst)
 {
-	struct ps_internal *psi = kmalloc(sizeof(*psi), GFP_KERNEL);
+	struct ps_internal *psi = kzalloc(sizeof(*psi), GFP_KERNEL);
 
-	if (psi) {
-		memset(psi, 0, sizeof(*psi));
+	if (psi)
 		psi->pst = *pst;
-	}
 
 	return psi;
 }
-- 
1.5.2.2
