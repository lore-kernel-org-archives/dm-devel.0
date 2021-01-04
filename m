Return-Path: <SRS0=ovTT=GH=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBA6DC433E0
	for <dm-devel@archiver.kernel.org>; Mon,  4 Jan 2021 12:47:38 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 394BA21D93
	for <dm-devel@archiver.kernel.org>; Mon,  4 Jan 2021 12:47:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 394BA21D93
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-9-U84j_TK1O3ycDyfWBnAOfQ-1; Mon, 04 Jan 2021 07:47:34 -0500
X-MC-Unique: U84j_TK1O3ycDyfWBnAOfQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C36FE8145EF;
	Mon,  4 Jan 2021 12:47:29 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2102860BE5;
	Mon,  4 Jan 2021 12:47:29 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 167FF1809C9F;
	Mon,  4 Jan 2021 12:47:28 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 104ClP1q013626 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 4 Jan 2021 07:47:25 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 714A22026D48; Mon,  4 Jan 2021 12:47:25 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 68C532026D47
	for <dm-devel@redhat.com>; Mon,  4 Jan 2021 12:47:22 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id ACF2F8007DF
	for <dm-devel@redhat.com>; Mon,  4 Jan 2021 12:47:22 +0000 (UTC)
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-566-2jXiHuaGNwiQO_L-zM10RQ-1; Mon, 04 Jan 2021 07:47:18 -0500
X-MC-Unique: 2jXiHuaGNwiQO_L-zM10RQ-1
IronPort-SDR: ryQfaLyUgE9/LIGC4+8Z8zX6zyskNahgjTqxo4FK+74kz8IYEQu4Opp1ddqYUPJiKTKURFNcpG
	k1s046zrkJSeEw+M7pAl8LOjaQoWBShSvLelekA3lQ68g9A2JGTKH5ABudXVD8iXWDKu63sbgI
	2Fb2npOHtW64AJadUfHm9RhK34KI/wjGFhGPbCYsUatRb3kOQH33bKtCFZoUMi7vUF+jfGQZAZ
	DNtWum1h23NojpXgjiAkcqdiwT0i9TI5geNmlx6gAAgmHC8o/54ExoAx/Frf/DedoDItJ1cdR4
	G+8=
X-IronPort-AV: E=Sophos;i="5.78,474,1599494400"; d="scan'208";a="157682311"
Received: from mail-bn7nam10lp2105.outbound.protection.outlook.com (HELO
	NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.105])
	by ob1.hgst.iphmx.com with ESMTP; 04 Jan 2021 20:47:15 +0800
Received: from BL0PR04MB6514.namprd04.prod.outlook.com (2603:10b6:208:1ca::23)
	by BL0PR04MB4612.namprd04.prod.outlook.com (2603:10b6:208:47::17)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3721.23;
	Mon, 4 Jan 2021 12:47:11 +0000
Received: from BL0PR04MB6514.namprd04.prod.outlook.com
	([fe80::2dbb:7e01:f076:eca0]) by
	BL0PR04MB6514.namprd04.prod.outlook.com
	([fe80::2dbb:7e01:f076:eca0%9]) with mapi id 15.20.3721.024;
	Mon, 4 Jan 2021 12:47:11 +0000
From: Damien Le Moal <Damien.LeMoal@wdc.com>
To: SelvaKumar S <selvakuma.s1@samsung.com>, "linux-nvme@lists.infradead.org"
	<linux-nvme@lists.infradead.org>
Thread-Topic: [RFC PATCH v4 2/3] block: add simple copy support
Thread-Index: AQHW4ocZGQHbBBU/JES2xoCYHwM80A==
Date: Mon, 4 Jan 2021 12:47:11 +0000
Message-ID: <BL0PR04MB651402CFA75F72826AC8EE1CE7D20@BL0PR04MB6514.namprd04.prod.outlook.com>
References: <20210104104159.74236-1-selvakuma.s1@samsung.com>
	<CGME20210104104249epcas5p458d1b5c39b5acfad4e7786eca5dd5c49@epcas5p4.samsung.com>
	<20210104104159.74236-3-selvakuma.s1@samsung.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2400:2411:43c0:6000:4d2:96cc:b27d:4f9]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: a00fc8d3-18d2-4d26-fdcd-08d8b0aedafd
