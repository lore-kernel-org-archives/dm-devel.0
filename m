From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 1/8] dm: Add missing 'kfree' to dm-crypt target constructor.
Date: Tue, 24 Jul 2007 12:55:40 +0400
Message-ID: <20070724085540.GA16507@dnb.sw.ru>
References: <20070724085106.GD20538@dnb.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S934923AbXGXIzm@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20070724085106.GD20538@dnb.sw.ru>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 drivers/md/dm-crypt.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index cdd3f2c..1315002 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -175,6 +175,7 @@ static int crypt_iv_essiv_ctr(struct crypt_config *cc, struct dm_target *ti,
 
 	if (err) {
 		ti->error = "Error calculating hash in ESSIV";
+		kfree(salt);
 		return err;
 	}
 
-- 
1.5.2.2
