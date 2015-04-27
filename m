From: Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH] dm stripe: drop useless exit point from dm_stripe_init()
Date: Mon, 27 Apr 2015 21:29:36 +0100
Message-ID: <1430166576-17571-1-git-send-email-luis.henriques@canonical.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/md/dm-stripe.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/md/dm-stripe.c b/drivers/md/dm-stripe.c
index f8b37d4c05d8..a672a1502c14 100644
--- a/drivers/md/dm-stripe.c
+++ b/drivers/md/dm-stripe.c
@@ -451,10 +451,8 @@ int __init dm_stripe_init(void)
 	int r;
 
 	r = dm_register_target(&stripe_target);
-	if (r < 0) {
+	if (r < 0)
 		DMWARN("target registration failed");
-		return r;
-	}
 
 	return r;
 }
