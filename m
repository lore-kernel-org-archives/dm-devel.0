From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] multipath-tools: add Pure Storage device to
 hardware table
Date: Tue, 14 Jun 2016 07:56:44 +0200
Message-ID: <575F9C9C.4060007@suse.de>
References: <1465835437-18350-1-git-send-email-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1465835437-18350-1-git-send-email-xose.vazquez@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 06/13/2016 06:30 PM, Xose Vazquez Perez wrote:
> based on documentation provided by the manufacturer:
> https://support.purestorage.com/@api/deki/files/1733/=3DPure_Storage_Orac=
le_DB_Best_Practices.pdf?revision=3D2
> =

> vendor                  "PURE"
> product                 "FlashArray"	(extracted from outputs)
> path_selector           "round-robin 0"
> path_grouping_policy    multibus
> rr_min_io               1
> path_checker            tur
> fast_io_fail_tmo        10
> dev_loss_tmo            30
> =

> Cc: Benjamin Marzinski <bmarzins@redhat.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: device-mapper development <dm-devel@redhat.com>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> ---
>  libmultipath/hwtable.c | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
> =

> diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
> index a126b7c..c4258e1 100644
> --- a/libmultipath/hwtable.c
> +++ b/libmultipath/hwtable.c
> @@ -1195,6 +1195,22 @@ static struct hwentry default_hw[] =3D {
>  		.minio         =3D 128,
>  	},
>  	/*
> +	 * Pure Storage, Inc.
> +	 *
> +	 * Maintainer : Christophe Varoqui
> +	 * Mail : christophe.varoqui@opensvc.com
> +	 */
Please drop the 'Maintainer' line.
Christophe is the maintainer of the multipath-tools package itself, so
everything which doesn't have an explicit owner is maintained by him anyway.
Plus I think it's a bad style, appointing someone to become a maintainer
without having asked first.

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
