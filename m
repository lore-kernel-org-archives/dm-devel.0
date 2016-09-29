From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 02/10] dm snapshot: Delete two error messages for a failed
 memory allocation
Date: Thu, 29 Sep 2016 11:10:07 +0200
Message-ID: <0204c749-986d-b419-73ca-23458916a31e@users.sourceforge.net>
References: <566ABCD9.1060404@users.sourceforge.net>
 <080668d9-1e1e-e208-f9ea-ff718e8070e5@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <080668d9-1e1e-e208-f9ea-ff718e8070e5@users.sourceforge.net>
Sender: linux-raid-owner@vger.kernel.org
To: dm-devel@redhat.com, linux-raid@vger.kernel.org, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Shaohua Li <shli@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>, Wolfram Sang <wsa@the-dreams.de>
List-Id: dm-devel.ids

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Wed, 28 Sep 2016 22:33:09 +0200

Omit extra messages for a memory allocation failure in this function.

Link: http://events.linuxfoundation.org/sites/events/files/slides/LCJ16-Refactor_Strings-WSang_0.pdf

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/md/dm-snap.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index f262f7e..7d81390 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -329,10 +329,8 @@ static int init_origin_hash(void)
 	_origins = kmalloc_array(ORIGIN_HASH_SIZE,
 				 sizeof(*_origins),
 				 GFP_KERNEL);
-	if (!_origins) {
-		DMERR("unable to allocate memory for _origins");
+	if (!_origins)
 		return -ENOMEM;
-	}
 	for (i = 0; i < ORIGIN_HASH_SIZE; i++)
 		INIT_LIST_HEAD(_origins + i);
 
@@ -340,7 +338,6 @@ static int init_origin_hash(void)
 				    sizeof(*_dm_origins),
 				    GFP_KERNEL);
 	if (!_dm_origins) {
-		DMERR("unable to allocate memory for _dm_origins");
 		kfree(_origins);
 		return -ENOMEM;
 	}
-- 
2.10.0

