From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [dm-devel] [patch] dm: check for kmalloc failure in
 dm_init_request_based_blk_mq_queue()
Date: Tue, 9 Feb 2016 12:35:43 +0100
Message-ID: <20160209113543.GL27969@c203.arch.suse.de>
References: <20160209111440.GB23998@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160209111440.GB23998@mwanda>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, linux-raid@vger.kernel.org, kernel-janitors@vger.kernel.org, dm-devel@redhat.com, Shaohua Li <shli@kernel.org>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Tue, Feb 09, 2016 at 02:14:40PM +0300, Dan Carpenter wrote:
> We can just return -ENOMEM if the kzalloc() fails.
>=20
> Fixes: 41b2facaf4ba ('dm: allocate blk_mq_tag_set rather than embed i=
n mapped_device')
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>=20
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index 6b7e80e..1a5f879 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -2736,6 +2736,8 @@ static int dm_init_request_based_blk_mq_queue(s=
truct mapped_device *md,
>  	int err;
> =20
>  	md->tag_set =3D kzalloc(sizeof(struct blk_mq_tag_set), GFP_KERNEL);
> +	if (!md->tag_set)
> +		return -ENOMEM;
>  	md->tag_set->ops =3D &dm_mq_ops;
>  	md->tag_set->queue_depth =3D dm_get_blk_mq_queue_depth();
>  	md->tag_set->numa_node =3D NUMA_NO_NODE;
>=20
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel

Good catch,

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
--=20
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
HRB 21284 (AG N=FCrnberg)
Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
