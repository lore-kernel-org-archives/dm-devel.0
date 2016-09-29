From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 01/10] dm snapshot: Use kmalloc_array() in init_origin_hash()
Date: Thu, 29 Sep 2016 11:07:47 +0200
Message-ID: <3861d349-48fd-162b-a749-83e007f70b41@users.sourceforge.net>
References: <566ABCD9.1060404@users.sourceforge.net>
 <080668d9-1e1e-e208-f9ea-ff718e8070e5@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <080668d9-1e1e-e208-f9ea-ff718e8070e5@users.sourceforge.net>
Sender: kernel-janitors-owner@vger.kernel.org
To: dm-devel@redhat.com, linux-raid@vger.kernel.org, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Shaohua Li <shli@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
List-Id: dm-devel.ids

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Wed, 28 Sep 2016 22:20:08 +0200

* Multiplications for the size determination of memory allocations
  indicated that array data structures should be processed.
  Thus use the corresponding function "kmalloc_array".

  This issue was detected by using the Coccinelle software.

* Replace the specification of data structures by pointer dereferences
  to make the corresponding size determination a bit safer according to
  the Linux coding style convention.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/md/dm-snap.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index c65feea..f262f7e 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -326,8 +326,9 @@ static int init_origin_hash(void)
 {
 	int i;
 
-	_origins = kmalloc(ORIGIN_HASH_SIZE * sizeof(struct list_head),
-			   GFP_KERNEL);
+	_origins = kmalloc_array(ORIGIN_HASH_SIZE,
+				 sizeof(*_origins),
+				 GFP_KERNEL);
 	if (!_origins) {
 		DMERR("unable to allocate memory for _origins");
 		return -ENOMEM;
@@ -335,8 +336,9 @@ static int init_origin_hash(void)
 	for (i = 0; i < ORIGIN_HASH_SIZE; i++)
 		INIT_LIST_HEAD(_origins + i);
 
-	_dm_origins = kmalloc(ORIGIN_HASH_SIZE * sizeof(struct list_head),
-			      GFP_KERNEL);
+	_dm_origins = kmalloc_array(ORIGIN_HASH_SIZE,
+				    sizeof(*_dm_origins),
+				    GFP_KERNEL);
 	if (!_dm_origins) {
 		DMERR("unable to allocate memory for _dm_origins");
 		kfree(_origins);
-- 
2.10.0

