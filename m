From: Martin Wilck <Martin.Wilck@suse.com>
Subject: Re: [PATCH v2 10/17] libmultipath: add code to get
 vendor specific vpd data
Date: Mon, 10 Feb 2020 14:49:38 +0000
Message-ID: <ad6542e5dce892c1b631f661c51c2e4d107d699c.camel@suse.com>
References: <1580929100-32572-1-git-send-email-bmarzins@redhat.com>
	<1580929100-32572-11-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1580929100-32572-11-git-send-email-bmarzins@redhat.com>
Content-Language: en-US
Content-ID: <BA64D792C6021E4EA593FC160E4B3FB9@namprd18.prod.outlook.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "bmarzins@redhat.com" <bmarzins@redhat.com>, "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Wed, 2020-02-05 at 12:58 -0600, Benjamin Marzinski wrote:
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
>  libmultipath/config.c      |  2 ++
>  libmultipath/config.h      |  1 +
>  libmultipath/dict.c        | 38 ++++++++++++++++++++++++++++++++++++
>  libmultipath/discovery.c   | 40
> +++++++++++++++++++++++++++++++++++++-
>  libmultipath/hwtable.c     |  1 +
>  libmultipath/print.c       | 25 ++++++++++++++++++++++++
>  libmultipath/propsel.c     | 18 +++++++++++++++++
>  libmultipath/propsel.h     |  1 +
>  libmultipath/structs.h     | 15 ++++++++++++++
>  multipath/multipath.conf.5 |  8 ++++++++
>  10 files changed, 148 insertions(+), 1 deletion(-)
>=20
> diff --git a/libmultipath/structs.h b/libmultipath/structs.h
> index 1c32a799..6c03ee5d 100644
> --- a/libmultipath/structs.h
> +++ b/libmultipath/structs.h
> @@ -21,6 +21,7 @@
>  #define HOST_NAME_LEN=09=0916
>  #define SLOT_NAME_SIZE=09=0940
>  #define PRKEY_SIZE=09=0919
> +#define VPD_DATA_SIZE=09=09128
> =20
>  #define SCSI_VENDOR_SIZE=099
>  #define SCSI_PRODUCT_SIZE=0917
> @@ -221,6 +222,18 @@ enum all_tg_pt_states {
>  =09ALL_TG_PT_ON =3D YNU_YES,
>  };
> =20
> +enum vpd_vendor_ids {
> +=09VPD_VP_UNDEF,
> +=09VPD_VP_HP3PAR,
> +=09VPD_VP_ARRAY_SIZE, /* This must remain the last entry */
> +};
> +
> +struct vpd_vendor_page {
> +=09int pg;
> +=09const char *name;
> +};
> +extern struct vpd_vendor_page vpd_vendor_pages[VPD_VP_ARRAY_SIZE];
> +
>  struct sg_id {
>  =09int host_no;
>  =09int channel;
> @@ -255,6 +268,7 @@ struct path {
>  =09char rev[PATH_REV_SIZE];
>  =09char serial[SERIAL_SIZE];
>  =09char tgt_node_name[NODE_NAME_SIZE];
> +=09char vpd_data[VPD_DATA_SIZE];


Hm, 128 more bytes per path for a rarely-used property... do we need to
store this in "struct path"? Can't we simply fetch that information
when someone requests it with the %g format wildcard? It doesn't matter
much today as "struct path" is really thick already, but I have hopes
to make it a bit leaner some day.

Regards
Martin

--=20
Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
SUSE  Software Solutions Germany GmbH
HRB 36809, AG N=FCrnberg GF: Felix
Imend=F6rffer
