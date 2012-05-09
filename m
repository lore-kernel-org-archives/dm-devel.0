From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 1/5] dm mpath: only try to load the
 scsi_dh module if the scsi_dh doesn't exist
Date: Wed, 09 May 2012 08:57:14 +0200
Message-ID: <4FAA154A.6020703@suse.de>
References: <1336514167-15393-1-git-send-email-snitzer@redhat.com>
	<1336514167-15393-2-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1336514167-15393-2-git-send-email-snitzer@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com, babu.moger@netapp.com, agk@redhat.com
List-Id: dm-devel.ids

On 05/08/2012 11:56 PM, Mike Snitzer wrote:
> There have been reports of multipath table loads hanging due to
> __request_module hanging (for some unknown reason).
> =

> More often than not, the scsi_dh is already available and there is no
> need to request_module().
> =

> Reported-by: Ben Marzinski <bmarzins@redhat.com>
> Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> ---
>  drivers/md/dm-mpath.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> =

> diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
> index 922a338..754f38f 100644
> --- a/drivers/md/dm-mpath.c
> +++ b/drivers/md/dm-mpath.c
> @@ -718,8 +718,8 @@ static int parse_hw_handler(struct dm_arg_set *as, st=
ruct multipath *m)
>  		return 0;
>  =

>  	m->hw_handler_name =3D kstrdup(dm_shift_arg(as), GFP_KERNEL);
> -	request_module("scsi_dh_%s", m->hw_handler_name);
> -	if (scsi_dh_handler_exist(m->hw_handler_name) =3D=3D 0) {
> +	if (!try_then_request_module(scsi_dh_handler_exist(m->hw_handler_name),
> +				     "scsi_dh_%s", m->hw_handler_name)) {
>  		ti->error =3D "unknown hardware handler type";
>  		ret =3D -EINVAL;
>  		goto fail;

Acked-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
