From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH 09/15] libmultipath: add code to get vendor
 specific vpd data
Date: Fri, 17 Jan 2020 17:56:40 +0100
Message-ID: <6d1c7f92c9d68c8a1e602ecb36cc1390e0f936de.camel@suse.de>
References: <1579227500-17196-1-git-send-email-bmarzins@redhat.com>
	<1579227500-17196-10-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1579227500-17196-10-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Thu, 2020-01-16 at 20:18 -0600, Benjamin Marzinski wrote:
> This adds the wildcard 'g' for multipath and path formatted printing,
> which returns extra data from a device's vendor specific vpd
> page.  The
> specific vendor vpd page to use, and the vendor/product id to decode
> it
> can be set in the hwentry with vpd_vendor_pg and vpd_vendor_id. It
> can
> be configured in the devices section of multipath.conf with the
> vpd_vendor parameter. Currently, the only devices that use this are
> HPE
> 3PAR arrays, to return the Volume Name.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  libmultipath/config.c      |  4 ++++
>  libmultipath/config.h      |  2 ++
>  libmultipath/dict.c        | 34 ++++++++++++++++++++++++++++++++++
>  libmultipath/discovery.c   | 34 +++++++++++++++++++++++++++++++++-
>  libmultipath/hwtable.c     |  2 ++
>  libmultipath/print.c       | 27 +++++++++++++++++++++++++++
>  libmultipath/propsel.c     | 24 ++++++++++++++++++++++++
>  libmultipath/propsel.h     |  2 ++
>  libmultipath/structs.h     |  9 +++++++++
>  multipath/multipath.conf.5 |  8 ++++++++
>  10 files changed, 145 insertions(+), 1 deletion(-)
>=20
> diff --git a/libmultipath/config.c b/libmultipath/config.c
> index 85626e96..72b8d37c 100644
> --- a/libmultipath/config.c
> +++ b/libmultipath/config.c
> @@ -369,6 +369,8 @@ merge_hwe (struct hwentry * dst, struct hwentry *
> src)
>  =09merge_num(max_sectors_kb);
>  =09merge_num(ghost_delay);
>  =09merge_num(all_tg_pt);
> +=09merge_num(vpd_vendor_pg);
> +=09merge_num(vpd_vendor_id);
>  =09merge_num(san_path_err_threshold);
>  =09merge_num(san_path_err_forget_rate);
>  =09merge_num(san_path_err_recovery_time);
> @@ -517,6 +519,8 @@ store_hwe (vector hwtable, struct hwentry * dhwe)
>  =09hwe->detect_prio =3D dhwe->detect_prio;
>  =09hwe->detect_checker =3D dhwe->detect_checker;
>  =09hwe->ghost_delay =3D dhwe->ghost_delay;
> +=09hwe->vpd_vendor_pg =3D dhwe->vpd_vendor_pg;
> +=09hwe->vpd_vendor_id =3D dhwe->vpd_vendor_id;
> =20
>  =09if (dhwe->bl_product && !(hwe->bl_product =3D set_param_str(dhwe-
> >bl_product)))
>  =09=09goto out;
> diff --git a/libmultipath/config.h b/libmultipath/config.h
> index e69aa07c..589146de 100644
> --- a/libmultipath/config.h
> +++ b/libmultipath/config.h
> @@ -87,6 +87,8 @@ struct hwentry {
>  =09int max_sectors_kb;
>  =09int ghost_delay;
>  =09int all_tg_pt;
> +=09int vpd_vendor_pg;
> +=09int vpd_vendor_id;
>  =09char * bl_product;
>  };
> =20
> diff --git a/libmultipath/dict.c b/libmultipath/dict.c
> index 2b046e1d..d6d8b79b 100644
> --- a/libmultipath/dict.c
> +++ b/libmultipath/dict.c
> @@ -1366,6 +1366,39 @@ def_uxsock_timeout_handler(struct config
> *conf, vector strvec)
>  =09return 0;
>  }
> =20
> +static int
> +hw_vpd_vendor_handler(struct config *conf, vector strvec)
> +{
> +=09int rc =3D 0;
> +=09char *buff;
> +
> +=09struct hwentry * hwe =3D VECTOR_LAST_SLOT(conf->hwtable);
> +=09if (!hwe)
> +=09=09return 1;
> +
> +=09buff =3D set_value(strvec);
> +=09if (!buff)
> +=09=09return 1;
> +=09if (strcmp(buff, "hp3par") =3D=3D 0) {
> +=09=09hwe->vpd_vendor_pg =3D 0xc0;
> +=09=09hwe->vpd_vendor_id =3D VPD_VP_HP3PAR;
> +=09} else
> +=09=09rc =3D 1;
> +=09FREE(buff);
> +=09return rc;
> +}
> +
> +static int
> +snprint_hw_vpd_vendor(struct config *conf, char * buff, int len,
> +=09=09      const void * data)
> +{
> +=09const struct hwentry * hwe =3D (const struct hwentry *)data;
> +
> +=09if (hwe->vpd_vendor_pg =3D=3D 0xc0 && hwe->vpd_vendor_id =3D=3D
> VPD_VP_HP3PAR)
> +=09=09return snprintf(buff, len, "hp3par");
> +=09return 0;
> +}

I don't understand this design. The way you set up the hwe, it would be
logical to add "vpd_vendor_page" and "vpd_vendor_id" properties for
device entries.

BUT ok, that's overengineered with just one supported combination of
page and vendor. I can understand that. But then, it seems also
overengineered to carry around vpd_vendor_pg and vpd_vendor_id in the
hwe.=20

I'd suggest creating a hard-coded table with "vendor vpd schemes",

struct {
=09int pg;
=09int vendor_id;
=09const char *name;
} vendor_vpd_schemes[]  =3D {=20
    { 0xc0, VPD_VP_HP3PAR, "hp3par", },=20
    { 0, },=20
};

and in the hwentry, only carry around the index into this table,
and look up the page and vendor ID there. Actually, with just that
single user, we might as well not introduce a new device property at
all, but simply use a separate hardcoded table with lookup values for
vendor and product ID. I'm unsure if it's wise to make this
configurable via multipath.conf.

Regards,
Martin

--=20
Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
SUSE
Software Solutions Germany GmbH=20
HRB 36809 (AG N=FCrnberg) GF: Felix
Imend=F6rffer
