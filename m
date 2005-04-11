From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: [PATCH] trivial fix to dm-emc.c
Date: Mon, 11 Apr 2005 10:43:18 +0200
Message-ID: <20050411084318.GZ12752@marowsky-bree.de>
References: <20050303215621.GA25051@osdl.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20050303215621.GA25051@osdl.org>
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
Cc: agk@redhat.com
List-Id: dm-devel.ids

On 2005-03-03T13:56:21, Dave Olien <dmo@osdl.org> wrote:

> Here's a trivial fix to the emc hardware
> handler module. The old code memset the hardware handler
> structure to zero AFTER it had initialized the structure's
> spinlock field to SPIN_LOCK_UNLOCKED.  The new patch moves the
> memset into the hardware handler allocator.
>=20
> The old code would probably only have a problem if someone
> ran with spinlock debugging enabled, in which case SPIN_LOCK_UNLOCKED
> contains the value SPINLOCK_MAGIC.
>=20
> I have no emc hardware to test this change.  However it does compile.

Alasdair, please merge, looks correct.

Signed-off-by: Lars Marowsky-Bree <lmb@suse.de>

> diff -ur linux-2.6.11-rc3-udm2-original/drivers/md/dm-emc.c linux-2.6.1=
1-rc3-udm2-emc/drivers/md/dm-emc.c
> --- linux-2.6.11-rc3-udm2-original/drivers/md/dm-emc.c	2005-03-03 13:40=
:55.000000000 -0800
> +++ linux-2.6.11-rc3-udm2-emc/drivers/md/dm-emc.c	2005-03-03 13:44:38.0=
00000000 -0800
> @@ -227,6 +227,7 @@
>  	struct emc_handler *h =3D kmalloc(sizeof(*h), GFP_KERNEL);
> =20
>  	if (h) {
> +		memset(h, 0, sizeof(*h));
>  		h->lock =3D SPIN_LOCK_UNLOCKED;
>  	}
> =20
> @@ -263,8 +264,6 @@
>  	if (!h)
>  		return -ENOMEM;
>  =09
> -	memset(h, 0, sizeof(*h));
> -=09
>  	hwh->context =3D h;
>  =09
>  	if ((h->short_trespass =3D short_trespass))
>=20
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>=20
Sincerely,
    Lars Marowsky-Br=E9e <lmb@suse.de>

--=20
High Availability & Clustering
SUSE Labs, Research and Development
SUSE LINUX Products GmbH - A Novell Business