x-ms-traffictypediagnostic: BL0PR04MB4612:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BL0PR04MB4612C28EFF1470A6CBBA755BE7D20@BL0PR04MB4612.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:4714
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: MbOZiEO1wAR/IrJmIQH55XpV1fJ5yZIORDy5qo3uQXBtvL673Vi3zVAwHzqgJyWitReW/HrNi30V1pK3QiNCMnLvpPQP//eU2B9ug5QI140Lb30E9vkKEMCTStQ85BB3fNtPj+fRqIukZAKdy0R/g2sWWa92sgjJIKUt5muwZAf/cKcwuTN79NY7nLHsT/8fwPTOaFBkibOyxk5fRYdqC+zTfOsXB76C0x1CZGW9qb5e5JvL5M75BpQSwlvzUPvX0UHtzQAbFO+9FCrSEWWSrGmkX/C/z+xoEK4VWWCZlguvgEnrPf3uVFiDIb9rgoXOY2+NkUbQVn7TQui2femD8KHKf+rZCG3igj4Wbfh0djc79HD17t5Nw/6kJDUtQbtCu3Awi3Ln6SttH1dn/6EK1Q==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:BL0PR04MB6514.namprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(376002)(366004)(39860400002)(396003)(346002)(136003)(6506007)(33656002)(66946007)(66556008)(83380400001)(86362001)(53546011)(2906002)(66476007)(110136005)(4326008)(7416002)(478600001)(52536014)(5660300002)(54906003)(71200400001)(186003)(66446008)(9686003)(8936002)(30864003)(76116006)(8676002)(64756008)(91956017)(7696005)(316002)(55016002)(66574015)(579004)(559001);
	DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata: =?iso-8859-1?Q?p3YMngy2QtvS65DJ3nE45Qx6gkfBHFHdFKpqpzBVuNJ2XsUV/WlAv9Z4j5?=
	=?iso-8859-1?Q?jY4yNCYxygQEnU3iFblf5zz6n56vnYPnxtTu5rX9gYAdLKhT8HQnQ0N9Bv?=
	=?iso-8859-1?Q?kdI6WiAHF9AWaOHAWgwELwuvKH7+CNu5Tm2WpakE6D31WrtKz/SbHeTuVF?=
	=?iso-8859-1?Q?Z7NRnzDG7OQSIfnlfPpTbeJwSEd6OQIy5dUyh9FcztOS5dF5RsqxMimdig?=
	=?iso-8859-1?Q?YRZfFb3chc6LBK/RGVyqy9jKe9pL9GNBTWy7/3tMOGQySUTfTbt7OvqfeC?=
	=?iso-8859-1?Q?Q4b6Cf2etQuq9nRanPRtwgTpUhXd8r+qao9MnDOhPtkQsLzSwVbySXYYob?=
	=?iso-8859-1?Q?BDItphtiq4rRwXxWO2s0A5tX4aWiE4eYvoKfl82OAvmw4qPw3dF0kcX6ZT?=
	=?iso-8859-1?Q?mGO+f+KQjf0l9pvOfrulswCyzjbrjkeE699IwWnYpbbtdkNhRVYIRkIxIN?=
	=?iso-8859-1?Q?3pEjxkwGOkweVvgozVw8839dg4AxBlCIbaZJjk5/2Z2MtxGqGja5AfKhqP?=
	=?iso-8859-1?Q?oeNCRtLsKC+cBLxxAAdNve9JH7WahjAf03bDoWNsEbzsiAhPnWWRj0Brp4?=
	=?iso-8859-1?Q?eD2AO7m4D9hI6yPzfeM7g8a9m/GwHJYA7gpFj1YbH4sqV+jXmh/OLJ+H95?=
	=?iso-8859-1?Q?+BUDD8+edX7mU8q45YQcB6+yEvjUARIwoYI/M+i1N54E+1f996cQgqvd7a?=
	=?iso-8859-1?Q?WwkUsMrL/XJJAmwjOSa5784irSdyV2a1IBC2LDKl9l6cE9I06W9/mAof7y?=
	=?iso-8859-1?Q?zUQPtSR8tybbrnpIVHntei1Ngj/8IiIbcY020QAje7XzdZxzivveWIQxmC?=
	=?iso-8859-1?Q?lGtot7uGBkxX8Zs4KGq53Bi8ViJRMT8s8JdPlJ1G90CpPXT9DWk9V856SY?=
	=?iso-8859-1?Q?vttUErB1JXs9384/cQ/emMTNp/tbOz3x9SdRCJrrviBFX6/42xujt83j+7?=
	=?iso-8859-1?Q?qpjMktSgdRGTempcO3j+Bm6RkJHOdzz+MTubv5XS31mngF6bd6a3zQq+OV?=
	=?iso-8859-1?Q?ikyoPePdXm+6Yli2rZqtqI5CCG2TZyWkRFO4CEkifVe7o2hcCJz8Q5J7A9?=
	=?iso-8859-1?Q?YXVPpHzzubXyiVvWwxwncezqAp5FIpBVw6B8zQ+vjYhM?=
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR04MB6514.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a00fc8d3-18d2-4d26-fdcd-08d8b0aedafd
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jan 2021 12:47:11.6995 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: T2XIryl4kelYWH2ZfRsH2h+EwZm4i4kLbRd+0NRY4tD4ZMYA2vZ+ZmxlUk//qC47fCOpN6ga+kA/enfhpQM6hw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR04MB4612
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 104ClP1q013626
X-loop: dm-devel@redhat.com
Cc: "axboe@kernel.dk" <axboe@kernel.dk>,
	"selvajove@gmail.com" <selvajove@gmail.com>,
	"sagi@grimberg.me" <sagi@grimberg.me>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
	"snitzer@redhat.com" <snitzer@redhat.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"nj.shetty@samsung.com" <nj.shetty@samsung.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"mpatocka@redhat.com" <mpatocka@redhat.com>,
	"joshi.k@samsung.com" <joshi.k@samsung.com>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>,
	"kbusch@kernel.org" <kbusch@kernel.org>,
	"javier.gonz@samsung.com" <javier.gonz@samsung.com>,
	"hch@lst.de" <hch@lst.de>, "bvanassche@acm.org" <bvanassche@acm.org>
