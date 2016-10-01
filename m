From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 8/9] md/dm-table: Delete an unwanted space in high()
Date: Sat, 1 Oct 2016 09:52:08 +0200
Message-ID: <7a82ff8c-7ddd-0777-ec54-cfa603065ec8@users.sourceforge.net>
References: <45984567-4421-5f8d-ddf3-eb2a769a1860@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <45984567-4421-5f8d-ddf3-eb2a769a1860@users.sourceforge.net>
Sender: linux-raid-owner@vger.kernel.org
To: dm-devel@redhat.com, linux-raid@vger.kernel.org, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Shaohua Li <shli@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
List-Id: dm-devel.ids

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 1 Oct 2016 09:04:06 +0200

The script "checkpatch.pl" pointed information out like the following.

ERROR: space prohibited after that '-' (ctx:WxW)

Thus fix the affected source code place.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/md/dm-table.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 40dde87..a948ffb 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -109,7 +109,7 @@ static sector_t high(struct dm_table *t, unsigned int l, unsigned int n)
 		n = get_child(n, CHILDREN_PER_NODE - 1);
 
 	if (n >= t->counts[l])
-		return (sector_t) - 1;
+		return (sector_t) -1;
 
 	return get_node(t, l, n)[KEYS_PER_NODE - 1];
 }
-- 
2.10.0

