From: Alasdair G Kergon <agk@redhat.com>
Subject: [2.6.22 PATCH 14/26] dm io: delay dec_count
Date: Tue, 8 May 2007 20:47:12 +0100
Message-ID: <20070508194712.GU24114@agk.fab.redhat.com>
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
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org, Heinz Mauelshagen <hjm@redhat.com>
List-Id: dm-devel.ids

From: Heinz Mauelshagen <hjm@redhat.com>

Delay decrementing the 'struct io' reference count until after the bio has
been freed so that a bio destructor function may reference it.
Required by a later patch.

Signed-off-by: Heinz Mauelshagen <hjm@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Cc: Milan Broz <mbroz@redhat.com>
---

 drivers/md/dm-io.c |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

Index: linux-2.6.21/drivers/md/dm-io.c
===================================================================
--- linux-2.6.21.orig/drivers/md/dm-io.c	2007-05-01 17:38:32.000000000 +0100
+++ linux-2.6.21/drivers/md/dm-io.c	2007-05-01 17:40:52.000000000 +0100
@@ -126,7 +126,8 @@ static void dec_count(struct io *io, uns
 
 static int endio(struct bio *bio, unsigned int done, int error)
 {
-	struct io *io = (struct io *) bio->bi_private;
+	struct io *io;
+	unsigned region;
 
 	/* keep going until we've finished */
 	if (bio->bi_size)
@@ -135,10 +136,17 @@ static int endio(struct bio *bio, unsign
 	if (error && bio_data_dir(bio) == READ)
 		zero_fill_bio(bio);
 
-	dec_count(io, bio_get_region(bio), error);
+	/*
+	 * The bio destructor in bio_put() may use the io object.
+	 */
+	io = bio->bi_private;
+	region = bio_get_region(bio);
+
 	bio->bi_max_vecs++;
 	bio_put(bio);
 
+	dec_count(io, region, error);
+
 	return 0;
 }
 
