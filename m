From: Hannes Reinecke <hare-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [dm-devel] [PATCH v3 11/26] block: Add submit_bio_wait(), remove
 from md
Date: Tue, 25 Sep 2012 07:51:07 +0200
Message-ID: <5061464B.4090002@suse.de>
References: <1348526106-17074-1-git-send-email-koverstreet@google.com> <1348526106-17074-12-git-send-email-koverstreet@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1348526106-17074-12-git-send-email-koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: device-mapper development <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: dm-devel.ids

On 09/25/2012 12:34 AM, Kent Overstreet wrote:
> Random cleanup - this code was duplicated and it's not really specifi=
c
> to md.
>=20
> Also added the ability to return the actual error code.
>=20
> Signed-off-by: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> CC: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
> CC: NeilBrown <neilb-l3A5Bk7waGM@public.gmane.org>
> Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> ---
>  drivers/md/raid1.c  | 19 -------------------
>  drivers/md/raid10.c | 19 -------------------
>  fs/bio.c            | 36 ++++++++++++++++++++++++++++++++++++
>  include/linux/bio.h |  1 +
>  4 files changed, 37 insertions(+), 38 deletions(-)
>=20
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index deff0cd..28f506a 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -2048,25 +2048,6 @@ static void fix_read_error(struct r1conf *conf=
, int read_disk,
>  	}
>  }
> =20
> -static void bi_complete(struct bio *bio, int error)
> -{
> -	complete((struct completion *)bio->bi_private);
> -}
> -
> -static int submit_bio_wait(int rw, struct bio *bio)
> -{
> -	struct completion event;
> -	rw |=3D REQ_SYNC;
> -
> -	init_completion(&event);
> -	bio->bi_private =3D &event;
> -	bio->bi_end_io =3D bi_complete;
> -	submit_bio(rw, bio);
> -	wait_for_completion(&event);
> -
> -	return test_bit(BIO_UPTODATE, &bio->bi_flags);
> -}
> -
>  static int narrow_write_error(struct r1bio *r1_bio, int i)
>  {
>  	struct mddev *mddev =3D r1_bio->mddev;
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 6d06d83..f001c1b 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -2410,25 +2410,6 @@ static void fix_read_error(struct r10conf *con=
f, struct mddev *mddev, struct r10
>  	}
>  }
> =20
> -static void bi_complete(struct bio *bio, int error)
> -{
> -	complete((struct completion *)bio->bi_private);
> -}
> -
> -static int submit_bio_wait(int rw, struct bio *bio)
> -{
> -	struct completion event;
> -	rw |=3D REQ_SYNC;
> -
> -	init_completion(&event);
> -	bio->bi_private =3D &event;
> -	bio->bi_end_io =3D bi_complete;
> -	submit_bio(rw, bio);
> -	wait_for_completion(&event);
> -
> -	return test_bit(BIO_UPTODATE, &bio->bi_flags);
> -}
> -
>  static int narrow_write_error(struct r10bio *r10_bio, int i)
>  {
>  	struct bio *bio =3D r10_bio->master_bio;
> diff --git a/fs/bio.c b/fs/bio.c
> index 062ba8f..9a30dcf 100644
> --- a/fs/bio.c
> +++ b/fs/bio.c
> @@ -750,6 +750,42 @@ int bio_add_page(struct bio *bio, struct page *p=
age, unsigned int len,
>  }
>  EXPORT_SYMBOL(bio_add_page);
> =20
> +struct submit_bio_ret {
> +	struct completion event;
> +	int error;
> +};
> +
> +static void submit_bio_wait_endio(struct bio *bio, int error)
> +{
> +	struct submit_bio_ret *ret =3D bio->bi_private;
> +
> +	ret->error =3D error;
> +	complete(&ret->event);
> +}
> +
> +/**
> + * submit_bio_wait - submit a bio, and wait until it completes
> + * @rw: whether to %READ or %WRITE, or maybe to %READA (read ahead)
> + * @bio: The &struct bio which describes the I/O
> + *
> + * Simple wrapper around submit_bio(). Returns 0 on success, or the =
error from
> + * bio_endio() on failure.
> + */
> +int submit_bio_wait(int rw, struct bio *bio)
> +{
> +	struct submit_bio_ret ret;
> +
> +	rw |=3D REQ_SYNC;
> +	init_completion(&ret.event);
> +	bio->bi_private =3D &ret;
> +	bio->bi_end_io =3D submit_bio_wait_endio;

Hmm. As this is meant to be a generic function, blindly overwriting
the bi_end_io pointer doesn't look like a good idea; the caller
could have set something there.

Please add at least a WARN_ON(bio->bi_end_io) prior to modifying it.

> +	submit_bio(rw, bio);
> +	wait_for_completion(&ret.event);
> +
> +	return ret.error;
> +}
> +EXPORT_SYMBOL(submit_bio_wait);
> +
>  /**
>   * bio_advance - increment/complete a bio by some number of bytes
>   * @bio:	bio to advance
> diff --git a/include/linux/bio.h b/include/linux/bio.h
> index d985e90..3bf696b 100644
> --- a/include/linux/bio.h
> +++ b/include/linux/bio.h
> @@ -252,6 +252,7 @@ extern void bio_endio(struct bio *, int);
>  struct request_queue;
>  extern int bio_phys_segments(struct request_queue *, struct bio *);
> =20
> +extern int submit_bio_wait(int rw, struct bio *bio);
>  extern void bio_advance(struct bio *, unsigned);
> =20
>  extern void bio_init(struct bio *);
>=20

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare-l3A5Bk7waGM@public.gmane.org			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
