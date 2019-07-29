From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: snapshot-origin with no snapshot may lead to BUG()
	in bio_split()
Date: Mon, 29 Jul 2019 10:38:20 -0400
Message-ID: <20190729143820.GA8423@redhat.com>
References: <VI1P191MB0014912D317079AAF7F3870BAECA0@VI1P191MB0014.EURP191.PROD.OUTLOOK.COM>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <VI1P191MB0014912D317079AAF7F3870BAECA0@VI1P191MB0014.EURP191.PROD.OUTLOOK.COM>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: =?iso-8859-1?Q?C=E9dric?= Delmas <cedricde@outlook.fr>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Sat, Jul 20 2019 at  5:26am -0400,
C=E9dric Delmas <cedricde@outlook.fr> wrote:

> Hello,
> =

> I encountered a bug while working with DM snapshot targets: having a
> snapshot-origin target with all snapshots removed may lead to
> BUG_ON(sectors <=3D 0) in function bio_split() (file block/bio.c).

...
 =

> Steps to reproduce:
> truncate -s 500M origin.bin
> truncate -s 50M snapshot.bin
> losetup /dev/loop0 origin.bin
> losetup /dev/loop1 snapshot.bin
> mkfs.ext4 /dev/loop0
> dmsetup create snap --table "0 $(blockdev --getsz /dev/loop0) snapshot /d=
ev/loop0 /dev/loop1 N 256"
> dmsetup create orig --table "0 $(blockdev --getsz /dev/loop0) snapshot-or=
igin /dev/loop0"
> # use /dev/mapper/snap and /dev/mapper/orig then unmount them
> dmsetup suspend orig
> dmsetup remove snap
> dmsetup resume orig
> e2fsck /dev/mapper/orig
> # BUG in bio_split()
> =

> Steps to reproduce (the express way):
> truncate -s 500M origin.bin
> losetup /dev/loop0 origin.bin
> mkfs.ext4 /dev/loop0
> dmsetup create orig --table "0 $(blockdev --getsz /dev/loop0) snapshot-or=
igin /dev/loop0"
> e2fsck /dev/mapper/orig
> # BUG in bio_split()
> =

> =

> I looked at the code and to my opinion the problem comes from function or=
igin_map (file drivers/md/dm-snap.c). In the following code:
> =

> static int origin_map(struct dm_target *ti, struct bio *bio)
> {
> 	struct dm_origin *o =3D ti->private;
> 	unsigned available_sectors;
> ...
> 	available_sectors =3D o->split_boundary -
> 		((unsigned)bio->bi_iter.bi_sector & (o->split_boundary - 1));
> =

> 	if (bio_sectors(bio) > available_sectors)
> 		dm_accept_partial_bio(bio, available_sectors);
> ...
> =

> when there is no snapshot, split_boundary is 0 so available_sectors gets =
an invalid value.
> The problem no more appears if the function origin_map early exits using =
the following patch:
> --- a/drivers/md/dm-snap.c      2019-07-14 08:11:23.000000000 +0200
> +++ b/drivers/md/dm-snap.c      2019-07-19 17:50:15.876000000 +0200
> @@ -2328,6 +2328,9 @@ static int origin_map(struct dm_target *
>         if (bio_data_dir(bio) !=3D WRITE)
>                 return DM_MAPIO_REMAPPED;
>  =

> +       if (unlikely(!o->split_boundary))
> +               return do_origin(o->dev, bio);
> +
>         available_sectors =3D o->split_boundary -
>                 ((unsigned)bio->bi_iter.bi_sector & (o->split_boundary - =
1));
>  =


When there is no snapshot snapshot-origin shouldn't be used.

So your patch may fix the BUG() you hit but it doesn't go far enough
with warning the user that they've entered "unsupported" territory.

Rather than call do_origin() I'm inclined to
DMERR_LIMIT("... unsupported ...") and error the IO.

What are your reasons for wanting to silently allow this unsupported
usecase?

Mike
