From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm-stripe: fix size test
Date: Mon, 18 Jun 2012 20:57:02 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1206182054340.15183@file.rdu.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Alasdair G. Kergon" <agk@redhat.com>, Mike Snitzer <msnitzer@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

dm-stripe: fix size test

dm-stripe is supposed to test that all the stripes are fully used.
It tests that the number of sectors in the target si divisible by
chunk size and the number of stripes.

However, this check is not sufficient:
For example, suppose that we have target length 30 sectors and the
device consists of 6 stripes, each stripe with 15 sectors.

30 is divisible by both 6 and 15, so the test passes, but the stripes
are not fully used --- only the first two stripes are used.

We must actually test that the number of sectors is divisible by the
chunk size multiplied by the number of stripes.

This patch fixes the test --- it checks that device length is divisible
by the chunk size --- and checks that the resulting quotient is
divisible by the number of stripes (which is equivalent to testing if
device length is divisible by chunk_size * stripes).

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-stripe.c |    1 -
 1 file changed, 1 deletion(-)

Index: linux-3.4.3-fast/drivers/md/dm-stripe.c
===================================================================
--- linux-3.4.3-fast.orig/drivers/md/dm-stripe.c	2012-06-19 02:42:05.000000000 +0200
+++ linux-3.4.3-fast/drivers/md/dm-stripe.c	2012-06-19 02:42:23.000000000 +0200
@@ -125,7 +125,6 @@ static int stripe_ctr(struct dm_target *
 		return -EINVAL;
 	}
 
-	width = ti->len;
 	if (sector_div(width, stripes)) {
 		ti->error = "Target length not divisible by "
 		    "number of stripes";
