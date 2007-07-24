From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 5/8] dm: dm-table.c Convert  kmalloc + memset  to kzalloc
Date: Tue, 24 Jul 2007 12:58:36 +0400
Message-ID: <20070724085836.GE16507@dnb.sw.ru>
References: <20070724085106.GD20538@dnb.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S935264AbXGXI61@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20070724085106.GD20538@dnb.sw.ru>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 drivers/md/dm-table.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 2fc199b..17237b1 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -213,12 +213,11 @@ static int alloc_targets(struct dm_table *t, unsigned int num)
 int dm_table_create(struct dm_table **result, int mode,
 		    unsigned num_targets, struct mapped_device *md)
 {
-	struct dm_table *t = kmalloc(sizeof(*t), GFP_KERNEL);
+	struct dm_table *t = kzalloc(sizeof(*t), GFP_KERNEL);
 
 	if (!t)
 		return -ENOMEM;
 
-	memset(t, 0, sizeof(*t));
 	INIT_LIST_HEAD(&t->devices);
 	atomic_set(&t->holders, 1);
 
-- 
1.5.2.2
