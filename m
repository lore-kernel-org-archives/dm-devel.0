From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 0/8] dm: request-based dm-multipath
Date: Thu, 29 Jan 2009 11:41:47 +0100
Message-ID: <20090129104147.GB9870@pentland.suse.de>
References: <20081003.110825.74754936.k-ueda@ct.jp.nec.com>
	<20090128154019.GB23158@agk.fab.redhat.com>
	<49815863.8040806@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <49815863.8040806@ct.jp.nec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Alasdair Kergon <agk@redhat.com>, mbroz@redhat.com
List-Id: dm-devel.ids

On Thu, Jan 29, 2009 at 04:18:59PM +0900, Kiyoshi Ueda wrote:
> Hi Alasdair,
>=20
> On 01/29/2009 12:40 AM +0900, Alasdair G Kergon wrote:
> > On Fri, Oct 03, 2008 at 11:08:25AM -0400, Kiyoshi Ueda wrote:
> >> This patch-set is the updated version of request-based dm-multipath.
> >> The changes from the previous version (*) are to follow up the chang=
e
> >> of the interface to export lld's busy state (PATCH 5).
> >=20
> > I've fixed them up to compile again, but haven't thoroughly checked f=
or
> > side-effects.
>=20
> I found some problems below in my patches and now considering
> how to fix them:
>   o Unnecessary EIO is returned to application if it submits
>     a bio during table swapping.
Yes, I've noticed that. Problem is this:

--- linux-2.6.27.orig/drivers/md/dm.c
+++ linux-2.6.27/drivers/md/dm.c
@@ -1304,7 +1304,11 @@ static int dm_make_request(struct reques
                return 0;
        }
=20
-       if (unlikely(!md->map)) {
+       /*
+        * Submitting to a stopped queue with no map is okay;
+        * might happen during reconfiguration.
+        */
+       if (unlikely(!md->map) && !blk_queue_stopped(q)) {
                bio_endio(bio, -EIO);
                return 0;
        }

The make_request callback should never return EIO if there's any
chance at all to get this request done.

>   o kernel panic occurs by frequent table swapping during heavy I/Os.
> =20
That's probably fixed by this patch:

--- linux-2.6.27/drivers/md/dm.c.orig   2009-01-23 15:59:22.741461315 +01=
00
+++ linux-2.6.27/drivers/md/dm.c        2009-01-26 09:03:02.787605723 +01=
00
@@ -714,13 +714,14 @@ static void free_bio_clone(struct reques
        struct dm_rq_target_io *tio =3D clone->end_io_data;
        struct mapped_device *md =3D tio->md;
        struct bio *bio;
-       struct dm_clone_bio_info *info;
=20
        while ((bio =3D clone->bio) !=3D NULL) {
                clone->bio =3D bio->bi_next;
=20
-               info =3D bio->bi_private;
-               free_bio_info(md, info);
+               if (bio->bi_private) {
+                       struct dm_clone_bio_info *info =3D bio->bi_privat=
e;
+                       free_bio_info(md, info);
+               }
=20
                bio->bi_private =3D md->bs;
                bio_put(bio);

The info field is not necessarily filled here, so we have to check for it
explicitly.

With these two patches request-based multipathing have survived all stres=
s-tests
so far. Except on mainframe (zfcp), but that's more a driver-related thin=
g.

Good work!

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
