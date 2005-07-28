From: akpm@osdl.org
Subject: [patch 01/18] bio_clone fix
Date: Thu, 28 Jul 2005 01:07:18 -0700
Message-ID: <200507280808.j6S88F15013833@shell0.pdx.osdl.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: torvalds@osdl.org
Cc: akpm@osdl.org, linux-raid@vger.kernel.org, dm-devel@redhat.com, axboe@suse.de, matthew4196@gmail.com
List-Id: dm-devel.ids


From: Andrew Morton <akpm@osdl.org>

Fix bug introduced in 2.6.11-rc2: when we clone a BIO we need to copy over the
current index into it as well.

It corrupts data with some MD setups.

See http://bugzilla.kernel.org/show_bug.cgi?id=4946

Huuuuuuuuge thanks to Matthew Stapleton <matthew4196@gmail.com> for doggedly
chasing this one down.

Acked-by: Jens Axboe <axboe@suse.de>
Cc: <linux-raid@vger.kernel.org>
Cc: <dm-devel@redhat.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/bio.c |    1 +
 1 files changed, 1 insertion(+)

diff -puN fs/bio.c~bio_clone-fix fs/bio.c
--- devel/fs/bio.c~bio_clone-fix	2005-07-28 00:39:40.000000000 -0700
+++ devel-akpm/fs/bio.c	2005-07-28 01:02:34.000000000 -0700
@@ -261,6 +261,7 @@ inline void __bio_clone(struct bio *bio,
 	 */
 	bio->bi_vcnt = bio_src->bi_vcnt;
 	bio->bi_size = bio_src->bi_size;
+	bio->bi_idx = bio_src->bi_idx;
 	bio_phys_segments(q, bio);
 	bio_hw_segments(q, bio);
 }
_
