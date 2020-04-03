From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm-integrity: fix logic bug in integrity tag
	testing
Date: Fri, 3 Apr 2020 13:05:50 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.2004031304240.5307@file01.intranet.prod.int.rdu2.redhat.com>
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
To: Mike Snitzer <msnitzer@redhat.com>, Milan Broz <mbroz@redhat.com>, David Teigland <teigland@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

If all the bytes are equal to DISCARD_FILLER, we want to accept the
buffer. If any of the bytes is different, we must do thorough tag-by-tag
checking.

The condition was inverted.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Fixes: 84597a44a9d8 ("dm integrity: add optional discard support")

--
 drivers/md/dm-integrity.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/drivers/md/dm-integrity.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-integrity.c	2020-04-03 18:48:39.000000000 +0200
+++ linux-2.6/drivers/md/dm-integrity.c	2020-04-03 18:51:38.000000000 +0200
@@ -1333,7 +1333,7 @@ static int dm_integrity_rw_tag(struct dm
 			if (likely(is_power_of_2(ic->tag_size))) {
 				if (unlikely(memcmp(dp, tag, to_copy)))
 					if (unlikely(!ic->discard) ||
-					    unlikely(!memchr_inv(dp, DISCARD_FILLER, to_copy))) {
+					    unlikely(memchr_inv(dp, DISCARD_FILLER, to_copy) != NULL)) {
 						goto thorough_test;
 				}
 			} else {