Subject: Re: [dm-devel] [RFC PATCH v4 2/3] block: add simple copy support
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On 2021/01/04 19:48, SelvaKumar S wrote:
> Add new BLKCOPY ioctl that offloads copying of one or more sources
> ranges to a destination in the device. Accepts copy_ranges that contains
> destination, no of sources and pointer to the array of source
> ranges. Each range_entry contains start and length of source
> ranges (in bytes).
>=20
> Introduce REQ_OP_COPY, a no-merge copy offload operation. Create
> bio with control information as payload and submit to the device.
> REQ_OP_COPY(19) is a write op and takes zone_write_lock when submitted
> to zoned device.
>=20
> If the device doesn't support copy or copy offload is disabled, then
> copy is emulated by allocating memory of total copy size. The source
> ranges are read into memory by chaining bio for each source ranges and
> submitting them async and the last bio waits for completion. After data
> is read, it is written to the destination.
>=20
> bio_map_kern() is used to allocate bio and add pages of copy buffer to
> bio. As bio->bi_private and bio->bi_end_io is needed for chaining the
> bio and over written, invalidate_kernel_vmap_range() for read is called
> in the caller.
>=20
> Introduce queue limits for simple copy and other helper functions.
> Add device limits as sysfs entries.
> =09- copy_offload
> =09- max_copy_sectors
> =09- max_copy_ranges_sectors
> =09- max_copy_nr_ranges
>=20
> copy_offload(=3D 0) is disabled by default.
> max_copy_sectors =3D 0 indicates the device doesn't support native copy.
>=20
> Native copy offload is not supported for stacked devices and is done via
> copy emulation.
>=20
> Signed-off-by: SelvaKumar S <selvakuma.s1@samsung.com>
> Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
> Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
> Signed-off-by: Javier Gonz=E1lez <javier.gonz@samsung.com>
> ---
>  block/blk-core.c          |  94 ++++++++++++++--
>  block/blk-lib.c           | 223 ++++++++++++++++++++++++++++++++++++++
>  block/blk-merge.c         |   2 +
>  block/blk-settings.c      |  10 ++
>  block/blk-sysfs.c         |  50 +++++++++
>  block/blk-zoned.c         |   1 +
>  block/bounce.c            |   1 +
>  block/ioctl.c             |  43 ++++++++
>  include/linux/bio.h       |   1 +
>  include/linux/blk_types.h |  15 +++
>  include/linux/blkdev.h    |  13 +++
>  include/uapi/linux/fs.h   |  13 +++
>  12 files changed, 458 insertions(+), 8 deletions(-)
>=20
> diff --git a/block/blk-core.c b/block/blk-core.c
> index 96e5fcd7f071..4a5cd3f53cd2 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -719,6 +719,17 @@ static noinline int should_fail_bio(struct bio *bio)
>  }
>  ALLOW_ERROR_INJECTION(should_fail_bio, ERRNO);
> =20
> +static inline int bio_check_copy_eod(struct bio *bio, sector_t start,
> +=09=09sector_t nr_sectors, sector_t maxsector)
> +{
> +=09if (nr_sectors && maxsector &&
> +=09    (nr_sectors > maxsector || start > maxsector - nr_sectors)) {
> +=09=09handle_bad_sector(bio, maxsector);
> +=09=09return -EIO;
> +=09}
> +=09return 0;
> +}
> +
>  /*
>   * Check whether this bio extends beyond the end of the device or partit=
ion.
>   * This may well happen - the kernel calls bread() without checking the =
size of
> @@ -737,6 +748,65 @@ static inline int bio_check_eod(struct bio *bio, sec=
tor_t maxsector)
>  =09return 0;
>  }
> =20
> +/*
> + * Check for copy limits and remap source ranges if needed.
> + */
> +static int blk_check_copy(struct bio *bio)
> +{
> +=09struct block_device *p =3D NULL;
> +=09struct request_queue *q =3D bio->bi_disk->queue;
> +=09struct blk_copy_payload *payload;
> +=09int i, maxsector, start_sect =3D 0, ret =3D -EIO;
> +=09unsigned short nr_range;
> +
> +=09rcu_read_lock();
> +
> +=09p =3D __disk_get_part(bio->bi_disk, bio->bi_partno);
> +=09if (unlikely(!p))
> +=09=09goto out;
> +=09if (unlikely(should_fail_request(p, bio->bi_iter.bi_size)))
> +=09=09goto out;
> +=09if (unlikely(bio_check_ro(bio, p)))
> +=09=09goto out;
> +
> +=09maxsector =3D  bdev_nr_sectors(p);
> +=09start_sect =3D p->bd_start_sect;
> +
> +=09payload =3D bio_data(bio);
> +=09nr_range =3D payload->copy_range;
> +
> +=09/* cannot handle copy crossing nr_ranges limit */
> +=09if (payload->copy_range > q->limits.max_copy_nr_ranges)
> +=09=09goto out;

If payload->copy_range indicates the number of ranges to be copied, you sho=
uld
name it payload->copy_nr_ranges.

> +
> +=09/* cannot handle copy more than copy limits */

Why ? You could loop... Similarly to discard, zone reset etc.

> +=09if (payload->copy_size > q->limits.max_copy_sectors)
> +=09=09goto out;

Shouldn't the list of source ranges give the total size to be copied ?
Otherwise, if payload->copy_size is user provided, you would need to check =
that
the sum of the source ranges actually is equal to copy_size, no ? That mean=
s
that dropping copy_size sound like the right thing to do here.

> +
> +=09/* check if copy length crosses eod */
> +=09if (unlikely(bio_check_copy_eod(bio, bio->bi_iter.bi_sector,
> +=09=09=09=09=09payload->copy_size, maxsector)))
> +=09=09goto out;
> +=09bio->bi_iter.bi_sector +=3D start_sect;
> +
> +=09for (i =3D 0; i < nr_range; i++) {
> +=09=09if (unlikely(bio_check_copy_eod(bio, payload->range[i].src,
> +=09=09=09=09=09payload->range[i].len, maxsector)))
> +=09=09=09goto out;
> +
> +=09=09/* single source range length limit */
> +=09=09if (payload->range[i].src > q->limits.max_copy_range_sectors)
> +=09=09=09goto out;
> +=09=09payload->range[i].src +=3D start_sect;
> +=09}
> +
> +=09bio->bi_partno =3D 0;
> +=09ret =3D 0;
> +out:
> +=09rcu_read_unlock();
> +=09return ret;
> +}
> +
>  /*
>   * Remap block n of partition p to block n+start(p) of the disk.
>   */
> @@ -826,14 +896,16 @@ static noinline_for_stack bool submit_bio_checks(st=
ruct bio *bio)
>  =09if (should_fail_bio(bio))
>  =09=09goto end_io;
> =20
> -=09if (bio->bi_partno) {
> -=09=09if (unlikely(blk_partition_remap(bio)))
> -=09=09=09goto end_io;
> -=09} else {
> -=09=09if (unlikely(bio_check_ro(bio, bio->bi_disk->part0)))
> -=09=09=09goto end_io;
> -=09=09if (unlikely(bio_check_eod(bio, get_capacity(bio->bi_disk))))
> -=09=09=09goto end_io;
> +=09if (likely(!op_is_copy(bio->bi_opf))) {
> +=09=09if (bio->bi_partno) {
> +=09=09=09if (unlikely(blk_partition_remap(bio)))
> +=09=09=09=09goto end_io;
> +=09=09} else {
> +=09=09=09if (unlikely(bio_check_ro(bio, bio->bi_disk->part0)))
> +=09=09=09=09goto end_io;
> +=09=09=09if (unlikely(bio_check_eod(bio, get_capacity(bio->bi_disk))))
> +=09=09=09=09goto end_io;
> +=09=09}
>  =09}
> =20
>  =09/*
> @@ -857,6 +929,12 @@ static noinline_for_stack bool submit_bio_checks(str=
uct bio *bio)
>  =09=09if (!blk_queue_discard(q))
>  =09=09=09goto not_supported;
>  =09=09break;
> +=09case REQ_OP_COPY:
> +=09=09if (!blk_queue_copy(q))
> +=09=09=09goto not_supported;

This check could be inside blk_check_copy(). In any case, since you added t=
he
read-write emulation, why are you even checking this ? That will prevent th=
e use
of the read-write emulation for devices that lack the simple copy support, =
no ?

> +=09=09if (unlikely(blk_check_copy(bio)))
> +=09=09=09goto end_io;
> +=09=09break;
>  =09case REQ_OP_SECURE_ERASE:
>  =09=09if (!blk_queue_secure_erase(q))
>  =09=09=09goto not_supported;
> diff --git a/block/blk-lib.c b/block/blk-lib.c
> index 752f9c722062..4c0f12e2ed7c 100644
> --- a/block/blk-lib.c
> +++ b/block/blk-lib.c
> @@ -150,6 +150,229 @@ int blkdev_issue_discard(struct block_device *bdev,=
 sector_t sector,
>  }
>  EXPORT_SYMBOL(blkdev_issue_discard);
> =20
> +int blk_copy_offload(struct block_device *bdev, struct blk_copy_payload =
*payload,
> +=09=09sector_t dest, gfp_t gfp_mask)
> +{
> +=09struct bio *bio;
> +=09int ret, total_size;
> +
> +=09bio =3D bio_alloc(gfp_mask, 1);
> +=09bio->bi_iter.bi_sector =3D dest;
> +=09bio->bi_opf =3D REQ_OP_COPY | REQ_NOMERGE;
> +=09bio_set_dev(bio, bdev);
> +
> +=09total_size =3D struct_size(payload, range, payload->copy_range);
> +=09ret =3D bio_add_page(bio, virt_to_page(payload), total_size,

How is payload allocated ? If it is a structure on-stack in the caller, I a=
m not
sure it would be wise to do an IO using the thread stack page...

> +=09=09=09=09=09   offset_in_page(payload));
> +=09if (ret !=3D total_size) {
> +=09=09ret =3D -ENOMEM;
> +=09=09bio_put(bio);
> +=09=09goto err;
> +=09}
> +
> +=09ret =3D submit_bio_wait(bio);
> +err:
> +=09bio_put(bio);
> +=09return ret;
> +
> +}
> +
> +int blk_read_to_buf(struct block_device *bdev, struct blk_copy_payload *=
payload,
> +=09=09gfp_t gfp_mask, void **buf_p)
> +{
> +=09struct request_queue *q =3D bdev_get_queue(bdev);
> +=09struct bio *bio, *parent =3D NULL;
> +=09void *buf =3D NULL;
> +=09bool is_vmalloc;
> +=09int i, nr_srcs, copy_len, ret, cur_size, t_len =3D 0;
> +
> +=09nr_srcs =3D payload->copy_range;
> +=09copy_len =3D payload->copy_size << SECTOR_SHIFT;
> +
> +=09buf =3D kvmalloc(copy_len, gfp_mask);
> +=09if (!buf)
> +=09=09return -ENOMEM;
> +=09is_vmalloc =3D is_vmalloc_addr(buf);
> +
> +=09for (i =3D 0; i < nr_srcs; i++) {
> +=09=09cur_size =3D payload->range[i].len << SECTOR_SHIFT;
> +
> +=09=09bio =3D bio_map_kern(q, buf + t_len, cur_size, gfp_mask);
> +=09=09if (IS_ERR(bio)) {
> +=09=09=09ret =3D PTR_ERR(bio);
> +=09=09=09goto out;
> +=09=09}
> +
> +=09=09bio->bi_iter.bi_sector =3D payload->range[i].src;
> +=09=09bio->bi_opf =3D REQ_OP_READ;
> +=09=09bio_set_dev(bio, bdev);
> +=09=09bio->bi_end_io =3D NULL;
> +=09=09bio->bi_private =3D NULL;
> +
> +=09=09if (parent) {
> +=09=09=09bio_chain(parent, bio);
> +=09=09=09submit_bio(parent);
> +=09=09}
> +
> +=09=09parent =3D bio;
> +=09=09t_len +=3D cur_size;
> +=09}
> +
> +=09ret =3D submit_bio_wait(bio);
> +=09bio_put(bio);
> +=09if (is_vmalloc)
> +=09=09invalidate_kernel_vmap_range(buf, copy_len);
> +=09if (ret)
> +=09=09goto out;
> +
> +=09*buf_p =3D buf;
> +=09return 0;
> +out:
> +=09kvfree(buf);
> +=09return ret;
> +}
> +
> +int blk_write_from_buf(struct block_device *bdev, void *buf, sector_t de=
st,
> +=09=09int copy_len, gfp_t gfp_mask)
> +{
> +=09struct request_queue *q =3D bdev_get_queue(bdev);
> +=09struct bio *bio;
> +=09int ret;
> +
> +=09bio =3D bio_map_kern(q, buf, copy_len, gfp_mask);
> +=09if (IS_ERR(bio)) {
> +=09=09ret =3D PTR_ERR(bio);
> +=09=09goto out;
> +=09}
> +=09bio_set_dev(bio, bdev);
> +=09bio->bi_opf =3D REQ_OP_WRITE;
> +=09bio->bi_iter.bi_sector =3D dest;
> +
> +=09bio->bi_end_io =3D NULL;
> +=09ret =3D submit_bio_wait(bio);
> +=09bio_put(bio);
> +out:
> +=09return ret;
> +}
> +
> +int blk_prepare_payload(struct block_device *bdev, int nr_srcs, struct r=
ange_entry *rlist,
> +=09=09gfp_t gfp_mask, struct blk_copy_payload **payload_p)
> +{
> +
> +=09struct request_queue *q =3D bdev_get_queue(bdev);
> +=09struct blk_copy_payload *payload;
> +=09sector_t bs_mask;
> +=09sector_t src_sects, len =3D 0, total_len =3D 0;
> +=09int i, ret, total_size;
> +
> +=09if (!q)
> +=09=09return -ENXIO;
> +
> +=09if (!nr_srcs)
> +=09=09return -EINVAL;
> +
> +=09if (bdev_read_only(bdev))
> +=09=09return -EPERM;
> +
> +=09bs_mask =3D (bdev_logical_block_size(bdev) >> 9) - 1;
> +
> +=09total_size =3D struct_size(payload, range, nr_srcs);
> +=09payload =3D kmalloc(total_size, gfp_mask);
> +=09if (!payload)
> +=09=09return -ENOMEM;

OK. So this is what goes into the bio. The function blk_copy_offload() assu=
mes
this is at most one page, so total_size <=3D PAGE_SIZE. Where is that check=
ed ?

> +
> +=09for (i =3D 0; i < nr_srcs; i++) {
> +=09=09/*  copy payload provided are in bytes */
> +=09=09src_sects =3D rlist[i].src;
> +=09=09if (src_sects & bs_mask) {
> +=09=09=09ret =3D  -EINVAL;
> +=09=09=09goto err;
> +=09=09}
> +=09=09src_sects =3D src_sects >> SECTOR_SHIFT;
> +
> +=09=09if (len & bs_mask) {
> +=09=09=09ret =3D -EINVAL;
> +=09=09=09goto err;
> +=09=09}
> +
> +=09=09len =3D rlist[i].len >> SECTOR_SHIFT;
> +
> +=09=09total_len +=3D len;
> +
> +=09=09WARN_ON_ONCE((src_sects << 9) > UINT_MAX);
> +
> +=09=09payload->range[i].src =3D src_sects;
> +=09=09payload->range[i].len =3D len;
> +=09}
> +
> +=09/* storing # of source ranges */
> +=09payload->copy_range =3D i;
> +=09/* storing copy len so far */
> +=09payload->copy_size =3D total_len;

