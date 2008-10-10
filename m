From: Stefan Raspl <raspl@linux.vnet.ibm.com>
Subject: Re: Re: [PATCH] Fix Null pointer Exception
Date: Fri, 10 Oct 2008 09:23:00 +0200
Message-ID: <48EF02D4.1040605@linux.vnet.ibm.com>
References: <48C5478B.2040401@linux.vnet.ibm.com>
	<20080908172153.05268f6d.akpm@linux-foundation.org>
	<20080923165628.GI5288@agk.fab.redhat.com>
	<48DA3DF1.6060403@linux.vnet.ibm.com>
	<20081007211840.GC23898@agk.fab.redhat.com>
	<20081009151749.GO23898@agk.fab.redhat.com>
Reply-To: raspl@linux.vnet.ibm.com,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20081009151749.GO23898@agk.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: raspl@linux.vnet.ibm.com, device-mapper development <dm-devel@redhat.com>, Jens Axboe <jens.axboe@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, heiko.carstens@de.ibm.coms
List-Id: dm-devel.ids

Alasdair G Kergon wrote:
> On Tue, Oct 07, 2008 at 10:18:40PM +0100, Alasdair G Kergon wrote:
>> Meanwhile I will not be applying that patch, though I may take a patch
>> to provide clean diagnostics should a situation like this occur again.
>=20
> I'm thinking of something like this:
>=20
>=20
> From: Alasdair G Kergon <agk@redhat.com>
>=20
> Detect and report buggy drivers that destroy their request_queue.
>=20
> Signed-off-by: Alasdair G Kergon <agk@redhat.com>
> Cc: Stefan Raspl <raspl@linux.vnet.ibm.com>
> Cc: Jens Axboe <jens.axboe@oracle.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
>=20
> ---
>  drivers/md/dm-table.c |   24 ++++++++++++++++++++++--
>  1 files changed, 22 insertions(+), 2 deletions(-)
>=20
> Index: linux-2.6.27-rc8/drivers/md/dm-table.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.27-rc8.orig/drivers/md/dm-table.c	2008-10-09 14:53:35.000=
000000 +0100
> +++ linux-2.6.27-rc8/drivers/md/dm-table.c	2008-10-09 14:56:26.00000000=
0 +0100
> @@ -478,6 +478,13 @@ void dm_set_device_limits(struct dm_targ
>  {
>  	struct request_queue *q =3D bdev_get_queue(bdev);
>  	struct io_restrictions *rs =3D &ti->limits;
> +	char b[BDEVNAME_SIZE];
> +
> +	if (unlikely(!q)) {
> +		DMWARN("%s: Cannot set limits for nonexistent device %s",
> +		       dm_device_name(ti->table->md), bdevname(bdev, b));
> +		return;
> +	}
>=20
>  	/*
>  	 * Combine the device limits low.
> @@ -943,7 +950,14 @@ int dm_table_any_congested(struct dm_tab
>=20
>  	list_for_each_entry(dd, devices, list) {
>  		struct request_queue *q =3D bdev_get_queue(dd->bdev);
> -		r |=3D bdi_congested(&q->backing_dev_info, bdi_bits);
> +		char b[BDEVNAME_SIZE];
> +
> +		if (likely(q))
> +			r |=3D bdi_congested(&q->backing_dev_info, bdi_bits);
> +		else
> +			DMWARN_LIMIT("%s: any_congested: nonexistent device %s",
> +				     dm_device_name(t->md),
> +				     bdevname(dd->bdev, b));
>  	}
>=20
>  	return r;
> @@ -956,8 +970,14 @@ void dm_table_unplug_all(struct dm_table
>=20
>  	list_for_each_entry(dd, devices, list) {
>  		struct request_queue *q =3D bdev_get_queue(dd->bdev);
> +		char b[BDEVNAME_SIZE];
>=20
> -		blk_unplug(q);
> +		if (likely(q))
> +			blk_unplug(q);
> +		else
> +			DMWARN_LIMIT("%s: Cannot unplug nonexistent device %s",
> +				     dm_device_name(t->md),
> +				     bdevname(dd->bdev, b));
>  	}
>  }
>=20

Looks good to me!

Ciao,
Stefan


--=20
Linux on System z
IBM Deutschland Research & Development GmbH
Vorsitzender des Aufsichtsrats: Martin Jetter
Gesch=E4ftsf=FChrer: Erich Baier
Sitz der Gesellschaft: B=F6blingen
Registergericht: Amtsgericht Stuttgart, HRB 243294
