From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH] md/dm-stats: Use kmalloc_array() in parse_histogram()
Date: Sat, 1 Oct 2016 06:06:26 +0200
Message-ID: <5edaeddf-218f-1a98-d600-84941214db89@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: dm-devel@redhat.com, linux-raid@vger.kernel.org, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Shaohua Li <shli@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
List-Id: dm-devel.ids

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 1 Oct 2016 05:55:05 +0200

* A multiplication for the size determination of a memory allocation
  indicated that an array data structure should be processed.
  Thus use the corresponding function "kmalloc_array".

  This issue was detected by using the Coccinelle software.

* Replace the specification of a data type by a pointer dereference
  to make the corresponding size determination a bit safer according to
  the Linux coding style convention.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/md/dm-stats.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-stats.c b/drivers/md/dm-stats.c
index 38b05f2..7b79425 100644
--- a/drivers/md/dm-stats.c
+++ b/drivers/md/dm-stats.c
@@ -917,7 +917,9 @@ static int parse_histogram(const char *h, unsigned *n_histogram_entries,
 		if (*q == ',')
 			(*n_histogram_entries)++;
 
-	*histogram_boundaries = kmalloc(*n_histogram_entries * sizeof(unsigned long long), GFP_KERNEL);
+	*histogram_boundaries = kmalloc_array(*n_histogram_entries,
+					      sizeof(**histogram_boundaries),
+					      GFP_KERNEL);
 	if (!*histogram_boundaries)
 		return -ENOMEM;
 
-- 
2.10.0
