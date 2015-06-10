From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: block: add a bi_error field to struct bio
Date: Wed, 10 Jun 2015 11:26:49 -0400
Message-ID: <20150610152649.GA31140@redhat.com>
References: <1433338959-24808-1-git-send-email-hch@lst.de>
 <1433338959-24808-2-git-send-email-hch@lst.de>
 <20150604153106.GA31567@redhat.com>
 <20150610081138.GA3841@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150610081138.GA3841@lst.de>
Sender: linux-raid-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, linux-raid@vger.kernel.org, dm-devel@redhat.com, linux-btrfs@vger.kernel.org
List-Id: dm-devel.ids

On Wed, Jun 10 2015 at  4:11am -0400,
Christoph Hellwig <hch@lst.de> wrote:

> On Thu, Jun 04, 2015 at 11:31:07AM -0400, Mike Snitzer wrote:
> > This patch _really_ concerns me because just in DM alone I found yo=
u
> > took liberties that you shouldn't have and created a regression.  F=
irst
> > issue is a real bug (your proposed dm-io.c:dmio_complete change mis=
sed
> > that dm-io uses error_bits and not traditional error code like expe=
cted)
>=20
> Point taken.  I already wanted to complain about the mess due to the =
bio
> error abuse with it's own values in DM in the first posting, guess I
> need to add that to the second one.  I don't think overloading common
> interfaces with your private error codes is a good idea, but let's
> leave that for a separate discussion.

I'll queue a patch to rename 'error' to 'error_bits' where appropriate.

> > the other issue being you added extra branching that isn't needed a=
nd
> > made review more tedious (dm.c:clone_endio).
>=20
> I think the code is better than what it was before, but it's still
> a bit of a mess.  What do you think of the patch below which I'd
> like to add before the big bi_error patch as a preparatory one?

If you're referring to the mix of error variables I totally agree.  Jus=
t
don't think we need the extra branching.
=20
> > For DM, please add Signed-off-by: Mike Snitzer <snitzer@redhat.com>=
 once
> > you've folded in this patch, thanks!
>=20
> FYI, that wasn't a foldable patch but updated hunks of the old one.  =
Not
> really a problem, but a little confusing.

Yeap, should have been clearer they were meant to replace your hunks.

> >From f095cbeba5135afa6cf102718319f0d0c1e7b422 Mon Sep 17 00:00:00 20=
01
> From: Christoph Hellwig <hch@lst.de>
> Date: Wed, 10 Jun 2015 10:04:45 +0200
> Subject: dm: use a single error code variable in clone_endio
> MIME-Version: 1.0
> Content-Type: text/plain; charset=3DUTF-8
> Content-Transfer-Encoding: 8bit
>=20
> clone_endio currently uses two variables for tracking error state, wi=
th
> values getting bounce=D1=95 forth and back between the two, which mak=
es the
> code hard to read.
>=20
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/md/dm.c | 22 ++++++++++------------
>  1 file changed, 10 insertions(+), 12 deletions(-)
>=20
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index 2161ed9..8467976 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -956,7 +956,6 @@ static void disable_write_same(struct mapped_devi=
ce *md)
> =20
>  static void clone_endio(struct bio *bio, int error)
>  {
> -	int r =3D error;
>  	struct dm_target_io *tio =3D container_of(bio, struct dm_target_io,=
 clone);
>  	struct dm_io *io =3D tio->io;
>  	struct mapped_device *md =3D tio->io->md;
> @@ -966,23 +965,22 @@ static void clone_endio(struct bio *bio, int er=
ror)
>  		error =3D -EIO;
> =20
>  	if (endio) {
> -		r =3D endio(tio->ti, bio, error);
> -		if (r < 0 || r =3D=3D DM_ENDIO_REQUEUE)
> -			/*
> -			 * error and requeue request are handled
> -			 * in dec_pending().
> -			 */
> -			error =3D r;
> -		else if (r =3D=3D DM_ENDIO_INCOMPLETE)
> +		error =3D endio(tio->ti, bio, error);
> +		if (error =3D=3D DM_ENDIO_INCOMPLETE) {
>  			/* The target will handle the io */
>  			return;
> -		else if (r) {
> -			DMWARN("unimplemented target endio return value: %d", r);
> +		}
> +
> +		if (error > 0 && error !=3D DM_ENDIO_REQUEUE) {
> +			DMWARN("unimplemented target endio return value: %d",
> +				error);
>  			BUG();
>  		}
> +
> +		/* Error and requeue request are handled in dec_pending(). */
>  	}
> =20
> -	if (unlikely(r =3D=3D -EREMOTEIO && (bio->bi_rw & REQ_WRITE_SAME) &=
&
> +	if (unlikely(error =3D=3D -EREMOTEIO && (bio->bi_rw & REQ_WRITE_SAM=
E) &&
>  		     !bdev_get_queue(bio->bi_bdev)->limits.max_write_same_sectors)=
)
>  		disable_write_same(md);
> =20
> --=20
> 1.9.1

Unfortunately by dropping the original error (e.g. -EREMOTEIO) on the
floor (in the 'if (endio) {' branch) you're breaking the REQ_WRITE_SAME
check.

Your new bi_error patch gets away with the redundant error code cleanup
because we can directly check the bio's bi_error for -EREMOTEIO.  So
feel free to fold the simplified 'if (error > 0 && error !=3D DM_ENDIO_=
REQUEUE) {'
in to your new patch -- but not seeing the point of making this prep
patch in advance.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
