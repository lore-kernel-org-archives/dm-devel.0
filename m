From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 0/8] dm: request-based dm-multipath
Date: Wed, 11 Mar 2009 13:28:29 +0100
Message-ID: <49B7AE6D.1080301@suse.de>
References: <20081003.110825.74754936.k-ueda@ct.jp.nec.com>	<20090128154019.GB23158@agk.fab.redhat.com>	<49815863.8040806@ct.jp.nec.com>	<20090129104147.GB9870@pentland.suse.de>	<4982B4C6.8050904@ct.jp.nec.com>
	<49B60444.2090008@ct.jp.nec.com> <49B613FE.3060501@suse.de>
	<49B6221E.1030203@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <49B6221E.1030203@ct.jp.nec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi Kiyoshi,

Kiyoshi Ueda wrote:
> Hi Hannes,
>=20
[ .. ]
>=20
> Suspend was broken.
> dm_suspend() recognized that suspend completed while some requests
> were still in flight.  So we could swap/free the in-use table while
> there was in_flight request.
> The patch is like the attached one, although it is not finalized and
> I'm testing now.
> I'll post an updated patch-set including the attached patch
> this week or next week.
>=20
>=20
> ---
>  drivers/md/dm.c |  236 ++++++++++++++++++++++++++++++++++-------------=
---------
>  1 file changed, 144 insertions(+), 92 deletions(-)
>=20
> Index: 2.6.29-rc2/drivers/md/dm.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- 2.6.29-rc2.orig/drivers/md/dm.c
> +++ 2.6.29-rc2/drivers/md/dm.c
> @@ -701,11 +701,17 @@ static void free_bio_clone(struct reques
>  	}
>  }
> =20
> -static void dec_rq_pending(struct dm_rq_target_io *tio)
> +/*
> + * XXX: Not taking queue lock for efficiency.
> + *      For correctness, waiters will check that again with queue lock=
 held.
> + *      No false negative because this function will be called everyti=
me
> + *      in_flight is decremented.
> + */
> +static void rq_completed(struct mapped_device *md)
>  {
> -	if (!atomic_dec_return(&tio->md->pending))
> +	if (!md->queue->in_flight)
>  		/* nudge anyone waiting on suspend queue */
> -		wake_up(&tio->md->wait);
> +		wake_up(&md->wait);
>  }
> =20
Hmm. Don't think that's a good idea. Either take the spinlock here or
in_flight should be atomic.

Apart from this I'll give it a shot.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: Markus Rex, HRB 16746 (AG N=C3=BCrnberg)
