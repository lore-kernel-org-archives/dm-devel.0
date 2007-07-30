From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: [libmultipath] Add cciss support
Date: Tue, 31 Jul 2007 00:09:27 +0200
Message-ID: <1185833367.7103.4.camel@localhost.localdomain>
References: <469B53C9.9000303@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <469B53C9.9000303@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: Ahmad Sadeghpour <asadeghpour@novell.com>, device-mapper development <dm-devel@redhat.com>, Mike Miller <mike.miller@hp.com>
List-Id: dm-devel.ids


I commited this work as a starting point. Thank you Hannes.

I hope to get an insight of what cciss multipathing means when the HP
patchs start to flow ... multi-initiator SAS ? I'm interested :)

Regards,
cvaroqui

Le lundi 16 juillet 2007 =C3=A0 13:17 +0200, Hannes Reinecke a =C3=A9crit=
 :
> Hi Christophe,
>=20
> HP asked me to implement cciss support for multipathing.
> Apparently their newer HBAs are multipathing capable.
> However, I have no idea about the failover method they're
> using; so I used multibus as a default.
> Maybe someone from HP can comment on this.
>=20
> There were several patches floating around which tried to
> achieve the same but given that they're trying to access
> /sys/block/cciss!cXdY/device (which doesn't exist for cciss)
> I doubt they'll do anything sensible.
>=20
> Please commit.
>=20
> Cheers,
>=20
> Hannes
> pi=C3=A8ce jointe document plein texte (multipath-tools-enable-cciss)
> tree df9be98603906572e64ce368beb37befe7e17fd8
> parent 384e85dfd13c58cfa9ef752aed1530b46116119d
> author Hannes Reinecke <hare@suse.de> 1184584249 +0200
> committer Hannes Reinecke <hare@suse.de> 1184584249 +0200
>=20
> libmultipath: Add support for cciss devices
>=20
> This patch enables multipath support for cciss devices.
>=20
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> 85dd54f10fb296c609b5537e802b491b167ca02f
>  libmultipath/blacklist.c |    8 +---
>  libmultipath/discovery.c |  101 ++++++++++++++++++++++++++++++++++++++=
++++---
>  libmultipath/hwtable.c   |   16 +++++++
>  libmultipath/structs.h   |    1 +
>  4 files changed, 112 insertions(+), 14 deletions(-)
>=20
> diff --git a/libmultipath/blacklist.c b/libmultipath/blacklist.c
> index 82a6a58..92ddec6 100644
> --- a/libmultipath/blacklist.c
> +++ b/libmultipath/blacklist.c
> @@ -114,12 +114,6 @@ setup_default_blist (struct config * conf)
>  		return 1;
>  	if (store_ble(conf->blist_devnode, str, ORIGIN_DEFAULT))
>  		return 1;
> -=09
> -	str =3D STRDUP("^cciss!c[0-9]d[0-9]*");
> -	if (!str)
> -		return 1;
> -	if (store_ble(conf->blist_devnode, str, ORIGIN_DEFAULT))
> -		return 1;
> =20
>  	vector_foreach_slot (conf->hwtable, hwe, i) {
>  		if (hwe->bl_product) {
> @@ -136,7 +130,7 @@ setup_default_blist (struct config * conf)
>  			}
>  		}
>  	}
> -=09
> +
>  	return 0;
>  }
> =20
> diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
> index e3d4cd5..6219973 100644
> --- a/libmultipath/discovery.c
> +++ b/libmultipath/discovery.c
> @@ -70,9 +70,11 @@ path_discover (vector pathvec, struct config * conf,=
 char * devname, int flag)
