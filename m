From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 1/9] md/dm-table: Use kmalloc_array() in realloc_argv()
Date: Sat, 1 Oct 2016 09:43:18 +0200
Message-ID: <ea1578e5-c7e8-131d-a1d9-3c726afaabfa@users.sourceforge.net>
References: <45984567-4421-5f8d-ddf3-eb2a769a1860@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <45984567-4421-5f8d-ddf3-eb2a769a1860@users.sourceforge.net>
Sender: kernel-janitors-owner@vger.kernel.org
To: dm-devel@redhat.com, linux-raid@vger.kernel.org, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Shaohua Li <shli@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
List-Id: dm-devel.ids

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 1 Oct 2016 06:47:16 +0200

A multiplication for the size determination of a memory allocation
indicated that an array data structure should be processed.
Thus use the corresponding function "kmalloc_array".

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/md/dm-table.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 3e407a9..f6b817c 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -523,7 +523,7 @@ static char **realloc_argv(unsigned *array_size, char **old_argv)
 		new_size = 8;
 		gfp = GFP_NOIO;
 	}
-	argv = kmalloc(new_size * sizeof(*argv), gfp);
+	argv = kmalloc_array(new_size, sizeof(*argv), gfp);
 	if (argv) {
 		memcpy(argv, old_argv, *array_size * sizeof(*argv));
 		*array_size = new_size;
-- 
2.10.0

