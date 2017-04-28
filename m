From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH 10/10] dm-zoned: Drive-managed zoned block
	device target
Date: Fri, 28 Apr 2017 21:14:25 +0000
Message-ID: <1493414065.2767.23.camel@sandisk.com>
References: <20170421035558.2657-1-damien.lemoal@wdc.com>
	<20170421035558.2657-11-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170421035558.2657-11-damien.lemoal@wdc.com>
Content-Language: en-US
Content-ID: <FB122EB390417645800A15968927AA1F@namprd04.prod.outlook.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "dm-devel@redhat.com" <dm-devel@redhat.com>, Damien Le Moal <Damien.LeMoal@wdc.com>
Cc: "hch@lst.de" <hch@lst.de>
List-Id: dm-devel.ids

On Fri, 2017-04-21 at 12:55 +0900, damien.lemoal@wdc.com wrote:
> +static void dmz_shrink_mblock_cache(struct dmz_target *dmz, bool idle)
> +{
> +=A0=A0=A0=A0=A0=A0=A0struct dmz_mblock *mblk;
> +=A0=A0=A0=A0=A0=A0=A0unsigned int nr_mblks;
> +
> +=A0=A0=A0=A0=A0=A0=A0if (!dmz->max_nr_mblks)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return;
> +
> +=A0=A0=A0=A0=A0=A0=A0if (idle)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0nr_mblks =3D dmz->min_nr_mb=
lks;
> +=A0=A0=A0=A0=A0=A0=A0else
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0nr_mblks =3D dmz->max_nr_mb=
lks;
> +
> +=A0=A0=A0=A0=A0=A0=A0while (atomic_read(&dmz->nr_mblks) > nr_mblks &&
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 !list_empty(&dmz->mblk_lru_list)=
) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0mblk =3D list_first_entry(&=
dmz->mblk_lru_list,
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0struct dmz_mblock, link);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0list_del_init(&mblk->link);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0rb_erase(&mblk->node, &dmz-=
>mblk_rbtree);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0dmz_free_mblock(dmz, mblk);
> +=A0=A0=A0=A0=A0=A0=A0}
> +}

(off-list)

Hello Damien,

Is mblk_lru_list perhaps a cache that should be freed under memory pressure?
If so, if you repost this patch series please add a shrinker (struct shrink=
er
+ register_shrinker()) such that this memory can be freed if memory pressure
becomes too high.

Thanks,

Bart.
