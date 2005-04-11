From: Dave Olien <dmo@osdl.org>
Subject: Re: New -udm?
Date: Sun, 10 Apr 2005 18:14:44 -0700
Message-ID: <20050411011444.GA3748@osdl.org>
References: <20050410192934.GP12752@marowsky-bree.de>
	<1113164717.8372.2.camel@zezette> <4259B895.4070600@us.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4259B895.4070600@us.ibm.com>
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
Cc: Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids


You're correct.  I'll rewrite it on Thursday this week.
I'll use the same methods Lars used in the dm-emc.c


On Sun, Apr 10, 2005 at 04:36:53PM -0700, Mike Christie wrote:
> christophe varoqui wrote:
> >On dim, 2005-04-10 at 21:29 +0200, Lars Marowsky-Bree wrote:
> >
> >>Hi Alasdair,
> >>
> >>I'm resync'ing against -udm and would like to pull all recent fixes i=
f
> >>possible. Do you have anything more recent than the 2.6.11-rc3-udm2?
> >>
> >>
> >>Sincerely,
> >>   Lars Marowsky-Br=E9e <lmb@suse.de>
> >>
> >There is this hwhandler from Dave Olien, that needs auditing, but is a
> >must-have for StorageWorks and FSC FibreCat users.
> >
> >http://christophe.varoqui.free.fr/multipath-tools/dm-scsi-start.patch
> >
> >Would be good to have in an enterprise distro ...
> >
> >Regards,
>=20
>=20
>=20
> +static void sstart_pg_init(struct hw_handler *hwh, unsigned bypassed,
> +			struct path *path)
> +{
> +	struct block_device *bdev =3D path->dev->bdev;
> +	struct gendisk *disk =3D bdev->bd_disk;
> +	struct scsi_device *sdev =3D scsi_disk(disk)->device;
> +	int result;
> +
> +	result =3D scsi_ioctl(sdev, SCSI_IOCTL_START_UNIT, NULL);
>=20
>=20
>=20
> is scsi_ioctl depreciated for this use? Besides that I think it=20
> allocates memory with GFP_KERNEL which I do not think you want here, an=
d=20
> you will want some way to gaurantee you can make forward progress.
>=20
>=20
> +	dm_pg_init_complete(path, result?MP_FAIL_PATH:0);
> +}
> +
>=20
>=20
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
