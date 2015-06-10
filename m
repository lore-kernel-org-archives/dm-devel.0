From: Christoph Hellwig <hch@lst.de>
Subject: Re: block: add a bi_error field to struct bio
Date: Wed, 10 Jun 2015 10:11:38 +0200
Message-ID: <20150610081138.GA3841@lst.de>
References: <1433338959-24808-1-git-send-email-hch@lst.de> <1433338959-24808-2-git-send-email-hch@lst.de> <20150604153106.GA31567@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-btrfs-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150604153106.GA31567@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-raid@vger.kernel.org, dm-devel@redhat.com, linux-btrfs@vger.kernel.org
List-Id: dm-devel.ids

On Thu, Jun 04, 2015 at 11:31:07AM -0400, Mike Snitzer wrote:
> This patch _really_ concerns me because just in DM alone I found you
> took liberties that you shouldn't have and created a regression.  Fir=
st
> issue is a real bug (your proposed dm-io.c:dmio_complete change misse=
d
> that dm-io uses error_bits and not traditional error code like expect=
ed)

Point taken.  I already wanted to complain about the mess due to the bi=
o
error abuse with it's own values in DM in the first posting, guess I
need to add that to the second one.  I don't think overloading common
interfaces with your private error codes is a good idea, but let's
leave that for a separate discussion.

> the other issue being you added extra branching that isn't needed and
> made review more tedious (dm.c:clone_endio).

I think the code is better than what it was before, but it's still
a bit of a mess.  What do you think of the patch below which I'd
like to add before the big bi_error patch as a preparatory one?

> For DM, please add Signed-off-by: Mike Snitzer <snitzer@redhat.com> o=
nce
> you've folded in this patch, thanks!

=46YI, that wasn't a foldable patch but updated hunks of the old one.  =
Not
really a problem, but a little confusing.


=46rom f095cbeba5135afa6cf102718319f0d0c1e7b422 Mon Sep 17 00:00:00 200=
1
=46rom: Christoph Hellwig <hch@lst.de>
Date: Wed, 10 Jun 2015 10:04:45 +0200
Subject: dm: use a single error code variable in clone_endio
MIME-Version: 1.0
Content-Type: text/plain; charset=3DUTF-8
Content-Transfer-Encoding: 8bit

clone_endio currently uses two variables for tracking error state, with
values getting bounce=D1=95 forth and back between the two, which makes=
 the
code hard to read.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/dm.c | 22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 2161ed9..8467976 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -956,7 +956,6 @@ static void disable_write_same(struct mapped_device=
 *md)
=20
 static void clone_endio(struct bio *bio, int error)
 {
-	int r =3D error;
 	struct dm_target_io *tio =3D container_of(bio, struct dm_target_io, c=
lone);
 	struct dm_io *io =3D tio->io;
 	struct mapped_device *md =3D tio->io->md;
@@ -966,23 +965,22 @@ static void clone_endio(struct bio *bio, int erro=
r)
 		error =3D -EIO;
=20
 	if (endio) {
-		r =3D endio(tio->ti, bio, error);
-		if (r < 0 || r =3D=3D DM_ENDIO_REQUEUE)
-			/*
-			 * error and requeue request are handled
-			 * in dec_pending().
-			 */
-			error =3D r;
-		else if (r =3D=3D DM_ENDIO_INCOMPLETE)
+		error =3D endio(tio->ti, bio, error);
+		if (error =3D=3D DM_ENDIO_INCOMPLETE) {
 			/* The target will handle the io */
 			return;
-		else if (r) {
-			DMWARN("unimplemented target endio return value: %d", r);
+		}
+
+		if (error > 0 && error !=3D DM_ENDIO_REQUEUE) {
+			DMWARN("unimplemented target endio return value: %d",
+				error);
 			BUG();
 		}
+
+		/* Error and requeue request are handled in dec_pending(). */
 	}
=20
-	if (unlikely(r =3D=3D -EREMOTEIO && (bio->bi_rw & REQ_WRITE_SAME) &&
+	if (unlikely(error =3D=3D -EREMOTEIO && (bio->bi_rw & REQ_WRITE_SAME)=
 &&
 		     !bdev_get_queue(bio->bi_bdev)->limits.max_write_same_sectors))
 		disable_write_same(md);
=20
--=20
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
