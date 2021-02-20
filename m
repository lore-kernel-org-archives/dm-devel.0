Return-Path: <SRS0=bZhs=HW=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85323C433E0
	for <dm-devel@archiver.kernel.org>; Sat, 20 Feb 2021 04:59:48 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 0D5BB64EE0
	for <dm-devel@archiver.kernel.org>; Sat, 20 Feb 2021 04:59:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0D5BB64EE0
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-240-3XXL7-i1PCKPFFF40jFhvg-1; Fri, 19 Feb 2021 23:59:44 -0500
X-MC-Unique: 3XXL7-i1PCKPFFF40jFhvg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E06E480197A;
	Sat, 20 Feb 2021 04:59:39 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B68B710016FE;
	Sat, 20 Feb 2021 04:59:38 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 93EC418095CB;
	Sat, 20 Feb 2021 04:59:18 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 11K4xHtk002345 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 19 Feb 2021 23:59:17 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 0D67E202A446; Sat, 20 Feb 2021 04:59:17 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 061BE2026D46
	for <dm-devel@redhat.com>; Sat, 20 Feb 2021 04:59:14 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D279E9291A4
	for <dm-devel@redhat.com>; Sat, 20 Feb 2021 04:59:14 +0000 (UTC)
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-23-YfjUc3XlMxyacoG-bwV_-g-1; Fri, 19 Feb 2021 23:59:10 -0500
X-MC-Unique: YfjUc3XlMxyacoG-bwV_-g-1
IronPort-SDR: +ZI/tnOzTXSFCLXHOrRkszhBjnLedQ9YD1Xh6WroEjhpUqpIfdyTTjvfzd/WcQ3OeK+nRxwK6J
	U5R8K9s6OTpBDBV4nMaJMxNmVQE+D8FmdL425RwdkvNZ9RYfp4EspIFHI3zYA+YefwIlrvTlbD
	Zq460g+dWfpnnOxa3kAf2IYqdvMKiPlLcFf3ufB9qwDeS2NljhPcU0k1f3Pw34onYG6XFHg2Z8
	cR8fqCwwbWtfZZ5wlgNO750Ys3Y/dgOHHAn/ZS+KUmHN3h0oO/7xmiNlWS4qk6SFRP8YKqjWxo
	sq8=
X-IronPort-AV: E=Sophos;i="5.81,192,1610380800"; d="scan'208";a="160387174"
Received: from mail-bn8nam11lp2177.outbound.protection.outlook.com (HELO
	NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.177])
	by ob1.hgst.iphmx.com with ESMTP; 20 Feb 2021 12:59:07 +0800
Received: from BL0PR04MB6514.namprd04.prod.outlook.com (2603:10b6:208:1ca::23)
	by BL0PR04MB6596.namprd04.prod.outlook.com (2603:10b6:208:1cf::17)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25;
	Sat, 20 Feb 2021 04:59:05 +0000
Received: from BL0PR04MB6514.namprd04.prod.outlook.com
	([fe80::b880:19d5:c7fe:329d]) by
	BL0PR04MB6514.namprd04.prod.outlook.com
	([fe80::b880:19d5:c7fe:329d%7]) with mapi id 15.20.3846.042;
	Sat, 20 Feb 2021 04:59:05 +0000
From: Damien Le Moal <Damien.LeMoal@wdc.com>
To: SelvaKumar S <selvakuma.s1@samsung.com>, "linux-nvme@lists.infradead.org"
	<linux-nvme@lists.infradead.org>
Thread-Topic: [RFC PATCH v5 2/4] block: add simple copy support
Thread-Index: AQHXByxWhY0q9dGq/EW9B8B+rRJ+Hw==
Date: Sat, 20 Feb 2021 04:59:05 +0000
Message-ID: <BL0PR04MB6514EA91680D33A5890ECE16E7839@BL0PR04MB6514.namprd04.prod.outlook.com>
References: <20210219124517.79359-1-selvakuma.s1@samsung.com>
	<CGME20210219124603epcas5p33add0f2c1781b2a4d71bf30c9e1ac647@epcas5p3.samsung.com>
	<20210219124517.79359-3-selvakuma.s1@samsung.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2400:2411:43c0:6000:8564:8d20:cd78:c10b]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: b5babe2b-4586-438c-e8bf-08d8d55c3f90
