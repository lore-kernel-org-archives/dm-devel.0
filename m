Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D4D2CCA47A
	for <dm-devel@archiver.kernel.org>; Tue, 14 Jun 2022 06:37:47 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-39-8FmhmV2CMtCIJKcvhPgi7Q-1; Tue, 14 Jun 2022 02:37:43 -0400
X-MC-Unique: 8FmhmV2CMtCIJKcvhPgi7Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A3FE98058A4;
	Tue, 14 Jun 2022 06:37:41 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 77669404E4C3;
	Tue, 14 Jun 2022 06:37:40 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 1A8781947B87;
	Tue, 14 Jun 2022 06:37:40 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B806A194705B
 for <dm-devel@listman.corp.redhat.com>; Mon, 13 Jun 2022 12:05:32 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A6CC2415F5E; Mon, 13 Jun 2022 12:05:32 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A1600492C3B
 for <dm-devel@redhat.com>; Mon, 13 Jun 2022 12:05:32 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 84901811E81
 for <dm-devel@redhat.com>; Mon, 13 Jun 2022 12:05:32 +0000 (UTC)
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-245-g1MWnLHRMZK20yKnRkvXeA-1; Mon, 13 Jun 2022 08:05:30 -0400
X-MC-Unique: g1MWnLHRMZK20yKnRkvXeA-1
X-IronPort-AV: E=Sophos;i="5.91,297,1647273600"; d="scan'208";a="315056561"
Received: from mail-mw2nam10lp2104.outbound.protection.outlook.com (HELO
 NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.104])
 by ob1.hgst.iphmx.com with ESMTP; 13 Jun 2022 20:04:26 +0800
Received: from DM8PR04MB8037.namprd04.prod.outlook.com (2603:10b6:8:f::6) by
 SN6PR04MB4256.namprd04.prod.outlook.com (2603:10b6:805:31::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5332.16; Mon, 13 Jun 2022 12:04:24 +0000
Received: from DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::39dc:d3d:686a:9e7]) by DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::39dc:d3d:686a:9e7%3]) with mapi id 15.20.5332.020; Mon, 13 Jun 2022
 12:04:24 +0000
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: Mike Snitzer <snitzer@kernel.org>
Thread-Topic: dm crypt: set bdev to clone bio
Thread-Index: AQHYfObTwnjRTz/m7kiP8aqM4x7tpK1I/cOAgARD34A=
Date: Mon, 13 Jun 2022 12:04:23 +0000
Message-ID: <20220613120423.vmqnsv6qdqugps57@shindev>
References: <20220609114300.453650-1-shinichiro.kawasaki@wdc.com>
 <YqNwqGeI/4sy9zn1@redhat.com> <YqOT2QGR5YaZQyIb@redhat.com>