The comments here make the code ugly. Rename the variables and structure fi=
elds
to have something self explanatory.

> +
> +=09*payload_p =3D payload;
> +=09return 0;
> +err:
> +=09kfree(payload);
> +=09return ret;
> +}
> +
> +/**
> + * blkdev_issue_copy - queue a copy
> + * @bdev:       source block device
> + * @nr_srcs:=09number of source ranges to copy
> + * @rlist:=09array of source ranges (in bytes)
> + * @dest_bdev:=09destination block device
> + * @dest:=09destination (in bytes)
> + * @gfp_mask:   memory allocation flags (for bio_alloc)
> + *
> + * Description:
> + *=09Copy array of source ranges from source block device to
> + *=09destination block devcie.
> + */
> +
> +
> +int blkdev_issue_copy(struct block_device *bdev, int nr_srcs,
> +=09=09struct range_entry *src_rlist, struct block_device *dest_bdev,
> +=09=09sector_t dest, gfp_t gfp_mask)
> +{
> +=09struct request_queue *q =3D bdev_get_queue(bdev);
> +=09struct blk_copy_payload *payload;
> +=09sector_t bs_mask, dest_sect;
> +=09void *buf =3D NULL;
> +=09int ret;
> +
> +=09ret =3D blk_prepare_payload(bdev, nr_srcs, src_rlist, gfp_mask, &payl=
oad);
> +=09if (ret)
> +=09=09return ret;
> +
> +=09bs_mask =3D (bdev_logical_block_size(dest_bdev) >> 9) - 1;
> +=09if (dest & bs_mask) {
> +=09=09return -EINVAL;
> +=09=09goto out;
> +=09}
> +=09dest_sect =3D dest >> SECTOR_SHIFT;

dest should already be a 512B sector as all block layer functions interface=
 use
this unit. What is this doing ?

> +
> +=09if (bdev =3D=3D dest_bdev && q->limits.copy_offload) {
> +=09=09ret =3D blk_copy_offload(bdev, payload, dest_sect, gfp_mask);
> +=09=09if (ret)
> +=09=09=09goto out;
> +=09} else {
> +=09=09ret =3D blk_read_to_buf(bdev, payload, gfp_mask, &buf);
> +=09=09if (ret)
> +=09=09=09goto out;
> +=09=09ret =3D blk_write_from_buf(dest_bdev, buf, dest_sect,
> +=09=09=09=09payload->copy_size << SECTOR_SHIFT, gfp_mask);

Arg... This is really not pretty. At the very least, this should all be in =
a
blk_copy_emulate() helper or something named like that.

My worry though is that this likely slow for large copies, not to mention t=
hat
buf is likely to fail to allocate for large copy cases. As commented previo=
usly,
dm-kcopyd already does such copy well, with a read-write streaming pipeline=
 and
zone support too for the write side. This should really be reused, at least
partly, instead of re-implementing this read-write here.

> +=09}
> +
> +=09if (buf)
> +=09=09kvfree(buf);
> +out:
> +=09kvfree(payload);
> +=09return ret;
> +}
> +EXPORT_SYMBOL(blkdev_issue_copy);
> +
>  /**
>   * __blkdev_issue_write_same - generate number of bios with same page
>   * @bdev:=09target blockdev
> diff --git a/block/blk-merge.c b/block/blk-merge.c
> index 808768f6b174..4e04f24e13c1 100644
> --- a/block/blk-merge.c
> +++ b/block/blk-merge.c
> @@ -309,6 +309,8 @@ void __blk_queue_split(struct bio **bio, unsigned int=
 *nr_segs)
>  =09struct bio *split =3D NULL;
> =20
>  =09switch (bio_op(*bio)) {
> +=09case REQ_OP_COPY:
> +=09=09=09break;
>  =09case REQ_OP_DISCARD:
>  =09case REQ_OP_SECURE_ERASE:
>  =09=09split =3D blk_bio_discard_split(q, *bio, &q->bio_split, nr_segs);
> diff --git a/block/blk-settings.c b/block/blk-settings.c
> index 43990b1d148b..93c15ba45a69 100644
> --- a/block/blk-settings.c
> +++ b/block/blk-settings.c
> @@ -60,6 +60,10 @@ void blk_set_default_limits(struct queue_limits *lim)
>  =09lim->io_opt =3D 0;
>  =09lim->misaligned =3D 0;
>  =09lim->zoned =3D BLK_ZONED_NONE;
> +=09lim->copy_offload =3D 0;
> +=09lim->max_copy_sectors =3D 0;
> +=09lim->max_copy_nr_ranges =3D 0;
> +=09lim->max_copy_range_sectors =3D 0;
>  }
>  EXPORT_SYMBOL(blk_set_default_limits);
> =20
> @@ -565,6 +569,12 @@ int blk_stack_limits(struct queue_limits *t, struct =
queue_limits *b,
>  =09if (b->chunk_sectors)
>  =09=09t->chunk_sectors =3D gcd(t->chunk_sectors, b->chunk_sectors);
> =20
> +=09/* simple copy not supported in stacked devices */
> +=09t->copy_offload =3D 0;
> +=09t->max_copy_sectors =3D 0;
> +=09t->max_copy_range_sectors =3D 0;
> +=09t->max_copy_nr_ranges =3D 0;
> +
>  =09/* Physical block size a multiple of the logical block size? */
>  =09if (t->physical_block_size & (t->logical_block_size - 1)) {
>  =09=09t->physical_block_size =3D t->logical_block_size;
> diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
> index b513f1683af0..51b35a8311d9 100644
> --- a/block/blk-sysfs.c
> +++ b/block/blk-sysfs.c
> @@ -166,6 +166,47 @@ static ssize_t queue_discard_granularity_show(struct=
 request_queue *q, char *pag
>  =09return queue_var_show(q->limits.discard_granularity, page);
>  }
> =20
> +static ssize_t queue_copy_offload_show(struct request_queue *q, char *pa=
ge)
> +{
> +=09return queue_var_show(q->limits.copy_offload, page);
> +}
> +
> +static ssize_t queue_copy_offload_store(struct request_queue *q,
> +=09=09=09=09       const char *page, size_t count)
> +{
> +=09unsigned long copy_offload;
> +=09ssize_t ret =3D queue_var_store(&copy_offload, page, count);
> +
> +=09if (ret < 0)
> +=09=09return ret;
> +
> +=09if (copy_offload < 0 || copy_offload > 1)

err... "copy_offload !=3D 1" ?

> +=09=09return -EINVAL;
> +
> +=09if (q->limits.max_copy_sectors =3D=3D 0 && copy_offload =3D=3D 1)
> +=09=09return -EINVAL;
> +
> +=09q->limits.copy_offload =3D copy_offload;
> +=09return ret;
> +}
> +
> +static ssize_t queue_max_copy_sectors_show(struct request_queue *q, char=
 *page)
> +{
> +=09return queue_var_show(q->limits.max_copy_sectors, page);
> +}
> +
> +static ssize_t queue_max_copy_range_sectors_show(struct request_queue *q=
,
> +=09=09char *page)
> +{
> +=09return queue_var_show(q->limits.max_copy_range_sectors, page);
> +}
> +
> +static ssize_t queue_max_copy_nr_ranges_show(struct request_queue *q,
> +=09=09char *page)
> +{
> +=09return queue_var_show(q->limits.max_copy_nr_ranges, page);
> +}
> +
>  static ssize_t queue_discard_max_hw_show(struct request_queue *q, char *=
page)
>  {
> =20
> @@ -591,6 +632,11 @@ QUEUE_RO_ENTRY(queue_nr_zones, "nr_zones");
>  QUEUE_RO_ENTRY(queue_max_open_zones, "max_open_zones");
>  QUEUE_RO_ENTRY(queue_max_active_zones, "max_active_zones");
> =20
> +QUEUE_RW_ENTRY(queue_copy_offload, "copy_offload");
> +QUEUE_RO_ENTRY(queue_max_copy_sectors, "max_copy_sectors");
> +QUEUE_RO_ENTRY(queue_max_copy_range_sectors, "max_copy_range_sectors");
> +QUEUE_RO_ENTRY(queue_max_copy_nr_ranges, "max_copy_nr_ranges");
> +
>  QUEUE_RW_ENTRY(queue_nomerges, "nomerges");
>  QUEUE_RW_ENTRY(queue_rq_affinity, "rq_affinity");
>  QUEUE_RW_ENTRY(queue_poll, "io_poll");
> @@ -636,6 +682,10 @@ static struct attribute *queue_attrs[] =3D {
>  =09&queue_discard_max_entry.attr,
>  =09&queue_discard_max_hw_entry.attr,
>  =09&queue_discard_zeroes_data_entry.attr,
> +=09&queue_copy_offload_entry.attr,
> +=09&queue_max_copy_sectors_entry.attr,
> +=09&queue_max_copy_range_sectors_entry.attr,
> +=09&queue_max_copy_nr_ranges_entry.attr,
>  =09&queue_write_same_max_entry.attr,
>  =09&queue_write_zeroes_max_entry.attr,
>  =09&queue_zone_append_max_entry.attr,
> diff --git a/block/blk-zoned.c b/block/blk-zoned.c
> index 7a68b6e4300c..02069178d51e 100644
> --- a/block/blk-zoned.c
> +++ b/block/blk-zoned.c
> @@ -75,6 +75,7 @@ bool blk_req_needs_zone_write_lock(struct request *rq)
>  =09case REQ_OP_WRITE_ZEROES:
>  =09case REQ_OP_WRITE_SAME:
>  =09case REQ_OP_WRITE:
> +=09case REQ_OP_COPY:
>  =09=09return blk_rq_zone_is_seq(rq);
>  =09default:
>  =09=09return false;
> diff --git a/block/bounce.c b/block/bounce.c
> index d3f51acd6e3b..5e052afe8691 100644
> --- a/block/bounce.c
> +++ b/block/bounce.c
> @@ -254,6 +254,7 @@ static struct bio *bounce_clone_bio(struct bio *bio_s=
rc, gfp_t gfp_mask,
>  =09bio->bi_iter.bi_size=09=3D bio_src->bi_iter.bi_size;
> =20
>  =09switch (bio_op(bio)) {
> +=09case REQ_OP_COPY:
>  =09case REQ_OP_DISCARD:
>  =09case REQ_OP_SECURE_ERASE:
>  =09case REQ_OP_WRITE_ZEROES:
> diff --git a/block/ioctl.c b/block/ioctl.c
> index d61d652078f4..d50b6abe2883 100644
> --- a/block/ioctl.c
> +++ b/block/ioctl.c
> @@ -133,6 +133,47 @@ static int blk_ioctl_discard(struct block_device *bd=
ev, fmode_t mode,
>  =09=09=09=09    GFP_KERNEL, flags);
>  }
> =20
> +static int blk_ioctl_copy(struct block_device *bdev, fmode_t mode,
> +=09=09unsigned long arg)
> +{
> +=09struct copy_range crange;
> +=09struct range_entry *rlist;
> +=09struct request_queue *q =3D bdev_get_queue(bdev);
> +=09sector_t dest;
> +=09int ret;
> +
> +=09if (!(mode & FMODE_WRITE))
> +=09=09return -EBADF;
> +
> +=09if (!blk_queue_copy(q))
> +=09=09return -EOPNOTSUPP;

But you added the read-write emulation. So what is the point here ? This io=
ctl
should work for any device, with or without simple copy support. Did you te=
st that ?

> +
> +=09if (copy_from_user(&crange, (void __user *)arg, sizeof(crange)))
> +=09=09return -EFAULT;
> +
> +=09if (crange.dest & ((1 << SECTOR_SHIFT) - 1))
> +=09=09return -EFAULT;
> +=09dest =3D crange.dest;
> +
> +=09rlist =3D kmalloc_array(crange.nr_range, sizeof(*rlist),
> +=09=09=09GFP_KERNEL);
> +

Unnecessary blank line here.

> +=09if (!rlist)
> +=09=09return -ENOMEM;
> +
> +=09if (copy_from_user(rlist, (void __user *)crange.range_list,
> +=09=09=09=09sizeof(*rlist) * crange.nr_range)) {
> +=09=09ret =3D -EFAULT;
> +=09=09goto out;
> +=09}
> +
> +=09ret =3D blkdev_issue_copy(bdev, crange.nr_range, rlist, bdev, dest,
> +=09=09=09GFP_KERNEL);
> +out:
> +=09kfree(rlist);
> +=09return ret;
> +}
> +
>  static int blk_ioctl_zeroout(struct block_device *bdev, fmode_t mode,
>  =09=09unsigned long arg)
>  {
> @@ -458,6 +499,8 @@ static int blkdev_common_ioctl(struct block_device *b=
dev, fmode_t mode,
>  =09case BLKSECDISCARD:
>  =09=09return blk_ioctl_discard(bdev, mode, arg,
>  =09=09=09=09BLKDEV_DISCARD_SECURE);
> +=09case BLKCOPY:
> +=09=09return blk_ioctl_copy(bdev, mode, arg);
>  =09case BLKZEROOUT:
>  =09=09return blk_ioctl_zeroout(bdev, mode, arg);
>  =09case BLKREPORTZONE:
> diff --git a/include/linux/bio.h b/include/linux/bio.h
> index 1edda614f7ce..164313bdfb35 100644
> --- a/include/linux/bio.h
> +++ b/include/linux/bio.h
> @@ -71,6 +71,7 @@ static inline bool bio_has_data(struct bio *bio)
>  static inline bool bio_no_advance_iter(const struct bio *bio)
>  {
>  =09return bio_op(bio) =3D=3D REQ_OP_DISCARD ||
> +=09       bio_op(bio) =3D=3D REQ_OP_COPY ||
>  =09       bio_op(bio) =3D=3D REQ_OP_SECURE_ERASE ||
>  =09       bio_op(bio) =3D=3D REQ_OP_WRITE_SAME ||
>  =09       bio_op(bio) =3D=3D REQ_OP_WRITE_ZEROES;
> diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
> index 866f74261b3b..d4d11e9ff814 100644
> --- a/include/linux/blk_types.h
> +++ b/include/linux/blk_types.h
> @@ -380,6 +380,8 @@ enum req_opf {
>  =09REQ_OP_ZONE_RESET=09=3D 15,
>  =09/* reset all the zone present on the device */
>  =09REQ_OP_ZONE_RESET_ALL=09=3D 17,
> +=09/* copy ranges within device */
> +=09REQ_OP_COPY=09=09=3D 19,
> =20
>  =09/* SCSI passthrough using struct scsi_request */
>  =09REQ_OP_SCSI_IN=09=09=3D 32,
> @@ -506,6 +508,11 @@ static inline bool op_is_discard(unsigned int op)
>  =09return (op & REQ_OP_MASK) =3D=3D REQ_OP_DISCARD;
>  }
> =20
> +static inline bool op_is_copy(unsigned int op)
> +{
> +=09return (op & REQ_OP_MASK) =3D=3D REQ_OP_COPY;
> +}
> +
>  /*
>   * Check if a bio or request operation is a zone management operation, w=
ith
>   * the exception of REQ_OP_ZONE_RESET_ALL which is treated as a special =
case
> @@ -565,4 +572,12 @@ struct blk_rq_stat {
>  =09u64 batch;
>  };
> =20
> +struct blk_copy_payload {
> +=09sector_t=09dest;
> +=09int=09=09copy_range;
> +=09int=09=09copy_size;
> +=09int=09=09err;
> +=09struct=09range_entry=09range[];
> +};
> +
>  #endif /* __LINUX_BLK_TYPES_H */
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index 81f9e7bec16c..4c7e861e57e4 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -340,10 +340,14 @@ struct queue_limits {
>  =09unsigned int=09=09max_zone_append_sectors;
>  =09unsigned int=09=09discard_granularity;
>  =09unsigned int=09=09discard_alignment;
> +=09unsigned int=09=09copy_offload;
> +=09unsigned int=09=09max_copy_sectors;
> =20
>  =09unsigned short=09=09max_segments;
>  =09unsigned short=09=09max_integrity_segments;
>  =09unsigned short=09=09max_discard_segments;
> +=09unsigned short=09=09max_copy_range_sectors;
> +=09unsigned short=09=09max_copy_nr_ranges;
> =20
>  =09unsigned char=09=09misaligned;
>  =09unsigned char=09=09discard_misaligned;
> @@ -625,6 +629,7 @@ struct request_queue {
>  #define QUEUE_FLAG_RQ_ALLOC_TIME 27=09/* record rq->alloc_time_ns */
>  #define QUEUE_FLAG_HCTX_ACTIVE=0928=09/* at least one blk-mq hctx is act=
ive */
>  #define QUEUE_FLAG_NOWAIT       29=09/* device supports NOWAIT */
> +#define QUEUE_FLAG_COPY=09=0930=09/* supports copy */

I think this should be called QUEUE_FLAG_SIMPLE_COPY to indicate more preci=
sely
the type of copy supported. SCSI XCOPY is more advanced...

> =20
>  #define QUEUE_FLAG_MQ_DEFAULT=09((1 << QUEUE_FLAG_IO_STAT) |=09=09\
>  =09=09=09=09 (1 << QUEUE_FLAG_SAME_COMP) |=09=09\
> @@ -647,6 +652,7 @@ bool blk_queue_flag_test_and_set(unsigned int flag, s=
truct request_queue *q);
>  #define blk_queue_io_stat(q)=09test_bit(QUEUE_FLAG_IO_STAT, &(q)->queue_=
flags)
>  #define blk_queue_add_random(q)=09test_bit(QUEUE_FLAG_ADD_RANDOM, &(q)->=
queue_flags)
>  #define blk_queue_discard(q)=09test_bit(QUEUE_FLAG_DISCARD, &(q)->queue_=
flags)
> +#define blk_queue_copy(q)=09test_bit(QUEUE_FLAG_COPY, &(q)->queue_flags)
>  #define blk_queue_zone_resetall(q)=09\
>  =09test_bit(QUEUE_FLAG_ZONE_RESETALL, &(q)->queue_flags)
>  #define blk_queue_secure_erase(q) \
> @@ -1061,6 +1067,9 @@ static inline unsigned int blk_queue_get_max_sector=
s(struct request_queue *q,
>  =09=09return min(q->limits.max_discard_sectors,
>  =09=09=09   UINT_MAX >> SECTOR_SHIFT);
> =20
> +=09if (unlikely(op =3D=3D REQ_OP_COPY))
> +=09=09return q->limits.max_copy_sectors;
> +
>  =09if (unlikely(op =3D=3D REQ_OP_WRITE_SAME))
>  =09=09return q->limits.max_write_same_sectors;
> =20
> @@ -1335,6 +1344,10 @@ extern int __blkdev_issue_discard(struct block_dev=
ice *bdev, sector_t sector,
>  =09=09sector_t nr_sects, gfp_t gfp_mask, int flags,
>  =09=09struct bio **biop);
> =20
> +extern int blkdev_issue_copy(struct block_device *bdev, int nr_srcs,
> +=09=09struct range_entry *src_rlist, struct block_device *dest_bdev,
> +=09=09sector_t dest, gfp_t gfp_mask);
> +
>  #define BLKDEV_ZERO_NOUNMAP=09(1 << 0)  /* do not free blocks */
>  #define BLKDEV_ZERO_NOFALLBACK=09(1 << 1)  /* don't write explicit zeroe=
s */
> =20
> diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
> index f44eb0a04afd..5cadb176317a 100644
> --- a/include/uapi/linux/fs.h
> +++ b/include/uapi/linux/fs.h
> @@ -64,6 +64,18 @@ struct fstrim_range {
>  =09__u64 minlen;
>  };
> =20
> +struct range_entry {
> +=09__u64 src;
> +=09__u64 len;
> +};
> +
> +struct copy_range {
> +=09__u64 dest;
> +=09__u64 nr_range;
> +=09__u64 range_list;
> +=09__u64 rsvd;
> +};
> +
>  /* extent-same (dedupe) ioctls; these MUST match the btrfs ioctl definit=
ions */
>  #define FILE_DEDUPE_RANGE_SAME=09=090
>  #define FILE_DEDUPE_RANGE_DIFFERS=091
> @@ -184,6 +196,7 @@ struct fsxattr {
>  #define BLKSECDISCARD _IO(0x12,125)
>  #define BLKROTATIONAL _IO(0x12,126)
>  #define BLKZEROOUT _IO(0x12,127)
> +#define BLKCOPY _IOWR(0x12, 128, struct copy_range)
>  /*
>   * A jump here: 130-131 are reserved for zoned block devices
>   * (see uapi/linux/blkzoned.h)
>=20


--=20
Damien Le Moal
Western Digital Research



--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

