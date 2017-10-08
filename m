From: Ben Hutchings <ben@decadent.org.uk>
Subject: Re: [PATCH 3.16,4.1] dm: flush queued bios when process blocks to
 avoid deadlock
Date: Sun, 08 Oct 2017 23:53:26 +0100
Message-ID: <1507503206.2677.108.camel@decadent.org.uk>
References: <alpine.LRH.2.02.1703151618110.1934@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-iV83WyRQ7IUd8g9E06ql"
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.02.1703151618110.1934@file01.intranet.prod.int.rdu2.redhat.com>
Sender: stable-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>, stable@vger.kernel.org, Sasha Levin <sasha.levin@oracle.com>
Cc: Mike Snitzer <msnitzer@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids


--=-iV83WyRQ7IUd8g9E06ql
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2017-03-15 at 16:22 -0400, Mikulas Patocka wrote:
> Hi
>=20
> This is backport of the upstram patch=20
> d67a5f4b5947aba4bfe9a80a2b86079c215ca755 for stable branches 3.16 and 4.1=
.

Queued up for 3.16, thanks.

Ben.

> Mikulas
>=20
>=20
> commit d67a5f4b5947aba4bfe9a80a2b86079c215ca755
> Author: Mikulas Patocka <mpatocka@redhat.com>
> Date:   Wed Feb 15 11:26:10 2017 -0500
>=20
>     dm: flush queued bios when process blocks to avoid deadlock
>    =20
>     Commit df2cb6daa4 ("block: Avoid deadlocks with bio allocation by
>     stacking drivers") created a workqueue for every bio set and code
>     in bio_alloc_bioset() that tries to resolve some low-memory deadlocks
>     by redirecting bios queued on current->bio_list to the workqueue if t=
he
>     system is low on memory.  However other deadlocks (see below **) may
>     happen, without any low memory condition, because generic_make_reques=
t
>     is queuing bios to current->bio_list (rather than submitting them).
>    =20
>     ** the related dm-snapshot deadlock is detailed here:
>     https://www.redhat.com/archives/dm-devel/2016-July/msg00065.html
>    =20
>     Fix this deadlock by redirecting any bios on current->bio_list to the
>     bio_set's rescue workqueue on every schedule() call.  Consequently,
>     when the process blocks on a mutex, the bios queued on
>     current->bio_list are dispatched to independent workqueus and they ca=
n
>     complete without waiting for the mutex to be available.
>    =20
>     The structure blk_plug contains an entry cb_list and this list can co=
ntain
>     arbitrary callback functions that are called when the process blocks.
>     To implement this fix DM (ab)uses the onstack plug's cb_list interfac=
e
>     to get its flush_current_bio_list() called at schedule() time.
>    =20
>     This fixes the snapshot deadlock - if the map method blocks,
>     flush_current_bio_list() will be called and it redirects bios waiting
>     on current->bio_list to appropriate workqueues.
>    =20
>     Fixes: https://bugzilla.redhat.com/show_bug.cgi?id=3D1267650
>     Depends-on: df2cb6daa4 ("block: Avoid deadlocks with bio allocation b=
y stacking drivers")
>     Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
>     Signed-off-by: Mike Snitzer <snitzer@redhat.com>
>=20
> ---
>  drivers/md/dm.c |   55 +++++++++++++++++++++++++++++++++++++++++++++++++=
++++++
>  1 file changed, 55 insertions(+)
>=20
> Index: linux-stable/drivers/md/dm.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-stable.orig/drivers/md/dm.c
> +++ linux-stable/drivers/md/dm.c
> @@ -1435,11 +1435,62 @@ void dm_accept_partial_bio(struct bio *b
>  }
>  EXPORT_SYMBOL_GPL(dm_accept_partial_bio);
> =20
> +/*
> + * Flush current->bio_list when the target map method blocks.
> + * This fixes deadlocks in snapshot and possibly in other targets.
> + */
> +struct dm_offload {
> +       struct blk_plug plug;
> +       struct blk_plug_cb cb;
> +};
> +
> +static void flush_current_bio_list(struct blk_plug_cb *cb, bool from_sch=
edule)
> +{
> +       struct dm_offload *o =3D container_of(cb, struct dm_offload, cb);
> +       struct bio_list list;
> +       struct bio *bio;
> +
> +       INIT_LIST_HEAD(&o->cb.list);
> +
> +       if (unlikely(!current->bio_list))
> +               return;
> +
> +       list =3D *current->bio_list;
> +       bio_list_init(current->bio_list);
> +
> +       while ((bio =3D bio_list_pop(&list))) {
> +               struct bio_set *bs =3D bio->bi_pool;
> +               if (unlikely(!bs) || bs =3D=3D fs_bio_set) {
> +                       bio_list_add(current->bio_list, bio);
> +                       continue;
> +               }
> +
> +               spin_lock(&bs->rescue_lock);
> +               bio_list_add(&bs->rescue_list, bio);
> +               queue_work(bs->rescue_workqueue, &bs->rescue_work);
> +               spin_unlock(&bs->rescue_lock);
> +       }
> +}
> +
> +static void dm_offload_start(struct dm_offload *o)
> +{
> +       blk_start_plug(&o->plug);
> +       o->cb.callback =3D flush_current_bio_list;
> +       list_add(&o->cb.list, &current->plug->cb_list);
> +}
> +
> +static void dm_offload_end(struct dm_offload *o)
> +{
> +       list_del(&o->cb.list);
> +       blk_finish_plug(&o->plug);
> +}
> +
>  static void __map_bio(struct dm_target_io *tio)
>  {
>         int r;
>         sector_t sector;
>         struct mapped_device *md;
> +       struct dm_offload o;
>         struct bio *clone =3D &tio->clone;
>         struct dm_target *ti =3D tio->ti;
> =20
> @@ -1452,7 +1503,11 @@ static void __map_bio(struct dm_target_i
>          */
>         atomic_inc(&tio->io->io_count);
>         sector =3D clone->bi_iter.bi_sector;
> +
> +       dm_offload_start(&o);
>         r =3D ti->type->map(ti, clone);
> +       dm_offload_end(&o);
> +
>         if (r =3D=3D DM_MAPIO_REMAPPED) {
>                 /* the bio has been remapped so dispatch it */
> =20
--=20
Ben Hutchings
compatible: Gracefully accepts erroneous data from any source


--=-iV83WyRQ7IUd8g9E06ql
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAlnarGcACgkQ57/I7JWG
EQm8DA//ThgkNY4dBTwe5VgwoiY9YG4oy3AZ78jX76m2INmt2R3t41MLlYT7ZYDP
KMcv4R6aZud+EKQZJHJzlSOdSm4dh9+BF9tmpxrXoYKNLBlp+AyKBK25r8mKtzXr
opnXkIcl7cPH5L8VSYW9O0yRTW/vAtjRX+lZ5VuJOnftyF2SWGV89SiCy2ngJyNl
nrIIyKsfX/qt6IPsyGAytblA8usVXirIPdcUzUxbnZZ6q5cJaGK492nWz7nmB/9a
Q8P0yASmGG+o0UI1fytRT/IieHW4KojhP+z/wOSgdjfCjJ+Wa3eLzqCe9jLJAvdK
KUx9djyqLn2n2aHA8vZ1LZMTvf5w1zTODmkw2dgI9/7dLBMrzmTBUtWJSvcpXd7b
lLV/+QWLBh3D+zVBJ171pk7KhzWNM2tF2qFcpgCqVR8W9WqmTJddTjXSKratKzRN
i+EJqCpYf5t+jgbeGicLrvZq0/2+JTyOL9fS/VKIYopSwC8H9Av+hxoOAhm0ycEP
rqeMQLxdrNIlmflnYMcIc4VO4a5KEBWuAELK6A3vgnLOzG1+/9QcBf8j2oWewG9v
IHG0aIbq9di2lmIKmQSwks8NO0alPEOcXMDbpplTOZFy7MXIq8NQJRbpKwTi4Wy9
QIobQxll4VMMxxY3My3AcEx2Vd6Sh1/VyPgQSBUQKNeqCmFgdP8=
=rXFX
-----END PGP SIGNATURE-----

--=-iV83WyRQ7IUd8g9E06ql--