In-Reply-To: <YqOT2QGR5YaZQyIb@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8fc40fc2-dccb-4b0c-1d88-08da4d34db6c
x-ms-traffictypediagnostic: SN6PR04MB4256:EE_
x-microsoft-antispam-prvs: <SN6PR04MB4256B820CF3C69149C4C5DBFEDAB9@SN6PR04MB4256.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: GGuRe6CAJFfG4RVc72/jLPbC58dljqhgCb92BGj+wtOivqoRt+M3qPKUsHE98DnkGqxZqD1nXRLD2ZV+URI5KyKjomYA8DdHtFEE/+3KGAU9yq1d76KkZBDn7WuGPw/DqBUTQJdctNWdqLu8pLFe+Z4nhwuak0TDv0t9QoWCvRbyVU825I+K0jjkHfbTc0EMGYydVjxD9ZugDzbcSAD5DLR/xj1n9Ectk3R+/oSehajIZ2v5UIXkLsmuAIhgxaB99klykqRO/gOD2vPR1h2hCHgr3cs2yXssz48yzmgrrNBJBtiJbNcO/05yYyUkZBdsZ+qc5ODO8jVSW1IE9g0PuUgWkh22LtW3OUM55h/DTFUbNv5IvKHdy/3kxNHyGXP/VqlOOxUyPB6kmmUXFfpl4RQlJpUsZgG3Ul+pnuiEER/8oqXmGEVnRoEBV+oNBTURMetRQ3Y/gm78LZ7ocsDxslosXZpq19FFXxXXsYyh7Znryha6aZpdPg/Ufw/uc6oI2b10DP60Hxr0zZw7Wuoq0xCqmXoucFokunxVpUZuIGFzJsARhYRTVw5DhYXhhH8hv1EfPPG14RZo1MqBRgmNW6dNGrA96UmNeFE4wXlBnwi1ccbkFmyEegN0hM6wHqZUjuL2ykKuXnywRR5da0CMXE/rzSVjZpJsOZse0R/eFCEnmK2dEZgca4bWUOb0Uxse3HYgIdTUXyojeFpKsc+iINDH/mfNRiTMdKnWqhOB1RGHqwkZazVxJYyvARP3lfQggfbx4EHKYmTGSpCC5CJUe42EyCmcemQPDlpJ+aModtY=
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DM8PR04MB8037.namprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230016)(7916004)(4636009)(366004)(186003)(86362001)(1076003)(82960400001)(83380400001)(71200400001)(91956017)(66946007)(4326008)(8676002)(66476007)(6916009)(64756008)(54906003)(316002)(76116006)(66446008)(6506007)(66556008)(5660300002)(8936002)(6486002)(33716001)(38070700005)(38100700002)(6512007)(26005)(9686003)(122000001)(2906002)(966005)(44832011)(508600001);
 DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?eMz2i17+kR9PUGv+rN9mEDoMg5KyqWWWxHbcbJZPU4vAgSxtAV7DFbEJGHl5?=
 =?us-ascii?Q?R87WZZckcDu4V+e8UX4t1b/Iz79pHKgXdHLyAAEBH6bt7XvLSKeVADusJD4S?=
 =?us-ascii?Q?hsfu8TpqWyrfZXk3s6n0ZOZLHoHT1bxOl4wDIsGGyewf+g4Tc2J+vLcmqXSI?=
 =?us-ascii?Q?MXHYegBT1Jch99hUuRaVGVpBBIbe2/ingyYdGpOra8d9fKID73mvgOrEJjQj?=
 =?us-ascii?Q?UNyIuyrfuu5lWVOpu9kV6UVUcMBalwFpdkUM+g13zyUIrJ5qxudRBA9IeEQ0?=
 =?us-ascii?Q?iDHaG+StFBElqIN6/CAtzgOGVysX4kR3hfzWhmpRf8x9ZimU5IrHOiA2Btq5?=
 =?us-ascii?Q?fUQQ+iUOIwGaBBDlCfV0AWJ0cTEn5QJCXD8ZFJjxcTPOYc1xiUyU+htPcjK8?=
 =?us-ascii?Q?ned23HNOulpe0D0rLWn58Lpf059QO3Dpa4zUD5SE9gGkIRqZvBDomB6K00r6?=
 =?us-ascii?Q?1ueFPp4YCS9X1XNY4hEzBCOt8+K4/vJLPUKWU3TPk4dwYmkYjZwrIEX/dSVC?=
 =?us-ascii?Q?svlq6Wt4AG2XPStKSv/xiCGixjdnI7PP4/tfvnG+OFF2WbPuqcJ3x0UDH6Lc?=
 =?us-ascii?Q?QxHEKMNuO4JrtYIS9yHIWaYb8hMqm+HcsvE6GQ0htZXn1/hi72pxpW2YqTVY?=
 =?us-ascii?Q?uun+IK7hg7sX/rxBkBmcM7ScrC5Vi5rtuXEafRI7ze60UhsywmkT56hLgDXL?=
 =?us-ascii?Q?KAyozyp1xTkCP1P4i7odwnik/IVmQ+JEpgBfeZ3pZf+yfpNbW7me9vQuZnSu?=
 =?us-ascii?Q?nCV9kgoNq8DW4Pefh9a27HVlnArZnDkuYgjkE3ehgFVa5xJR/fz35JOdKaGr?=
 =?us-ascii?Q?WiT5ze/2Z5WG9KJAGX1Z299gvtXtOrko92FzN8MIRAjBsJhNrpwEbLaADaDu?=
 =?us-ascii?Q?xlbKcRU76rvR7zyGeNewvyAuqnU3bQy1nHMKze6eFIzMcHAGlN6k1l6FWTbg?=
 =?us-ascii?Q?eXxAdzj8zWwW4ZPJRbs9PPJt9CVLrbhibivZwYKVGskwg5mpxopIROinh4Lk?=
 =?us-ascii?Q?Qi7mq5JShIaI9JclvVBN026zvbex+dlAZV/LYLaTq6yPhElna232gPUoBi5I?=
 =?us-ascii?Q?vfAa4h+C9gYYAKk60V8DhGRCc/KfaFVQCt0o2l643YyvWXe6Vb+NxoznHnVg?=
 =?us-ascii?Q?OMxziqmrRg1GxjUSFrZVXffvbVvbv1JyxJzpXvdnZb2oQc1IYQ79Ez/MKctZ?=
 =?us-ascii?Q?9JNjXcrPfA2SIWPohqNov4ijhvT6YL3/zcfj0gTMa69R1K3knz+p7ThQVPJm?=
 =?us-ascii?Q?vxYRrbamKU2DSAed+Jsh/C/fkdm9J8f5MeJkTLCP6bC9u6rk9HGw4ZW8WF01?=
 =?us-ascii?Q?Wy/zzVMb5VyvrDKUvuAqRs27JRiYSvrsMfB0i2WGjO5ZwhcEQ/1VFO6r0KNk?=
 =?us-ascii?Q?WcisvBY7prqvfGpv9EfxHHdjxxiIqHlf0IGmLX5DS8K9AOrQ9MIceJVWAV4k?=
 =?us-ascii?Q?SGbxNwVeZyp7apE/61kK99xrQwASDIcrv3HqXeqEymSKBhHDUqeq8ZS3IxSZ?=
 =?us-ascii?Q?tolqBcyYTWRjqREhHoIq3MsdwvggiQ/lSCZpfC9PGvLesaXa5dvd4Z/8VQhi?=
 =?us-ascii?Q?KAZOJRtWUPSxC/mkUGhmAIrY9nfVrHZTESORrqskwedDxZZTGWLLw7I9J/E3?=
 =?us-ascii?Q?6FHnG+qfkwceAjS5KIKEAk2ocxXLG4toQvdlSK50aetwg9qHel43vMfn/W+s?=
 =?us-ascii?Q?Ssk/LdIg6Ecc7fQRY+lDvYDs6591Hgrsjl5+avwcwsIia2KTSn/S67i91v7i?=
 =?us-ascii?Q?+sYeZUPBC8DmdPWYMrze93L6YaQqtFrBPJU89fgphQiSLqq5xk4p?=
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR04MB8037.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8fc40fc2-dccb-4b0c-1d88-08da4d34db6c
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jun 2022 12:04:24.0811 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vvlsMPcmS9DmFyLyaqg4hyWkWEfZxP1hgtDJZsoqmoPMKyNTCRuaOWXFUL/S46LyrfPhEsUuw7y3yGF2fOGdeiWf55TpqAi5cT1Uya4w3Yc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB4256
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Mailman-Approved-At: Tue, 14 Jun 2022 06:37:38 +0000
Subject: Re: [dm-devel] dm crypt: set bdev to clone bio
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>,
 Damien Le Moal <damien.lemoal@opensource.wdc.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <74FF9DCDB4D19D49B1C60398F45A22B4@namprd04.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Jun 10, 2022 / 14:56, Mike Snitzer wrote:
