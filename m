From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 08/20] dm-crypt: simplify io queue
Date: Tue, 21 Aug 2012 11:09:19 +0200
Message-ID: <92105c817c168ec44e00ce611c32b86e9dad8e65.1345477953.git.mbroz@redhat.com>
References: <cover.1345477953.git.mbroz@redhat.com>
	<520994e0c87d38ca6abb8dd60760aef993842a32.1345477953.git.mbroz@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <520994e0c87d38ca6abb8dd60760aef993842a32.1345477953.git.mbroz@redhat.com>
In-Reply-To: <cover.1345477953.git.mbroz@redhat.com>
References: <cover.1345477953.git.mbroz@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
---
 drivers/md/dm-crypt.c |   11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 4fd0d4b..967d218 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -1084,13 +1084,7 @@ static void kcryptd_io(struct work_struct *work)
 {
 	struct dm_crypt_io *io = container_of(work, struct dm_crypt_io, work);
 
-	if (bio_data_dir(io->base_bio) == READ) {
-		crypt_inc_pending(io);
-		if (kcryptd_io_read(io, GFP_NOIO))
-			io->error = -ENOMEM;
-		crypt_dec_pending(io);
-	} else
-		kcryptd_io_write(io);
+	kcryptd_io_write(io);
 }
 
 static void kcryptd_queue_io(struct dm_crypt_io *io)
@@ -1846,8 +1840,7 @@ static int crypt_map(struct dm_target *ti, struct bio *bio,
 	io = crypt_io_alloc(cc, bio, dm_target_offset(ti, bio->bi_sector));
 
 	if (bio_data_dir(io->base_bio) == READ) {
-		if (kcryptd_io_read(io, GFP_NOWAIT))
-			kcryptd_queue_io(io);
+		kcryptd_io_read(io, GFP_NOIO);
 	} else {
 		kcryptd_crypt_write_convert(io);
 	}
-- 
1.7.10.4