x-ms-traffictypediagnostic: BL0PR04MB6596:
x-microsoft-antispam-prvs: <BL0PR04MB659656E0EF6A1CDE80666073E7839@BL0PR04MB6596.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:212
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: xJGWCLj4DiBFG5CDe5afglJGPqVYJXQjAupO4WfrrrGnz2pSywIfv9mTUfj72QExxlITqjWEVc0hcXgBblc3+WEFIdYjmOq7j99Mg+D/c6EHhMmbguCQnANazKDM+qddpHztk6/gIgsBJl7c9Nuf7LXnSvGbyou2BMISTQ5Ocl1LwVIqJiEi74p7YgUUGCuApHNtmIT9WF+1IDrjTHJxFfxavw2CU9zW3VZ+sn4emYR2VgUGTNkdvXvolVctJynez9PGXweyVMJ7SzIxpatv4eol4AlArpMlQLU/Z+qijCHnMRxqdOi2jFLZsMGNur+FJwjAS3tsY4NlrCOOPtTiJ0hVB0mCKoBDiTffV91vakzLzFk001yOUNrGABUi42m66UjBup6GUSkOEUUwq9+HIa8zZhdbDbhbIhaBvz0kEXOE3FrRUZpkVwv+SRZC5hOuqDW5jjO1bhjJ84s3m9RfTMdYKVBRY6zn0iCrfim9ysztDJfg3BWRPExd3PFDaYUYZd2QgLgKXq2CMBNaTZZYsg==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:BL0PR04MB6514.namprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(366004)(396003)(346002)(136003)(39860400002)(376002)(66556008)(52536014)(4326008)(478600001)(55016002)(66446008)(186003)(8676002)(64756008)(66476007)(86362001)(33656002)(5660300002)(66946007)(76116006)(54906003)(30864003)(7416002)(71200400001)(7696005)(6506007)(8936002)(110136005)(66574015)(9686003)(316002)(53546011)(83380400001)(91956017)(2906002)(579004)(559001);
	DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata: =?iso-8859-1?Q?t3MoaFVTto4ASbrrzVA5RNp8PswKiwY7TlkBpTLxLYXQDOLnK75M+YR8nY?=
	=?iso-8859-1?Q?SzmFh8AibEW+Sfyq0VM49DTM469OGqpLuwrGRWeFsRZEt0/kwG50mvmn4t?=
	=?iso-8859-1?Q?Mni6s+4RHkZvbBy/QnfOT8n35sMCzivmegno27EUGLuKzkZjcAyMZlTY3o?=
	=?iso-8859-1?Q?BE9ieTxqtM9QTraZ4o0UzEomFsEJ0mBG1hgcoyD+p4mHTlFc9zEM8xxL1w?=
	=?iso-8859-1?Q?/SDv5xdL4+TUeXdf5PUySi3licFImUbqQk+hl22gWXpQIkAhVYaxksA4+C?=
	=?iso-8859-1?Q?aBx0objpgqEgjCSZ0/NjVizeS376QNpaBUSZG4pfE4TMw8KktXG3bcJwp7?=
	=?iso-8859-1?Q?rVyLCyVUv3w7wGO3aAU8jxeAc17a5h1XUIOmNwkIaLu38FC5B7sl9p1D/Z?=
	=?iso-8859-1?Q?COqUWzUEH6h+HZ01oUmVFO92Z1v/l5tef9HmbkrdhxQc2AI8p2i1/VQa9G?=
	=?iso-8859-1?Q?1J/BevCvksxnq8EIwb8nnULJ7ouwe8EN9OtysFRzurjEW0HEX3u+oTxYsO?=
	=?iso-8859-1?Q?XVf8reU5EYyoKXJUIDUfZILoDlemBplZldcFu85DS7xOcjMiZehs8WmdIX?=
	=?iso-8859-1?Q?q3JL5rsKB1vX/hi+8Uxqu4/SEAIdjupI6g3un6RAF9Mr2zDF0nQ/H8yNxx?=
	=?iso-8859-1?Q?VsfqH96+xP36qKbHIqb1hCaNRw4P8Lgnc/N7AFk1pBMaKEpNGIYXmIAgxK?=
	=?iso-8859-1?Q?fW5gcFxHFTTzYCoZfV7Rf+2I6J1yE1R6jgZ+gfQYnzERwSQHOJWIAR4Z65?=
	=?iso-8859-1?Q?Rpt3wBAHxXAThdoa7NCIYQIyu047gyVOsd+eeSw9j4xKoGsWiQ5uRAG5vZ?=
	=?iso-8859-1?Q?dKIrbQQk2bYVPpPw0yklXtnCgUDeZRS9kh7GTK6fiDiii5Nj4fg99Rq+c6?=
	=?iso-8859-1?Q?n/IR3wKh9kfGyMjcEoWVC9q8ZIoyw95AxAzbkIJdj90xs/PqIBh7fNdQEp?=
	=?iso-8859-1?Q?/Zn0k931pc1ekv0i9fYPqteEHa38DOCq34wW6rO8QW2eJ2BDQf30Jrq8HS?=
	=?iso-8859-1?Q?Qyp59SWtXuwYn2FWvkkNvjcMlvZWCMWUHJBXQmTri741/JwxJb2WRZwM7p?=
	=?iso-8859-1?Q?gn0yt2xq7FUwUloMzqnPi+3MVPjT0Z2STfkwzVdv2w2ecWM88O3CFqRaU+?=
	=?iso-8859-1?Q?slIbTW9mVTnxVQsPqVfpZJOr3eF4IC6sCBKEfiTUuJV7RVZ4UM8d+XyUpb?=
	=?iso-8859-1?Q?PlP6DrLUC+u5W3tobVUjNPsk0NYKSXmkxXVkJg0Oqbgb8f5pSXyuuZyylf?=
	=?iso-8859-1?Q?ou1LEzqYqodiu8VIoRwt6urAJfzSgbxUC1VkfnGctU3c9gJZ8jIcXesiXY?=
	=?iso-8859-1?Q?jbGLnV2hsAmihysCopE4OkJi+5qMbDyFYfEV9OJYhb9Or5jQZDN+wK9tTv?=
	=?iso-8859-1?Q?idkJpGN/nDxi7SuDiRBHlc8zr62LXMeW0L+7aat1LbImkcBG75eIdBj1CS?=
	=?iso-8859-1?Q?AxaFoXdLVoGiSD6G/Pfk2GhhK1Ft/opuajLgUA=3D=3D?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR04MB6514.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b5babe2b-4586-438c-e8bf-08d8d55c3f90
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Feb 2021 04:59:05.2038 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XMIKy0SE062u2yGnIACGuF7f1lb89/pAGx49OIE2J5dWf8Ydv8X6L4nnNB7GGPsUEYC1CiPhQeGiRr4Zz9uMCA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR04MB6596
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 11K4xHtk002345
X-loop: dm-devel@redhat.com
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, "kch@kernel.org" <kch@kernel.org>,
	"sagi@grimberg.me" <sagi@grimberg.me>,
	"snitzer@redhat.com" <snitzer@redhat.com>,
	"selvajove@gmail.com" <selvajove@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"nj.shetty@samsung.com" <nj.shetty@samsung.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"joshi.k@samsung.com" <joshi.k@samsung.com>,
	"javier.gonz@samsung.com" <javier.gonz@samsung.com>,
	"kbusch@kernel.org" <kbusch@kernel.org>,
	"joshiiitr@gmail.com" <joshiiitr@gmail.com>, "hch@lst.de" <hch@lst.de>
