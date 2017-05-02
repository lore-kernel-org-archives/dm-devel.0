From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH v2 10/10] dm-zoned: Drive-managed zoned block device
 target
Date: Tue, 2 May 2017 21:53:41 +0000
Message-ID: <1493762020.2552.15.camel@sandisk.com>
References: <20170501175314.10922-1-damien.lemoal@wdc.com>
         <20170501175314.10922-11-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170501175314.10922-11-damien.lemoal@wdc.com>
Content-Language: en-US
Content-ID: <BAF4FD6E9160D646BB006A218540E3D4@namprd04.prod.outlook.com>
Sender: linux-block-owner@vger.kernel.org
To: "dm-devel@redhat.com" <dm-devel@redhat.com>, "agk@redhat.com" <agk@redhat.com>, Damien Le Moal <Damien.LeMoal@wdc.com>, "snitzer@redhat.com" <snitzer@redhat.com>
Cc: "hch@lst.de" <hch@lst.de>, "hare@suse.de" <hare@suse.de>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
List-Id: dm-devel.ids

On Tue, 2017-05-02 at 02:53 +0900, damien.lemoal@wdc.com wrote:
> +static unsigned long dmz_mblock_shrinker_count(struct shrinker *shrink,
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 struct shri=
nk_control *sc)
> +{
> +=A0=A0=A0=A0=A0=A0=A0struct dmz_target *dmz =3D
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0container_of(shrink, struct=
 dmz_target, mblk_shrinker);
> +
> +=A0=A0=A0=A0=A0=A0=A0return atomic_read(&dmz->nr_mblks);
> +}

Hello Damien,

dmz_mblock_shrinker_count() probably should return the following value sinc=
e
dmz_shrink_mblock_cache() won't free more than the this number of elements:

        max(atomic_read(&dmz->nr_mblks) - dmz->min_nr_mblks, 0)=20

But since v2 is IMHO good enough to be merged, for the whole series:

Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>=
