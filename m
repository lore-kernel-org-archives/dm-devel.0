From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] multipath: fix scsi timeout code
Date: Tue, 20 Dec 2011 16:18:23 +0100
Message-ID: <4EF0A73F.8090308@suse.de>
References: <20111219221956.GP24133@ether.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20111219221956.GP24133@ether.msp.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 12/19/2011 11:19 PM, Benjamin Marzinski wrote:
> sysfs_attr_set_value() returns the amount written on on success, or -1 on
> failure.  sysfs_setc_scsi_tmo() was checking if the return was nonzero, a=
nd
> failing if it was. This meant that it always failed out silently after wr=
iting
> the first value. I've changed the check, and added some error messages.  =
I also
> made sysfs_attr_set_value return -1 for all errors.
> =

> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  libmultipath/discovery.c |   11 +++++++++--
>  libmultipath/sysfs.c     |    2 +-
>  2 files changed, 10 insertions(+), 3 deletions(-)
> =

> Index: multipath-tools-111111/libmultipath/discovery.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- multipath-tools-111111.orig/libmultipath/discovery.c
> +++ multipath-tools-111111/libmultipath/discovery.c
> @@ -316,8 +316,11 @@ sysfs_set_scsi_tmo (struct multipath *mp
>  		if (mpp->dev_loss){
>  			snprintf(value, 11, "%u", mpp->dev_loss);
>  			if (sysfs_attr_set_value(attr_path, "dev_loss_tmo",
> -						 value, 11))
> +						 value, 11) < 0) {
> +				condlog(0, "%s failed to set %s/dev_loss_tmo",
> +					mpp->alias, attr_path);
>  				return 1;
> +			}
>  		}
>  		if (mpp->fast_io_fail){
>  			if (mpp->fast_io_fail =3D=3D -1)
> @@ -325,8 +328,12 @@ sysfs_set_scsi_tmo (struct multipath *mp
>  			else
>  				snprintf(value, 11, "%u", mpp->fast_io_fail);
>  			if (sysfs_attr_set_value(attr_path, "fast_io_fail_tmo",
> -						 value, 11))
> +						 value, 11) < 0) {
> +				condlog(0,
> +					"%s failed to set %s/fast_io_fail_tmo", =

> +					mpp->alias, attr_path);
>  				return 1;
> +			}
>  		}
>  	}
>  	return 0;
> Index: multipath-tools-111111/libmultipath/sysfs.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- multipath-tools-111111.orig/libmultipath/sysfs.c
> +++ multipath-tools-111111/libmultipath/sysfs.c
> @@ -351,7 +351,7 @@ ssize_t sysfs_attr_set_value(const char
>  	char path_full[PATH_SIZE];
>  	struct stat statbuf;
>  	int fd;
> -	ssize_t size =3D 0;
> +	ssize_t size =3D -1;
>  	size_t sysfs_len;
>  =

>  	if (!attr_name || !value || !value_len)
> =

Ah. Good point. Thanks.

Acked-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