Subject: Re: [dm-devel] [RFC PATCH v5 2/4] block: add simple copy support
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On 2021/02/20 11:01, SelvaKumar S wrote:
> Add new BLKCOPY ioctl that offloads copying of one or more sources
> ranges to a destination in the device. Accepts a 'copy_range' structure
> that contains destination (in sectors), no of sources and pointer to the
> array of source ranges. Each source range is represented by 'range_entry'
> that contains start and length of source ranges (in sectors).
>=20
> Introduce REQ_OP_COPY, a no-merge copy offload operation. Create
> bio with control information as payload and submit to the device.
> REQ_OP_COPY(19) is a write op and takes zone_write_lock when submitted
> to zoned device.
>=20
> If the device doesn't support copy or copy offload is disabled, then
> copy operation is emulated by default. However, the copy-emulation is an
> opt-in feature. Caller can choose not to use the copy-emulation by
> specifying a flag 'BLKDEV_COPY_NOEMULATION'.
>=20
> Copy-emulation is implemented by allocating memory of total copy size.
> The source ranges are read into memory by chaining bio for each source
> ranges and submitting them async and the last bio waits for completion.
> After data is read, it is written to the destination.
>=20
> bio_map_kern() is used to allocate bio and add pages of copy buffer to
> bio. As bio->bi_private and bio->bi_end_io are needed for chaining the
> bio and gets over-written, invalidate_kernel_vmap_range() for read is
> called in the caller.
>=20
> Introduce queue limits for simple copy and other helper functions.
> Add device limits as sysfs entries.
> =09- copy_offload
> =09- max_copy_sectors
> =09- max_copy_ranges_sectors
> =09- max_copy_nr_ranges
>=20
> copy_offload(=3D 0) is disabled by default. This needs to be enabled if
> copy-offload needs to be used.
> max_copy_sectors =3D 0 indicates the device doesn't support native copy.
>=20
> Native copy offload is not supported for stacked devices and is done via
> copy emulation.
>=20
> Signed-off-by: SelvaKumar S <selvakuma.s1@samsung.com>
> Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
> Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
> Signed-off-by: Javier Gonz=E1lez <javier.gonz@samsung.com>
> Signed-off-by: Chaitanya Kulkarni <kch@kernel.org>
> ---
>  block/blk-core.c          | 102 ++++++++++++++++--
>  block/blk-lib.c           | 222 ++++++++++++++++++++++++++++++++++++++
>  block/blk-merge.c         |   2 +
>  block/blk-settings.c      |  10 ++
>  block/blk-sysfs.c         |  47 ++++++++
>  block/blk-zoned.c         |   1 +
>  block/bounce.c            |   1 +
>  block/ioctl.c             |  33 ++++++
>  include/linux/bio.h       |   1 +
>  include/linux/blk_types.h |  14 +++
>  include/linux/blkdev.h    |  15 +++
>  include/uapi/linux/fs.h   |  13 +++
>  12 files changed, 453 insertions(+), 8 deletions(-)
>=20
> diff --git a/block/blk-core.c b/block/blk-core.c
> index 7663a9b94b80..23e646e5ae43 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -720,6 +720,17 @@ static noinline int should_fail_bio(struct bio *bio)
>  }
>  ALLOW_ERROR_INJECTION(should_fail_bio, ERRNO);
> =20
> +static inline int bio_check_copy_eod(struct bio *bio, sector_t start,
> +=09=09sector_t nr_sectors, sector_t max_sect)
> +{
> +=09if (nr_sectors && max_sect &&
> +=09    (nr_sectors > max_sect || start > max_sect - nr_sectors)) {
> +=09=09handle_bad_sector(bio, max_sect);
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
> @@ -738,6 +749,75 @@ static inline int bio_check_eod(struct bio *bio, sec=
tor_t maxsector)
>  =09return 0;
>  }
> =20
> +/*
> + * Check for copy limits and remap source ranges if needed.
> + */
> +static int blk_check_copy(struct bio *bio)
> +{
> +=09struct blk_copy_payload *payload =3D bio_data(bio);
> +=09struct request_queue *q =3D bio->bi_disk->queue;
> +=09sector_t max_sect, start_sect, copy_size =3D 0;
> +=09sector_t src_max_sect, src_start_sect;
> +=09struct block_device *bd_part;
> +=09int i, ret =3D -EIO;
> +
> +=09rcu_read_lock();
> +
> +=09bd_part =3D __disk_get_part(bio->bi_disk, bio->bi_partno);
> +=09if (unlikely(!bd_part)) {
> +=09=09rcu_read_unlock();
> +=09=09goto out;
> +=09}
> +
> +=09max_sect =3D  bdev_nr_sectors(bd_part);
> +=09start_sect =3D bd_part->bd_start_sect;
> +
> +=09src_max_sect =3D bdev_nr_sectors(payload->src_bdev);
> +=09src_start_sect =3D payload->src_bdev->bd_start_sect;
> +
> +=09if (unlikely(should_fail_request(bd_part, bio->bi_iter.bi_size)))
> +=09=09goto out;
> +
> +=09if (unlikely(bio_check_ro(bio, bd_part)))
> +=09=09goto out;

There is no rcu_unlock() in that out label. Did you test ?

> +
> +=09rcu_read_unlock();
> +
> +=09/* cannot handle copy crossing nr_ranges limit */
> +=09if (payload->copy_nr_ranges > q->limits.max_copy_nr_ranges)
> +=09=09goto out;
> +
> +=09for (i =3D 0; i < payload->copy_nr_ranges; i++) {
> +=09=09ret =3D bio_check_copy_eod(bio, payload->range[i].src,
> +=09=09=09=09payload->range[i].len, src_max_sect);
> +=09=09if (unlikely(ret))
> +=09=09=09goto out;
> +
> +=09=09/* single source range length limit */
> +=09=09if (payload->range[i].len > q->limits.max_copy_range_sectors)
> +=09=09=09goto out;

ret is not set. You will return success with this.

> +
> +=09=09payload->range[i].src +=3D src_start_sect;
> +=09=09copy_size +=3D payload->range[i].len;
> +=09}
> +
> +=09/* check if copy length crosses eod */
> +=09ret =3D bio_check_copy_eod(bio, bio->bi_iter.bi_sector,
> +=09=09=09=09copy_size, max_sect);
> +=09if (unlikely(ret))
> +=09=09goto out;
> +
> +=09/* cannot handle copy more than copy limits */
> +=09if (copy_size > q->limits.max_copy_sectors)
> +=09=09goto out;

Again ret is not set... No error return ?

> +
> +=09bio->bi_iter.bi_sector +=3D start_sect;
> +=09bio->bi_partno =3D 0;
> +=09ret =3D 0;
> +out:
> +=09return ret;
> +}
> +
>  /*
>   * Remap block n of partition p to block n+start(p) of the disk.
>   */
> @@ -827,14 +907,16 @@ static noinline_for_stack bool submit_bio_checks(st=
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
> @@ -858,6 +940,10 @@ static noinline_for_stack bool submit_bio_checks(str=
uct bio *bio)
>  =09=09if (!blk_queue_discard(q))
>  =09=09=09goto not_supported;
>  =09=09break;
> +=09case REQ_OP_COPY:
> +=09=09if (unlikely(blk_check_copy(bio)))
> +=09=09=09goto end_io;
> +=09=09break;
>  =09case REQ_OP_SECURE_ERASE:
>  =09=09if (!blk_queue_secure_erase(q))
>  =09=09=09goto not_supported;
> diff --git a/block/blk-lib.c b/block/blk-lib.c
> index 752f9c722062..97ba58d8d9a1 100644
> --- a/block/blk-lib.c
> +++ b/block/blk-lib.c
> @@ -150,6 +150,228 @@ int blkdev_issue_discard(struct block_device *bdev,=
 sector_t sector,
>  }
>  EXPORT_SYMBOL(blkdev_issue_discard);
> =20
> +int blk_copy_offload(struct block_device *dest_bdev, struct blk_copy_pay=
load *payload,
> +=09=09sector_t dest, gfp_t gfp_mask)

Simple copy is only over the same device, right ? So the name "dest_bdev" i=
s a
little strange.

> +{
> +=09struct request_queue *q =3D bdev_get_queue(dest_bdev);
> +=09struct bio *bio;
> +=09int ret, payload_size;
> +
> +=09payload_size =3D struct_size(payload, range, payload->copy_nr_ranges)=
;
> +=09bio =3D bio_map_kern(q, payload, payload_size, gfp_mask);
> +=09if (IS_ERR(bio)) {
> +=09=09ret =3D PTR_ERR(bio);
> +=09=09goto err;

This will do a bio_put() on a non existent bio...

> +=09}
> +
> +=09bio->bi_iter.bi_sector =3D dest;
> +=09bio->bi_opf =3D REQ_OP_COPY | REQ_NOMERGE;
> +=09bio_set_dev(bio, dest_bdev);
> +
> +=09ret =3D submit_bio_wait(bio);
> +err:
> +=09bio_put(bio);
> +=09return ret;
> +}
> +
> +int blk_read_to_buf(struct block_device *src_bdev, struct blk_copy_paylo=
ad *payload,
> +=09=09gfp_t gfp_mask, sector_t copy_size, void **buf_p)
> +{
> +=09struct request_queue *q =3D bdev_get_queue(src_bdev);
> +=09struct bio *bio, *parent =3D NULL;
> +=09void *buf =3D NULL;
> +=09int copy_len =3D copy_size << SECTOR_SHIFT;
> +=09int i, nr_srcs, ret, cur_size, t_len =3D 0;
> +=09bool is_vmalloc;
> +
> +=09nr_srcs =3D payload->copy_nr_ranges;
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
> +=09=09bio_set_dev(bio, src_bdev);
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

But blk_write_from_buf() will use the buffer right after this.. Is this rea=
lly OK ?

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
> +int blk_write_from_buf(struct block_device *dest_bdev, void *buf, sector=
_t dest,
> +=09=09sector_t copy_size, gfp_t gfp_mask)
> +{
> +=09struct request_queue *q =3D bdev_get_queue(dest_bdev);
> +=09struct bio *bio;
> +=09int ret, copy_len =3D copy_size << SECTOR_SHIFT;
> +
> +=09bio =3D bio_map_kern(q, buf, copy_len, gfp_mask);
> +=09if (IS_ERR(bio)) {
> +=09=09ret =3D PTR_ERR(bio);
> +=09=09goto out;
> +=09}
> +=09bio_set_dev(bio, dest_bdev);
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
> +int blk_prepare_payload(struct block_device *src_bdev, int nr_srcs, stru=
ct range_entry *rlist,
> +=09=09gfp_t gfp_mask, struct blk_copy_payload **payload_p, sector_t *cop=
y_size)
> +{
> +
> +=09struct request_queue *q =3D bdev_get_queue(src_bdev);
> +=09struct blk_copy_payload *payload;
> +=09sector_t bs_mask, total_len =3D 0;
> +=09int i, ret, payload_size;
> +
> +=09if (!q)
> +=09=09return -ENXIO;
> +
> +=09if (!nr_srcs)
> +=09=09return -EINVAL;
> +
> +=09if (bdev_read_only(src_bdev))
> +=09=09return -EPERM;
> +
> +=09bs_mask =3D (bdev_logical_block_size(src_bdev) >> 9) - 1;
> +
> +=09payload_size =3D struct_size(payload, range, nr_srcs);
> +=09payload =3D kmalloc(payload_size, gfp_mask);
> +=09if (!payload)
> +=09=09return -ENOMEM;
> +
> +=09for (i =3D 0; i < nr_srcs; i++) {
> +=09=09if (rlist[i].src & bs_mask || rlist[i].len & bs_mask) {
> +=09=09=09ret =3D -EINVAL;
> +=09=09=09goto err;
> +=09=09}
> +
> +=09=09payload->range[i].src =3D rlist[i].src;
> +=09=09payload->range[i].len =3D rlist[i].len;
> +
> +=09=09total_len +=3D rlist[i].len;
> +=09}
> +
> +=09payload->copy_nr_ranges =3D i;
> +=09payload->src_bdev =3D src_bdev;
> +=09*copy_size =3D total_len;
> +
> +=09*payload_p =3D payload;
> +=09return 0;
> +err:
> +=09kfree(payload);
> +=09return ret;
> +}
> +
> +int blk_copy_emulate(struct block_device *src_bdev, struct blk_copy_payl=
oad *payload,
> +=09=09=09struct block_device *dest_bdev, sector_t dest,
> +=09=09=09sector_t copy_size, gfp_t gfp_mask)
> +{
> +=09void *buf =3D NULL;
> +=09int ret;
> +
> +=09ret =3D blk_read_to_buf(src_bdev, payload, gfp_mask, copy_size, &buf)=
;
> +=09if (ret)
> +=09=09goto out;
> +
> +=09ret =3D blk_write_from_buf(dest_bdev, buf, dest, copy_size, gfp_mask)=
;
> +=09if (buf)
> +=09=09kvfree(buf);
> +out:
> +=09return ret;
> +}

I already commented that this should better use the dm-kcopyd design, which
would be far more efficient than this. This will be slow...

Your function blkdev_issue_copy() below should deal only with issuing simpl=
e
copy (amd later scsi xcopy) for devices that support it. Bring the dm-kcopy=
d
interface in the block layer as a generic interface for hadling emulation.
Otherwise you are repeating what dm does, but not as efficiently.

> +
> +/**
> + * blkdev_issue_copy - queue a copy
> + * @src_bdev:=09source block device
> + * @nr_srcs:=09number of source ranges to copy
> + * @rlist:=09array of source ranges in sector
> + * @dest_bdev:=09destination block device
> + * @dest:=09destination in sector
> + * @gfp_mask:   memory allocation flags (for bio_alloc)
> + * @flags:=09BLKDEV_COPY_* flags to control behaviour
> + *
> + * Description:
> + *=09Copy array of source ranges from source block device to
> + *=09destination block devcie. All source must belong to same bdev and
> + *=09length of a source range cannot be zero.
> + */
> +
> +int blkdev_issue_copy(struct block_device *src_bdev, int nr_srcs,
> +=09=09struct range_entry *src_rlist, struct block_device *dest_bdev,
> +=09=09sector_t dest, gfp_t gfp_mask, int flags)
> +{
> +=09struct request_queue *q =3D bdev_get_queue(src_bdev);
> +=09struct request_queue *dest_q =3D bdev_get_queue(dest_bdev);
> +=09struct blk_copy_payload *payload;
> +=09sector_t bs_mask, copy_size;
> +=09int ret;
> +
> +=09ret =3D blk_prepare_payload(src_bdev, nr_srcs, src_rlist, gfp_mask,
> +=09=09=09&payload, &copy_size);
> +=09if (ret)
> +=09=09return ret;
> +
> +=09bs_mask =3D (bdev_logical_block_size(dest_bdev) >> 9) - 1;
> +=09if (dest & bs_mask) {
> +=09=09return -EINVAL;
> +=09=09goto out;
> +=09}
> +
> +=09if (q =3D=3D dest_q && q->limits.copy_offload) {
> +=09=09ret =3D blk_copy_offload(src_bdev, payload, dest, gfp_mask);
> +=09=09if (ret)
> +=09=09=09goto out;
> +=09} else if (flags & BLKDEV_COPY_NOEMULATION) {

Why ? whoever calls blkdev_issue_copy() wants a copy to be done. Why would =
that
user say "Fail on me if the device does not support copy" ??? This is a wei=
rd
interface in my opinion.

> +=09=09ret =3D -EIO;
> +=09=09goto out;
> +=09} else

Missing braces. By you do not need all these else after the gotos anyway.

> +=09=09ret =3D blk_copy_emulate(src_bdev, payload, dest_bdev, dest,
> +=09=09=09=09copy_size, gfp_mask);
> +
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

Why would this even be called ? Copy BIOs cannot be split, right ?

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

You do not need this. Limits not explicitely initialized are 0 already.
But I do not see why you can't support copy on stacked devices. That should=
 be
feasible taking the min() for each of the above limit.

> +
>  =09/* Physical block size a multiple of the logical block size? */
>  =09if (t->physical_block_size & (t->logical_block_size - 1)) {
>  =09=09t->physical_block_size =3D t->logical_block_size;
> diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
> index b513f1683af0..625a72541263 100644
> --- a/block/blk-sysfs.c
> +++ b/block/blk-sysfs.c
> @@ -166,6 +166,44 @@ static ssize_t queue_discard_granularity_show(struct=
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
> +=09if (copy_offload && q->limits.max_copy_sectors =3D=3D 0)
> +=09=09return -EINVAL;
> +
> +=09q->limits.copy_offload =3D copy_offload;
> +=09return ret;
> +}

This is weird. If you want to allow a user to disable copy offload, then us=
e
max_copy_sectors. This one should be read-only and only indicate if the dev=
ice
supports it or not. I also would actually change this one into
max_copy_hw_sectors, immutable, indicating the max copy sectors that the de=
vice
supports, and 0 for no support. That would allow an easy implementation of
max_copy_sectors being red/write for controlling enable/disable.

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
> @@ -591,6 +629,11 @@ QUEUE_RO_ENTRY(queue_nr_zones, "nr_zones");
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
> @@ -636,6 +679,10 @@ static struct attribute *queue_attrs[] =3D {
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
> index d61d652078f4..0e52181657a4 100644
> --- a/block/ioctl.c
> +++ b/block/ioctl.c
> @@ -133,6 +133,37 @@ static int blk_ioctl_discard(struct block_device *bd=
ev, fmode_t mode,
>  =09=09=09=09    GFP_KERNEL, flags);
>  }
> =20
> +static int blk_ioctl_copy(struct block_device *bdev, fmode_t mode,
> +=09=09unsigned long arg, unsigned long flags)
> +{
> +=09struct copy_range crange;
> +=09struct range_entry *rlist;
> +=09int ret;
> +
> +=09if (!(mode & FMODE_WRITE))
> +=09=09return -EBADF;
> +
> +=09if (copy_from_user(&crange, (void __user *)arg, sizeof(crange)))
> +=09=09return -EFAULT;
> +
> +=09rlist =3D kmalloc_array(crange.nr_range, sizeof(*rlist),
> +=09=09=09GFP_KERNEL);
> +=09if (!rlist)
> +=09=09return -ENOMEM;
> +
> +=09if (copy_from_user(rlist, (void __user *)crange.range_list,
> +=09=09=09=09sizeof(*rlist) * crange.nr_range)) {
> +=09=09ret =3D -EFAULT;
> +=09=09goto out;
> +=09}
> +
> +=09ret =3D blkdev_issue_copy(bdev, crange.nr_range, rlist, bdev, crange.=
dest,
> +=09=09=09GFP_KERNEL, flags);
> +out:
> +=09kfree(rlist);
> +=09return ret;
> +}
> +
>  static int blk_ioctl_zeroout(struct block_device *bdev, fmode_t mode,
>  =09=09unsigned long arg)
>  {
> @@ -458,6 +489,8 @@ static int blkdev_common_ioctl(struct block_device *b=
dev, fmode_t mode,
>  =09case BLKSECDISCARD:
>  =09=09return blk_ioctl_discard(bdev, mode, arg,
>  =09=09=09=09BLKDEV_DISCARD_SECURE);
> +=09case BLKCOPY:
> +=09=09return blk_ioctl_copy(bdev, mode, arg, 0);
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
> index 866f74261b3b..5a35c02ac0a8 100644
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
> @@ -565,4 +572,11 @@ struct blk_rq_stat {
>  =09u64 batch;
>  };
> =20
> +struct blk_copy_payload {
> +=09sector_t=09dest;
> +=09int=09=09copy_nr_ranges;
> +=09struct block_device *src_bdev;
> +=09struct=09range_entry=09range[];
> +};
> +
>  #endif /* __LINUX_BLK_TYPES_H */
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index 699ace6b25ff..2bb4513d4bb8 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -337,10 +337,14 @@ struct queue_limits {
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
> @@ -621,6 +625,7 @@ struct request_queue {
>  #define QUEUE_FLAG_RQ_ALLOC_TIME 27=09/* record rq->alloc_time_ns */
>  #define QUEUE_FLAG_HCTX_ACTIVE=0928=09/* at least one blk-mq hctx is act=
ive */
>  #define QUEUE_FLAG_NOWAIT       29=09/* device supports NOWAIT */
> +#define QUEUE_FLAG_SIMPLE_COPY=0930=09/* supports simple copy */
> =20
>  #define QUEUE_FLAG_MQ_DEFAULT=09((1 << QUEUE_FLAG_IO_STAT) |=09=09\
>  =09=09=09=09 (1 << QUEUE_FLAG_SAME_COMP) |=09=09\
> @@ -643,6 +648,7 @@ bool blk_queue_flag_test_and_set(unsigned int flag, s=
truct request_queue *q);
>  #define blk_queue_io_stat(q)=09test_bit(QUEUE_FLAG_IO_STAT, &(q)->queue_=
flags)
>  #define blk_queue_add_random(q)=09test_bit(QUEUE_FLAG_ADD_RANDOM, &(q)->=
queue_flags)
>  #define blk_queue_discard(q)=09test_bit(QUEUE_FLAG_DISCARD, &(q)->queue_=
flags)
> +#define blk_queue_copy(q)=09test_bit(QUEUE_FLAG_SIMPLE_COPY, &(q)->queue=
_flags)
>  #define blk_queue_zone_resetall(q)=09\
>  =09test_bit(QUEUE_FLAG_ZONE_RESETALL, &(q)->queue_flags)
>  #define blk_queue_secure_erase(q) \
> @@ -1069,6 +1075,9 @@ static inline unsigned int blk_queue_get_max_sector=
s(struct request_queue *q,
>  =09=09return min(q->limits.max_discard_sectors,
>  =09=09=09   UINT_MAX >> SECTOR_SHIFT);
> =20
> +=09if (unlikely(op =3D=3D REQ_OP_COPY))
> +=09=09return q->limits.max_copy_sectors;
> +

I would agreee with this if a copy BIO was always a single range, but that =
is
not the case. So I am not sure this makes sense at all.

>  =09if (unlikely(op =3D=3D REQ_OP_WRITE_SAME))
>  =09=09return q->limits.max_write_same_sectors;
> =20
> @@ -1343,6 +1352,12 @@ extern int __blkdev_issue_discard(struct block_dev=
ice *bdev, sector_t sector,
>  =09=09sector_t nr_sects, gfp_t gfp_mask, int flags,
>  =09=09struct bio **biop);
> =20
> +#define BLKDEV_COPY_NOEMULATION=09(1 << 0)=09/* do not emulate if copy o=
ffload not supported */
> +
> +extern int blkdev_issue_copy(struct block_device *src_bdev, int nr_srcs,
> +=09=09struct range_entry *src_rlist, struct block_device *dest_bdev,
> +=09=09sector_t dest, gfp_t gfp_mask, int flags);

No need for extern.

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

Please test your code more thoroughly. It is full of problems that you shou=
ld
have detected with better testing including RO devices, partitions and erro=
r
path coverage.

--=20
Damien Le Moal
Western Digital Research



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