> On Fri, Jun 10 2022 at 12:26P -0400,
> Mike Snitzer <snitzer@kernel.org> wrote:
> 
> > On Thu, Jun 09 2022 at  7:43P -0400,
> > Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com> wrote:
> > 
> > > After the commit ca522482e3ea ("dm: pass NULL bdev to bio_alloc_clone"),
> > > bdev is no longer set to clone bio for ->map function. Instead, each DM
> > > targets shall set bdev to the clone bio by calling bio_set_dev() before
> > > issuing IO. Also the commit ensured that dm_zone_endio() is called from
> > > clone_endio() only when DM targets set bdev to the clone bio.
> > > 
> > > However, crypt_map() of dm-crypt does not call bio_set_dev() for every
> > > clone bio. Then dm_zone_endio() is not called at completion of the bios
> > > and zone locks are not properly unlocked. This triggers a hang when
> > > blktests block/004 is run for dm-crypt on zoned block devices [1]. To
> > > avoid the hang, call bio_set_dev() for every bio in crypt_map().
> > > 
> > > [1]
> > > 
> > > [ 6596.702977][T55017] run blktests block/004 at 2022-06-07 20:18:01
> > 
> > <snip>
> > 
> > Please refrain from putting stack traces in patch headers whenever
> > possible.  Really no need for this, especially given how long this one
> > is!
> > 
> > I revised the header as follows:
> > https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-5.19&id=cae0053631cd4b02bb882b53c7da20652b038049

