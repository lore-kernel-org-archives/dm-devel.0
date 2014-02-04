From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 7/7] dm mpath: remove extra nesting in map
 function when path exists
Date: Tue, 04 Feb 2014 09:43:14 +0100
Message-ID: <52F0A822.2090009@suse.de>
References: <1391459326-21569-1-git-send-email-snitzer@redhat.com>
	<1391459326-21569-8-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1391459326-21569-8-git-send-email-snitzer@redhat.com>
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
Cc: Junichi Nomura <j-nomura@ce.jp.nec.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

On 02/03/2014 09:28 PM, Mike Snitzer wrote:
> Return early for case when no path exists, this eliminates the need for
> extra nesting for the case when a path exists (the common case).
> =

> Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> ---
>  drivers/md/dm-mpath.c | 51 +++++++++++++++++++++++++++------------------=
------
>  1 file changed, 27 insertions(+), 24 deletions(-)
> =

> diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
> index 971fbec..272e7d4 100644
> --- a/drivers/md/dm-mpath.c
> +++ b/drivers/md/dm-mpath.c
> @@ -392,32 +392,35 @@ static int multipath_map(struct dm_target *ti, stru=
ct request *clone,
>  =

>  	pgpath =3D m->current_pgpath;
>  =

> -	if (pgpath) {
> -		if (__pgpath_busy(pgpath))
> -			goto out_unlock;
> +	if (!pgpath) {
> +		if (!__must_push_back(m))
> +			r =3D -EIO;	/* Failed */
> +		goto out_unlock;
> +	}
> +
> +	if (__pgpath_busy(pgpath))
> +		goto out_unlock;
>  =

> -		if (pg_ready(m)) {
> -			if (set_mapinfo(m, map_context) < 0)
> -				/* ENOMEM, requeue */
> -				goto out_unlock;
> -
> -			bdev =3D pgpath->path.dev->bdev;
> -			clone->q =3D bdev_get_queue(bdev);
> -			clone->rq_disk =3D bdev->bd_disk;
> -			clone->cmd_flags |=3D REQ_FAILFAST_TRANSPORT;
> -			mpio =3D map_context->ptr;
> -			mpio->pgpath =3D pgpath;
> -			mpio->nr_bytes =3D nr_bytes;
> -			if (pgpath->pg->ps.type->start_io)
> -				pgpath->pg->ps.type->start_io(&pgpath->pg->ps,
> -							      &pgpath->path,
> -							      nr_bytes);
> -			r =3D DM_MAPIO_REMAPPED;
> +	if (pg_ready(m)) {
> +		if (set_mapinfo(m, map_context) < 0)
> +			/* ENOMEM, requeue */
>  			goto out_unlock;
> -		}
> -		__pg_init_all_paths(m, 0);
> -	} else if (!__must_push_back(m))
> -		r =3D -EIO;	/* Failed */
> +
> +		bdev =3D pgpath->path.dev->bdev;
> +		clone->q =3D bdev_get_queue(bdev);
> +		clone->rq_disk =3D bdev->bd_disk;
> +		clone->cmd_flags |=3D REQ_FAILFAST_TRANSPORT;
> +		mpio =3D map_context->ptr;
> +		mpio->pgpath =3D pgpath;
> +		mpio->nr_bytes =3D nr_bytes;
> +		if (pgpath->pg->ps.type->start_io)
> +			pgpath->pg->ps.type->start_io(&pgpath->pg->ps,
> +						      &pgpath->path,
> +						      nr_bytes);
> +		r =3D DM_MAPIO_REMAPPED;
> +		goto out_unlock;
> +	}
> +	__pg_init_all_paths(m, 0);
>  =

>  out_unlock:
>  	spin_unlock_irqrestore(&m->lock, flags);
> =

But then you should be going full circle and move the now somewhat
lonely statement '__pg_init_all_paths' to the top, inverting the
if (pg_ready(m))
statement.

I'll be redoing the patchset (yet again)

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
