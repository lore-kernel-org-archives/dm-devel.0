From: Alasdair G Kergon <agk@redhat.com>
Subject: [2.6.24 PATCH 03/06] dm crypt: fix write endio
Date: Thu, 13 Dec 2007 14:43:05 +0000
Message-ID: <20071213144305.GV24157@agk.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dm-crypt@saout.de, stable@kernel.org, dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

From: Milan Broz <mbroz@redhat.com>

Fix BIO_UPTODATE test for write io.

Cc: stable@kernel.org
Cc: dm-crypt@saout.de
Signed-off-by: Milan Broz <mbroz@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
---
 drivers/md/dm-crypt.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

Index: linux-2.6.24-rc5/drivers/md/dm-crypt.c
===================================================================
--- linux-2.6.24-rc5.orig/drivers/md/dm-crypt.c	2007-12-12 15:40:33.000000000 +0000
+++ linux-2.6.24-rc5/drivers/md/dm-crypt.c	2007-12-12 15:43:11.000000000 +0000
@@ -511,6 +511,9 @@ static void crypt_endio(struct bio *clon
 	struct crypt_config *cc = io->target->private;
 	unsigned read_io = bio_data_dir(clone) == READ;
 
+	if (unlikely(!bio_flagged(clone, BIO_UPTODATE) && !error))
+		error = -EIO;
+
 	/*
 	 * free the processed pages
 	 */
@@ -519,10 +522,8 @@ static void crypt_endio(struct bio *clon
 		goto out;
 	}
 
-	if (unlikely(!bio_flagged(clone, BIO_UPTODATE))) {
-		error = -EIO;
+	if (unlikely(error))
 		goto out;
-	}
 
 	bio_put(clone);
 	kcryptd_queue_crypt(io);