I see. I will keep this in mind for my future patches. Thanks.

> >  
> > > Fixes: ca522482e3ea ("dm: pass NULL bdev to bio_alloc_clone")
> > > Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> > > ---
> > >  drivers/md/dm-crypt.c | 3 ++-
> > >  1 file changed, 2 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
> > > index 159c6806c19b..c68523a89428 100644
> > > --- a/drivers/md/dm-crypt.c
> > > +++ b/drivers/md/dm-crypt.c
> > > @@ -3378,6 +3378,8 @@ static int crypt_map(struct dm_target *ti, struct bio *bio)
> > >  	struct dm_crypt_io *io;
> > >  	struct crypt_config *cc = ti->private;
> > >  
> > > +	bio_set_dev(bio, cc->dev->bdev);
> > > +
> > >  	/*
> > >  	 * If bio is REQ_PREFLUSH or REQ_OP_DISCARD, just bypass crypt queues.
> > >  	 * - for REQ_PREFLUSH device-mapper core ensures that no IO is in-flight
> > > @@ -3385,7 +3387,6 @@ static int crypt_map(struct dm_target *ti, struct bio *bio)
> > >  	 */
> > >  	if (unlikely(bio->bi_opf & REQ_PREFLUSH ||
> > >  	    bio_op(bio) == REQ_OP_DISCARD)) {
> > > -		bio_set_dev(bio, cc->dev->bdev);
> > >  		if (bio_sectors(bio))
> > >  			bio->bi_iter.bi_sector = cc->start +
> > >  				dm_target_offset(ti, bio->bi_iter.bi_sector);
> > > -- 
> > > 2.36.1
> > > 
> > 
> > BUT something isn't quite adding up with why you need this change
> > given commit ca522482e3ea has this compatibility code:
> > 
> > diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> > index 9650ba2075b8..d62f1354ecbf 100644
> > --- a/drivers/md/dm.c
> > +++ b/drivers/md/dm.c
> > @@ -581,7 +581,9 @@ static struct dm_io *alloc_io(struct mapped_device *md, struct bio *bio)
> >         struct dm_target_io *tio;
> >         struct bio *clone;
> > 
> > -       clone = bio_alloc_clone(bio->bi_bdev, bio, GFP_NOIO, &md->io_bs);
> > +       clone = bio_alloc_clone(NULL, bio, GFP_NOIO, &md->io_bs);
> > +       /* Set default bdev, but target must bio_set_dev() before issuing IO */
> > +       clone->bi_bdev = md->disk->part0;
> > 
> >         tio = clone_to_tio(clone);
> >         tio->flags = 0;
> > 
> > The clone bio passed to crypt_map() _should_ be the same as was passed
> > before commit ca522482e3ea (It gets set to md->disk->part0 rather than
> > bio->bi_bdev but they really should point to the same top-level DM
> > bdev).
> > 
> > So why is your extra override to have dm-crypt point to its underlying
> > data device important now?
> 
> Think the issue is not that the clone->bi_bdev isn't set.  It is that
> it is merely not changed from the md->disk->part0 default.
> 
> Commit ca522482e3ea added this to clone_endio:
> 
> if (likely(bio->bi_bdev != md->disk->part0)) {
>       ...
>       if (static_branch_unlikely(&zoned_enabled) &&
> 	  unlikely(blk_queue_is_zoned(q)))
> 	      dm_zone_endio(io, bio);
> }
> 
> So dm_zone_endio() isn't called unless you force dm-crypt (or any
> other target) to remap the clone bio to a different bdev.

Yes, I have same understanding. I assumed the bio->bi_bdev != md->disk->part0
can not be removed, and suggested to dm-crypt to remap all clone bios.

> 
> It is weird that a bio is completing without having been remapped by
> dm-crypt; but there could be any number of reasons why that hasn't
> happened.
> 
> Anyway, I think a correct fix needs to be to the logic in
> clone_endio().  Could be that its best to just remove the gating
> likely() conditional.
> 
> Can you please test this patch instead of your patch?

I tried this new patch and confirmed it avoids the hang. Looks good :)

Also, I ran my test set for the patch in same manner I did for the dm-5.19
branch, and observed no failure. Good. I found that this patch is already
pulled into v5.19-rc2, and a bit surprised. It looks too late to put my
Tested-by tag. Anyway, thanks for the fix.

-- 
Shin'ichiro Kawasaki

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

