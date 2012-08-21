From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 07/20] dm-crypt: don't use write queue
Date: Tue, 21 Aug 2012 11:09:18 +0200
Message-ID: <ec542a9b43e70319399967ed23b991e62e12d22c.1345477953.git.mbroz@redhat.com>
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

Don't use write queue and allocate write data directly from the request routine.
There is no need to bounce requests through a queue.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
---
 drivers/md/dm-crypt.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index fd2909d..4fd0d4b 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -1278,10 +1278,8 @@ static void kcryptd_crypt(struct work_struct *work)
 {
 	struct dm_crypt_io *io = container_of(work, struct dm_crypt_io, work);
 
-	if (bio_data_dir(io->base_bio) == READ)
-		kcryptd_crypt_read_convert(io);
-	else
-		kcryptd_crypt_write_convert(io);
+	BUG_ON(bio_data_dir(io->base_bio) != READ);
+	kcryptd_crypt_read_convert(io);
 }
 
 static void kcryptd_queue_crypt(struct dm_crypt_io *io)
@@ -1850,8 +1848,9 @@ static int crypt_map(struct dm_target *ti, struct bio *bio,
 	if (bio_data_dir(io->base_bio) == READ) {
 		if (kcryptd_io_read(io, GFP_NOWAIT))
 			kcryptd_queue_io(io);
-	} else
-		kcryptd_queue_crypt(io);
+	} else {
+		kcryptd_crypt_write_convert(io);
+	}
 
 	return DM_MAPIO_SUBMITTED;
 }
-- 
1.7.10.4