>  		condlog(0, "path too small");
>  		return 1;
>  	}
> -		=09
> -	if (!filepresent(path))
> +
> +	if (strncmp(devname,"cciss",5) && !filepresent(path)) {
> +		condlog(4, "path %s not present", path);
>  		return 0;
> +	}
> =20
>  	pp =3D find_path_by_dev(pathvec, devname);
> =20
> @@ -207,12 +209,18 @@ sysfs_get_fc_nodename (struct sysfs_device * dev,=
 char * node,
>  static int
>  opennode (char * dev, int mode)
>  {
> -	char devpath[FILE_NAME_SIZE];
> +	char devpath[FILE_NAME_SIZE], *ptr;
> =20
>  	if (safe_sprintf(devpath, "%s/%s", conf->udev_dir, dev)) {
>  		condlog(0, "devpath too small");
>  		return -1;
>  	}
> +	/* Translate '!' into '/' */
> +	ptr =3D devpath;
> +	while ((ptr =3D strchr(ptr, '!'))) {
> +		*ptr =3D '/';
> +		ptr++;
> +	}
> =20
>  	return open(devpath, mode);
>  }
> @@ -342,6 +350,27 @@ get_serial (char * str, int maxlen, int fd)
>  }
> =20
>  static int
> +get_inq (char * vendor, char * product, char * rev, int fd)
> +{
> +	int len =3D 0;
> +	char buff[MX_ALLOC_LEN + 1] =3D {0};
> +
> +	if (fd < 0)
> +		return 1;
> +
> +	if (0 =3D=3D do_inq(fd, 0, 0, 0, buff, MX_ALLOC_LEN, 0)) {
> +		memcpy(vendor, buff + 8, 8);
> +		vendor[8] =3D '\0';
> +		memcpy(product, buff + 16, 16);
> +		product[16] =3D '\0';
> +		memcpy(rev, buff + 32, 4);
> +		rev[4] =3D '\0';
> +		return 0;
> +	}
> +	return 1;
> +}
> +
> +static int
>  scsi_sysfs_pathinfo (struct path * pp, struct sysfs_device * parent)
>  {
>  	char attr_path[FILE_NAME_SIZE];
> @@ -445,6 +474,31 @@ ccw_sysfs_pathinfo (struct path * pp, struct sysfs=
_device * parent)
>  }
> =20
>  static int
> +cciss_sysfs_pathinfo (struct path * pp, struct sysfs_device * dev)
> +{
> +	char attr_path[FILE_NAME_SIZE];
> +	char attr_buff[FILE_NAME_SIZE];
> +
> +	/*
> +	 * host / bus / target / lun
> +	 */
> +	basename(dev->devpath, attr_path);
> +	pp->sg_id.lun =3D 0;
> +	pp->sg_id.channel =3D 0;
> +	sscanf(attr_path, "cciss!c%id%i",
> +			&pp->sg_id.host_no,
> +			&pp->sg_id.scsi_id);
> +	condlog(3, "%s: h:b:t:l =3D %i:%i:%i:%i",
> +			pp->dev,
> +			pp->sg_id.host_no,
> +			pp->sg_id.channel,
> +			pp->sg_id.scsi_id,
> +			pp->sg_id.lun);
> +
> +	return 0;
> +}
> +
> +static int
>  common_sysfs_pathinfo (struct path * pp, struct sysfs_device *dev)
>  {
>  	char *attr;
> @@ -486,18 +540,22 @@ sysfs_pathinfo(struct path * pp)
>  		condlog(1, "%s: failed to get sysfs information", pp->dev);
>  		return 1;
>  	}
> -=09
> -	parent =3D sysfs_device_get_parent(pp->sysdev);
> =20
>  	if (common_sysfs_pathinfo(pp, pp->sysdev))
>  		return 1;
> =20
> +	parent =3D sysfs_device_get_parent(pp->sysdev);
> +	if (!parent)
> +		parent =3D pp->sysdev;
> +
>  	condlog(3, "%s: subsystem =3D %s", pp->dev, parent->subsystem);
> =20
>  	if (!strncmp(parent->subsystem, "scsi",4))
>  		pp->bus =3D SYSFS_BUS_SCSI;
>  	if (!strncmp(parent->subsystem, "ccw",3))
>  		pp->bus =3D SYSFS_BUS_CCW;
> +	if (!strncmp(pp->dev,"cciss",5))
> +		pp->bus =3D SYSFS_BUS_CCISS;
> =20
>  	if (pp->bus =3D=3D SYSFS_BUS_UNDEF)
>  		return 0;
> @@ -507,6 +565,9 @@ sysfs_pathinfo(struct path * pp)
>  	} else if (pp->bus =3D=3D SYSFS_BUS_CCW) {
>  		if (ccw_sysfs_pathinfo(pp, parent))
>  			return 1;
> +	} else if (pp->bus =3D=3D SYSFS_BUS_CCISS) {
> +		if (cciss_sysfs_pathinfo(pp, pp->sysdev))
> +			return 1;
>  	}
>  	return 0;
>  }
> @@ -523,6 +584,25 @@ scsi_ioctl_pathinfo (struct path * pp, int mask)
>  }
> =20
>  static int
> +cciss_ioctl_pathinfo (struct path * pp, int mask)
> +{
> +	if (mask & DI_SYSFS) {
> +		get_inq(pp->vendor_id, pp->product_id, pp->rev, pp->fd);
> +		condlog(3, "%s: vendor =3D %s", pp->dev, pp->vendor_id);
> +		condlog(3, "%s: product =3D %s", pp->dev, pp->product_id);
> +		condlog(3, "%s: revision =3D %s", pp->dev, pp->rev);
> +		/*
> +		 * set the hwe configlet pointer
> +		 */
> +		pp->hwe =3D find_hwe(conf->hwtable, pp->vendor_id,
> +				   pp->product_id, pp->rev);
> +
> +	}
> +
> +	return 0;
> +}
> +
> +static int
>  get_state (struct path * pp)
>  {
>  	struct checker * c =3D &pp->checker;
> @@ -610,16 +690,23 @@ pathinfo (struct path *pp, vector hwtable, int ma=
sk)
>  	if (pp->fd < 0)
>  		pp->fd =3D opennode(pp->dev, O_RDONLY);
> =20
> -	if (pp->fd < 0)
> +	if (pp->fd < 0) {
> +		condlog(4, "Couldn't open node for %s: %s",
> +			pp->dev, strerror(errno));
>  		goto blank;
> +	}
> =20
>  	if (pp->bus =3D=3D SYSFS_BUS_SCSI &&
>  	    scsi_ioctl_pathinfo(pp, mask))
>  		goto blank;
> =20
> +	if (pp->bus =3D=3D SYSFS_BUS_CCISS &&
> +	    cciss_ioctl_pathinfo(pp, mask))
> +		goto blank;
> +
>  	if (mask & DI_CHECKER && get_state(pp))
>  		goto blank;
> -=09
> +
>  	 /*
>  	  * Retrieve path priority even for not PATH_UP paths if it has never
>  	  * been successfully obtained before.
> diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
> index 356e184..fb1a808 100644
> --- a/libmultipath/hwtable.c
> +++ b/libmultipath/hwtable.c
> @@ -153,6 +153,22 @@ static struct hwentry default_hw[] =3D {
>  		.minio         =3D DEFAULT_MINIO,
>  		.checker_name  =3D TUR,
>  	},
> +	{
> +		/* HP Smart Array */
> +		.vendor        =3D "HP",
> +		.product       =3D "LOGICAL VOLUME.*",
> +		.getuid        =3D "/lib/udev/scsi_id -n -g -u -s /block/%n",
> +		.getprio       =3D NULL,
> +		.features      =3D DEFAULT_FEATURES,
> +		.hwhandler     =3D DEFAULT_HWHANDLER,
> +		.selector      =3D DEFAULT_SELECTOR,
> +		.pgpolicy      =3D MULTIBUS,
> +		.pgfailback    =3D FAILBACK_UNDEF,
> +		.rr_weight     =3D RR_WEIGHT_NONE,
> +		.no_path_retry =3D NO_PATH_RETRY_UNDEF,
> +		.minio         =3D DEFAULT_MINIO,
> +		.checker_name  =3D TUR,
> +	},
>  	/*
>  	 * DDN controller family
>  	 *
> diff --git a/libmultipath/structs.h b/libmultipath/structs.h
> index 75322aa..f821f87 100644
> --- a/libmultipath/structs.h
> +++ b/libmultipath/structs.h
> @@ -46,6 +46,7 @@ enum sysfs_buses {
>  	SYSFS_BUS_SCSI,
>  	SYSFS_BUS_IDE,
>  	SYSFS_BUS_CCW,
> +	SYSFS_BUS_CCISS,
>  };
> =20
>  enum pathstates {
