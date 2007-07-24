From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 2/8] dm: Fix workqueue leak for raid5
Date: Tue, 24 Jul 2007 12:56:42 +0400
Message-ID: <20070724085642.GB16507@dnb.sw.ru>
References: <20070724085106.GD20538@dnb.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S935014AbXGXI42@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20070724085106.GD20538@dnb.sw.ru>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 drivers/md/raid5.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 0f30826..79dd2c7 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -4985,6 +4985,8 @@ static int run(mddev_t *mddev)
 abort:
 	if (conf) {
 		print_raid5_conf(conf);
+		if (conf->workqueue)
+			destroy_workqueue(conf->workqueue);
 		safe_put_page(conf->spare_page);
 		kfree(conf->disks);
 		kfree(conf->stripe_hashtbl);
-- 
1.5.2.2
