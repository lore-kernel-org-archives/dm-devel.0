Return-Path: <SRS0=jKmk=GI=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4581C433E6
	for <dm-devel@archiver.kernel.org>; Tue,  5 Jan 2021 23:34:24 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 4D3D32067C
	for <dm-devel@archiver.kernel.org>; Tue,  5 Jan 2021 23:34:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4D3D32067C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-276-Iak549-_OoyBpmhdM1gu6Q-1; Tue, 05 Jan 2021 18:34:21 -0500
X-MC-Unique: Iak549-_OoyBpmhdM1gu6Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4DAA98015C6;
	Tue,  5 Jan 2021 23:34:16 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8B1FE70955;
	Tue,  5 Jan 2021 23:34:15 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 7862C4A7C6;
	Tue,  5 Jan 2021 23:34:13 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 105NYA8S005736 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 5 Jan 2021 18:34:10 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 5795B2026D11; Tue,  5 Jan 2021 23:34:10 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 503E32026D76
	for <dm-devel@redhat.com>; Tue,  5 Jan 2021 23:34:08 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F2E38803C9F
	for <dm-devel@redhat.com>; Tue,  5 Jan 2021 23:34:07 +0000 (UTC)
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-29-KDS5IwSPO8e6IkHuQxn9HQ-1; Tue, 05 Jan 2021 18:34:03 -0500
X-MC-Unique: KDS5IwSPO8e6IkHuQxn9HQ-1
IronPort-SDR: BLEkSgpdCav+lIQvaPAEpTjy6dcracGRcdKg/1XeWgCuwi/I/qmWl03RwW3t2k1/r8HE4O7ZgF
	U0LZnCH8U1U/LFiFi1IFLK5nbv/VCb55G3ka2zVJbuwyTSA/uo8lKiztBet2Wo0MU/vG0HD6FB
	fTKNeBzRPIZxdIQz5KVb+wFqibDeMM/W39Rgznkxioj9NWOLTf/Yw3pZPRr9nq6gCaVoTBk6ny
	HLMnRh2DSCmdjXf3UrRrzgngL7hO491sKjuKiSDaN12cgZ8DrGllhP9Zv+BptVEMhWN37cTOnv
	8uY=
X-IronPort-AV: E=Sophos;i="5.78,478,1599494400"; d="scan'208";a="260468325"
Received: from mail-sn1nam04lp2055.outbound.protection.outlook.com (HELO
	NAM04-SN1-obe.outbound.protection.outlook.com) ([104.47.44.55])
	by ob1.hgst.iphmx.com with ESMTP; 06 Jan 2021 07:46:18 +0800
Received: from BL0PR04MB6514.namprd04.prod.outlook.com (2603:10b6:208:1ca::23)
	by MN2PR04MB6415.namprd04.prod.outlook.com (2603:10b6:208:1a4::21)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3721.20;
	Tue, 5 Jan 2021 23:33:57 +0000
Received: from BL0PR04MB6514.namprd04.prod.outlook.com
	([fe80::2dbb:7e01:f076:eca0]) by
	BL0PR04MB6514.namprd04.prod.outlook.com
	([fe80::2dbb:7e01:f076:eca0%9]) with mapi id 15.20.3721.024;
	Tue, 5 Jan 2021 23:33:57 +0000
From: Damien Le Moal <Damien.LeMoal@wdc.com>
To: Selva Jove <selvajove@gmail.com>
Thread-Topic: [RFC PATCH v4 2/3] block: add simple copy support
Thread-Index: AQHW4ocZGQHbBBU/JES2xoCYHwM80A==
Date: Tue, 5 Jan 2021 23:33:57 +0000
Message-ID: <BL0PR04MB6514233D8AE368455EF35AB6E7D10@BL0PR04MB6514.namprd04.prod.outlook.com>
References: <20210104104159.74236-1-selvakuma.s1@samsung.com>
	<CGME20210104104249epcas5p458d1b5c39b5acfad4e7786eca5dd5c49@epcas5p4.samsung.com>
	<20210104104159.74236-3-selvakuma.s1@samsung.com>
	<BL0PR04MB651402CFA75F72826AC8EE1CE7D20@BL0PR04MB6514.namprd04.prod.outlook.com>
	<CAHqX9vafJ9JwkT-oDJRfbLV0WKym-6FiTQqngcP1pk8J+zgbxQ@mail.gmail.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2400:2411:43c0:6000:78c3:a7df:f52d:1169]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 51f69e64-7d67-431f-86b8-08d8b1d25f93
x-ms-traffictypediagnostic: MN2PR04MB6415:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR04MB641567A8D9845D79B33FEB52E7D10@MN2PR04MB6415.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:6790
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: RSQVOL/XD7BHC327oOnUutZyoMh1w6qi68EJEPLgtoggC9fxTFTxFlqWO7TgOUcC1FtYl6zlIumWK0DUf6pLBuJFtxhTgwpPZfkY8FoTMGygUVFNhuX60r+FHP2IndQKlg2ySz3rXejHmhwsprcoPV8wMPREozMZntbxtJYf/JNZ+SxG+XkWnXTD6piiyfj39opk2a6W2ylIRkby/jLk4FlAG3rn5nWDx3AM+MtBPMBpTGQPw16PqhVs5t+dWsDpSBSjerVE+knmqm0HrUefOjLoavFFDAs2lNt6xjJJuYLatOKb+PfqncHswzhaIc+6+6/RidzvueZ1c+RdfVgSqkQjtc+f9Kv+LcFv3xlJtJvTlqqQS1OgoUVf+4nt9fEdPtS9MCgoqLzv0CObyxSKIqM+wFBQsdbh3nd7++1I8NUGNuCcOcy/CLF0pVr67+wY
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:BL0PR04MB6514.namprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(366004)(396003)(346002)(39860400002)(376002)(136003)(53546011)(6506007)(66574015)(6916009)(4326008)(8936002)(91956017)(76116006)(86362001)(2906002)(83380400001)(5660300002)(9686003)(52536014)(64756008)(55016002)(186003)(7416002)(316002)(66946007)(66556008)(30864003)(66446008)(33656002)(54906003)(66476007)(7696005)(8676002)(478600001)(71200400001)(21314003);
	DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata: =?iso-8859-1?Q?vpG3TdYvkB6EYwMlj/tsGk46dduzVtwzmDKw/hPwD2Q/JuC9N0MUG78b6x?=
	=?iso-8859-1?Q?zYhUTVwn+fpwsJSKPYWJn5er6PeGBHjBAUOnBaWL9s/cwrBqag7fivcSh7?=
	=?iso-8859-1?Q?u+MCs8hSYYvIiCD7hYMw8Fe/51m5Xw+sRNj2D2KEHAD0mdwWhgQXD03fMJ?=
	=?iso-8859-1?Q?CyAFT3r1T4Z5xghZlCenZqSvZv73nTHtXMdbHhbCD6PwrL9ljfHMiW7NzY?=
	=?iso-8859-1?Q?pXUjPYsWOt0SsZmthKHDowpLsgsUWBD1+XSCRR1mj9/9dBcPrQkWAyX/3T?=
	=?iso-8859-1?Q?C5XVBV5p/uACquz3T4okGvon456sr6Z22eBppiSK8kMZ1uJHbxrIjUjgUq?=
	=?iso-8859-1?Q?z/UlZ9aVoCoXReSeFuJcuOqvq+shK8c/DY6AL3zk19qQTPUuRtdJsyu9u4?=
	=?iso-8859-1?Q?AH3sNbmv0JAKgyBIFPsaVnc73mki6lx7IClWbM4CzryN6b0xT0N5d3fUKD?=
	=?iso-8859-1?Q?cPt9We9lmnd7KF/2EuZbf8wMWSv9UO2mRtrnRktpEb6/+Iw4ZOH0gKth8n?=
	=?iso-8859-1?Q?54UPyB+QLb2Yfsvm4g8WxMz/EUUQoNPRliH5UkErcdij0H9JE/O7B2Eum7?=
	=?iso-8859-1?Q?ujS6v82uKHFmmjgL97VMAsRMSMt+sgFmIQd7HZRa4ZbMiOmQRuvA92RyRL?=
	=?iso-8859-1?Q?V9BaGys4KtY3B2BxB/9WtdDSsAdY7/4gj3XNo71kNUHf3iq99ap8iuyBvP?=
	=?iso-8859-1?Q?7bQWY5UlDmouoyKsECP6QovGUHMWtzC1PVD1VjLHNFcBEmJFUloUKhUg5B?=
	=?iso-8859-1?Q?AW6igkSK6Wt/QJMyBupBmS8vzxYC8kWqx5Nperjy+r9HF92boKjvjkef/X?=
	=?iso-8859-1?Q?mi3TWMVrZf4KT/P9+RZdblQyFPK1Kj38iFGTJMl1gkTDRlyt2ZkOE3LosH?=
	=?iso-8859-1?Q?tu6xGYkh/siqTT/sK3GmARdg8KPlUGFOGrmPaK6sRBKf7TJJQA7RV3MFPN?=
	=?iso-8859-1?Q?ORsLto/E/f7B6alCnUiZowucUggCJF/q/oVvzs7pd/q7jJHkopYaspXCez?=
	=?iso-8859-1?Q?LCg/LoOQuGstf8aG2FNXw6ondHxbkAaj46U5UPovJIwWxT2n0FlVwuWe8I?=
	=?iso-8859-1?Q?/8ZtJX1NjREWnKC6NWlAEPnJOC1ZwPXHgkHp5rPi9QVN?=
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR04MB6514.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 51f69e64-7d67-431f-86b8-08d8b1d25f93
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jan 2021 23:33:57.5984 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rUpWRjsipFlxK93Aw0CrX3WVaJ6e5W+rFEZQRQjAPaiNWEc/xGUqVlE9V3qRReqW1j+BM6TionLE8q9RIU5NIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6415
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 105NYA8S005736
X-loop: dm-devel@redhat.com
Cc: "axboe@kernel.dk" <axboe@kernel.dk>,
	SelvaKumar S <selvakuma.s1@samsung.com>,
	"sagi@grimberg.me" <sagi@grimberg.me>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
	"snitzer@redhat.com" <snitzer@redhat.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On 2021/01/05 21:24, Selva Jove wrote:
> Thanks for the review, Damien.
>=20
> On Mon, Jan 4, 2021 at 6:17 PM Damien Le Moal <Damien.LeMoal@wdc.com> wro=
te:
>>
>> On 2021/01/04 19:48, SelvaKumar S wrote:
>>> Add new BLKCOPY ioctl that offloads copying of one or more sources
>>> ranges to a destination in the device. Accepts copy_ranges that contain=
s
>>> destination, no of sources and pointer to the array of source
>>> ranges. Each range_entry contains start and length of source
>>> ranges (in bytes).
>>>
>>> Introduce REQ_OP_COPY, a no-merge copy offload operation. Create
>>> bio with control information as payload and submit to the device.
>>> REQ_OP_COPY(19) is a write op and takes zone_write_lock when submitted
>>> to zoned device.
>>>
>>> If the device doesn't support copy or copy offload is disabled, then
>>> copy is emulated by allocating memory of total copy size. The source
>>> ranges are read into memory by chaining bio for each source ranges and
>>> submitting them async and the last bio waits for completion. After data
>>> is read, it is written to the destination.
>>>
>>> bio_map_kern() is used to allocate bio and add pages of copy buffer to
>>> bio. As bio->bi_private and bio->bi_end_io is needed for chaining the
>>> bio and over written, invalidate_kernel_vmap_range() for read is called
>>> in the caller.
>>>
>>> Introduce queue limits for simple copy and other helper functions.
>>> Add device limits as sysfs entries.
>>>       - copy_offload
>>>       - max_copy_sectors
>>>       - max_copy_ranges_sectors
>>>       - max_copy_nr_ranges
>>>
>>> copy_offload(=3D 0) is disabled by default.
>>> max_copy_sectors =3D 0 indicates the device doesn't support native copy=
.
>>>
>>> Native copy offload is not supported for stacked devices and is done vi=
a
>>> copy emulation.
>>>
>>> Signed-off-by: SelvaKumar S <selvakuma.s1@samsung.com>
>>> Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
>>> Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
>>> Signed-off-by: Javier Gonz=E1lez <javier.gonz@samsung.com>
>>> ---
>>>  block/blk-core.c          |  94 ++++++++++++++--
>>>  block/blk-lib.c           | 223 ++++++++++++++++++++++++++++++++++++++
>>>  block/blk-merge.c         |   2 +
>>>  block/blk-settings.c      |  10 ++
>>>  block/blk-sysfs.c         |  50 +++++++++
>>>  block/blk-zoned.c         |   1 +
>>>  block/bounce.c            |   1 +
>>>  block/ioctl.c             |  43 ++++++++
>>>  include/linux/bio.h       |   1 +
>>>  include/linux/blk_types.h |  15 +++
>>>  include/linux/blkdev.h    |  13 +++
>>>  include/uapi/linux/fs.h   |  13 +++
>>>  12 files changed, 458 insertions(+), 8 deletions(-)
>>>
>>> diff --git a/block/blk-core.c b/block/blk-core.c
>>> index 96e5fcd7f071..4a5cd3f53cd2 100644
>>> --- a/block/blk-core.c
>>> +++ b/block/blk-core.c
>>> @@ -719,6 +719,17 @@ static noinline int should_fail_bio(struct bio *bi=
o)
>>>  }
>>>  ALLOW_ERROR_INJECTION(should_fail_bio, ERRNO);
>>>
>>> +static inline int bio_check_copy_eod(struct bio *bio, sector_t start,
>>> +             sector_t nr_sectors, sector_t maxsector)
>>> +{
>>> +     if (nr_sectors && maxsector &&
>>> +         (nr_sectors > maxsector || start > maxsector - nr_sectors)) {
>>> +             handle_bad_sector(bio, maxsector);
>>> +             return -EIO;
>>> +     }
>>> +     return 0;
>>> +}
>>> +
>>>  /*
>>>   * Check whether this bio extends beyond the end of the device or part=
ition.
>>>   * This may well happen - the kernel calls bread() without checking th=
e size of
>>> @@ -737,6 +748,65 @@ static inline int bio_check_eod(struct bio *bio, s=
ector_t maxsector)
>>>       return 0;
>>>  }
>>>
>>> +/*
>>> + * Check for copy limits and remap source ranges if needed.
>>> + */
>>> +static int blk_check_copy(struct bio *bio)
>>> +{
>>> +     struct block_device *p =3D NULL;
>>> +     struct request_queue *q =3D bio->bi_disk->queue;
>>> +     struct blk_copy_payload *payload;
>>> +     int i, maxsector, start_sect =3D 0, ret =3D -EIO;
>>> +     unsigned short nr_range;
>>> +
>>> +     rcu_read_lock();
>>> +
>>> +     p =3D __disk_get_part(bio->bi_disk, bio->bi_partno);
>>> +     if (unlikely(!p))
>>> +             goto out;
>>> +     if (unlikely(should_fail_request(p, bio->bi_iter.bi_size)))
>>> +             goto out;
>>> +     if (unlikely(bio_check_ro(bio, p)))
>>> +             goto out;
>>> +
>>> +     maxsector =3D  bdev_nr_sectors(p);
>>> +     start_sect =3D p->bd_start_sect;
>>> +
>>> +     payload =3D bio_data(bio);
>>> +     nr_range =3D payload->copy_range;
>>> +
>>> +     /* cannot handle copy crossing nr_ranges limit */
>>> +     if (payload->copy_range > q->limits.max_copy_nr_ranges)
>>> +             goto out;
>>
>> If payload->copy_range indicates the number of ranges to be copied, you =
should
>> name it payload->copy_nr_ranges.
>>
>=20
> Agreed. Will rename the entries.
>=20
>>> +
>>> +     /* cannot handle copy more than copy limits */
>>
>> Why ? You could loop... Similarly to discard, zone reset etc.
>>
>=20
> Sure. Will add the support for handling copy larger than device limits.
>=20
>>
>>> +     if (payload->copy_size > q->limits.max_copy_sectors)
>>> +             goto out;
>>
>> Shouldn't the list of source ranges give the total size to be copied ?
>> Otherwise, if payload->copy_size is user provided, you would need to che=
ck that
>> the sum of the source ranges actually is equal to copy_size, no ? That m=
eans
>> that dropping copy_size sound like the right thing to do here.
>>
>=20
> payload->copy_size is used in copy emulation to allocate the buffer.
> Let me check
> one more time if it is possible to do without this.

If this is used for the emulation only, then it should be a local variable =
in
the emulation helper.

[...]
>>
>>> +             if (unlikely(blk_check_copy(bio)))
>>> +                     goto end_io;
>>> +             break;
>>>       case REQ_OP_SECURE_ERASE:
>>>               if (!blk_queue_secure_erase(q))
>>>                       goto not_supported;
>>> diff --git a/block/blk-lib.c b/block/blk-lib.c
>>> index 752f9c722062..4c0f12e2ed7c 100644
>>> --- a/block/blk-lib.c
>>> +++ b/block/blk-lib.c
>>> @@ -150,6 +150,229 @@ int blkdev_issue_discard(struct block_device *bde=
v, sector_t sector,
>>>  }
>>>  EXPORT_SYMBOL(blkdev_issue_discard);
>>>
>>> +int blk_copy_offload(struct block_device *bdev, struct blk_copy_payloa=
d *payload,
>>> +             sector_t dest, gfp_t gfp_mask)
>>> +{
>>> +     struct bio *bio;
>>> +     int ret, total_size;
>>> +
>>> +     bio =3D bio_alloc(gfp_mask, 1);
>>> +     bio->bi_iter.bi_sector =3D dest;
>>> +     bio->bi_opf =3D REQ_OP_COPY | REQ_NOMERGE;
>>> +     bio_set_dev(bio, bdev);
>>> +
>>> +     total_size =3D struct_size(payload, range, payload->copy_range);
>>> +     ret =3D bio_add_page(bio, virt_to_page(payload), total_size,
>>
>> How is payload allocated ? If it is a structure on-stack in the caller, =
I am not
>> sure it would be wise to do an IO using the thread stack page...
>>
>>> +                                        offset_in_page(payload));
>>> +     if (ret !=3D total_size) {
>>> +             ret =3D -ENOMEM;
>>> +             bio_put(bio);
>>> +             goto err;
>>> +     }
>>> +
>>> +     ret =3D submit_bio_wait(bio);
>>> +err:
>>> +     bio_put(bio);
>>> +     return ret;
>>> +
>>> +}
>>> +
>>> +int blk_read_to_buf(struct block_device *bdev, struct blk_copy_payload=
 *payload,
>>> +             gfp_t gfp_mask, void **buf_p)
>>> +{
>>> +     struct request_queue *q =3D bdev_get_queue(bdev);
>>> +     struct bio *bio, *parent =3D NULL;
>>> +     void *buf =3D NULL;
>>> +     bool is_vmalloc;
>>> +     int i, nr_srcs, copy_len, ret, cur_size, t_len =3D 0;
>>> +
>>> +     nr_srcs =3D payload->copy_range;
>>> +     copy_len =3D payload->copy_size << SECTOR_SHIFT;
>>> +
>>> +     buf =3D kvmalloc(copy_len, gfp_mask);
>>> +     if (!buf)
>>> +             return -ENOMEM;
>>> +     is_vmalloc =3D is_vmalloc_addr(buf);
>>> +
>>> +     for (i =3D 0; i < nr_srcs; i++) {
>>> +             cur_size =3D payload->range[i].len << SECTOR_SHIFT;
>>> +
>>> +             bio =3D bio_map_kern(q, buf + t_len, cur_size, gfp_mask);
>>> +             if (IS_ERR(bio)) {
>>> +                     ret =3D PTR_ERR(bio);
>>> +                     goto out;
>>> +             }
>>> +
>>> +             bio->bi_iter.bi_sector =3D payload->range[i].src;
>>> +             bio->bi_opf =3D REQ_OP_READ;
>>> +             bio_set_dev(bio, bdev);
>>> +             bio->bi_end_io =3D NULL;
>>> +             bio->bi_private =3D NULL;
>>> +
>>> +             if (parent) {
>>> +                     bio_chain(parent, bio);
>>> +                     submit_bio(parent);
>>> +             }
>>> +
>>> +             parent =3D bio;
>>> +             t_len +=3D cur_size;
>>> +     }
>>> +
>>> +     ret =3D submit_bio_wait(bio);
>>> +     bio_put(bio);
>>> +     if (is_vmalloc)
>>> +             invalidate_kernel_vmap_range(buf, copy_len);
>>> +     if (ret)
>>> +             goto out;
>>> +
>>> +     *buf_p =3D buf;
>>> +     return 0;
>>> +out:
>>> +     kvfree(buf);
>>> +     return ret;
>>> +}
>>> +
>>> +int blk_write_from_buf(struct block_device *bdev, void *buf, sector_t =
dest,
>>> +             int copy_len, gfp_t gfp_mask)
>>> +{
>>> +     struct request_queue *q =3D bdev_get_queue(bdev);
>>> +     struct bio *bio;
>>> +     int ret;
>>> +
>>> +     bio =3D bio_map_kern(q, buf, copy_len, gfp_mask);
>>> +     if (IS_ERR(bio)) {
>>> +             ret =3D PTR_ERR(bio);
>>> +             goto out;
>>> +     }
>>> +     bio_set_dev(bio, bdev);
>>> +     bio->bi_opf =3D REQ_OP_WRITE;
>>> +     bio->bi_iter.bi_sector =3D dest;
>>> +
>>> +     bio->bi_end_io =3D NULL;
>>> +     ret =3D submit_bio_wait(bio);
>>> +     bio_put(bio);
>>> +out:
>>> +     return ret;
>>> +}
>>> +
>>> +int blk_prepare_payload(struct block_device *bdev, int nr_srcs, struct=
 range_entry *rlist,
>>> +             gfp_t gfp_mask, struct blk_copy_payload **payload_p)
>>> +{
>>> +
>>> +     struct request_queue *q =3D bdev_get_queue(bdev);
>>> +     struct blk_copy_payload *payload;
>>> +     sector_t bs_mask;
>>> +     sector_t src_sects, len =3D 0, total_len =3D 0;
>>> +     int i, ret, total_size;
>>> +
>>> +     if (!q)
>>> +             return -ENXIO;
>>> +
>>> +     if (!nr_srcs)
>>> +             return -EINVAL;
>>> +
>>> +     if (bdev_read_only(bdev))
>>> +             return -EPERM;
>>> +
>>> +     bs_mask =3D (bdev_logical_block_size(bdev) >> 9) - 1;
>>> +
>>> +     total_size =3D struct_size(payload, range, nr_srcs);
>>> +     payload =3D kmalloc(total_size, gfp_mask);
>>> +     if (!payload)
>>> +             return -ENOMEM;
>>
>> OK. So this is what goes into the bio. The function blk_copy_offload() a=
ssumes
>> this is at most one page, so total_size <=3D PAGE_SIZE. Where is that ch=
ecked ?
>>
>=20
> CMIIW. As payload was allocated via kmalloc, it would be represented by a=
 single
> contiguous segment. In case it crosses one page, rely on multi-page bio_v=
ec to
> cover it.

That is not how I understand the code. If the allocation is more than one p=
age,
you still need to add ALL pages to the BIO. What the multi-page bvec code w=
ill
do is to use a single bvec for all physically contiguous pages instead of a=
dding
one bvec per page.

Thinking more about it, I think the function blk_copy_offload() could simpl=
y use
bio_map_kern() to allocate and prepare the BIO. That will avoid the need fo=
r the
add page loop.

>=20
>>> +
>>> +     for (i =3D 0; i < nr_srcs; i++) {
>>> +             /*  copy payload provided are in bytes */
>>> +             src_sects =3D rlist[i].src;
>>> +             if (src_sects & bs_mask) {
>>> +                     ret =3D  -EINVAL;
>>> +                     goto err;
>>> +             }
>>> +             src_sects =3D src_sects >> SECTOR_SHIFT;
>>> +
>>> +             if (len & bs_mask) {
>>> +                     ret =3D -EINVAL;
>>> +                     goto err;
>>> +             }
>>> +
>>> +             len =3D rlist[i].len >> SECTOR_SHIFT;
>>> +
>>> +             total_len +=3D len;
>>> +
>>> +             WARN_ON_ONCE((src_sects << 9) > UINT_MAX);
>>> +
>>> +             payload->range[i].src =3D src_sects;
>>> +             payload->range[i].len =3D len;
>>> +     }
>>> +
>>> +     /* storing # of source ranges */
>>> +     payload->copy_range =3D i;
>>> +     /* storing copy len so far */
>>> +     payload->copy_size =3D total_len;
>>
>> The comments here make the code ugly. Rename the variables and structure=
 fields
>> to have something self explanatory.
>>
>=20
> Agreed.
>=20
>>> +
>>> +     *payload_p =3D payload;
>>> +     return 0;
>>> +err:
>>> +     kfree(payload);
>>> +     return ret;
>>> +}
>>> +
>>> +/**
>>> + * blkdev_issue_copy - queue a copy
>>> + * @bdev:       source block device
>>> + * @nr_srcs: number of source ranges to copy
>>> + * @rlist:   array of source ranges (in bytes)
>>> + * @dest_bdev:       destination block device
>>> + * @dest:    destination (in bytes)
>>> + * @gfp_mask:   memory allocation flags (for bio_alloc)
>>> + *
>>> + * Description:
>>> + *   Copy array of source ranges from source block device to
>>> + *   destination block devcie.
>>> + */
>>> +
>>> +
>>> +int blkdev_issue_copy(struct block_device *bdev, int nr_srcs,
>>> +             struct range_entry *src_rlist, struct block_device *dest_=
bdev,
>>> +             sector_t dest, gfp_t gfp_mask)
>>> +{
>>> +     struct request_queue *q =3D bdev_get_queue(bdev);
>>> +     struct blk_copy_payload *payload;
>>> +     sector_t bs_mask, dest_sect;
>>> +     void *buf =3D NULL;
>>> +     int ret;
>>> +
>>> +     ret =3D blk_prepare_payload(bdev, nr_srcs, src_rlist, gfp_mask, &=
payload);
>>> +     if (ret)
>>> +             return ret;
>>> +
>>> +     bs_mask =3D (bdev_logical_block_size(dest_bdev) >> 9) - 1;
>>> +     if (dest & bs_mask) {
>>> +             return -EINVAL;
>>> +             goto out;
>>> +     }
>>> +     dest_sect =3D dest >> SECTOR_SHIFT;
>>
>> dest should already be a 512B sector as all block layer functions interf=
ace use
>> this unit. What is this doing ?
>>
>=20
> As source ranges and length received were in bytes, to keep things
> same, dest was
> also chosen to be in bytes. Seems wrong. Will change it to the 512B secto=
r.

Using a byte interface seems very dangerous since writes can only be at bes=
t LBA
sized, and must be physical sector size aligned for zoned block devices. I
strobgly suggest that the interface use sector_t 512B unit.

>=20
>>
>>> +
>>> +     if (bdev =3D=3D dest_bdev && q->limits.copy_offload) {
>>> +             ret =3D blk_copy_offload(bdev, payload, dest_sect, gfp_ma=
sk);
>>> +             if (ret)
>>> +                     goto out;
>>> +     } else {
>>> +             ret =3D blk_read_to_buf(bdev, payload, gfp_mask, &buf);
>>> +             if (ret)
>>> +                     goto out;
>>> +             ret =3D blk_write_from_buf(dest_bdev, buf, dest_sect,
>>> +                             payload->copy_size << SECTOR_SHIFT, gfp_m=
ask);
>>
>> Arg... This is really not pretty. At the very least, this should all be =
in a
>> blk_copy_emulate() helper or something named like that.
>>
>=20
> Okay. Will move this to a helper.
>=20
>> My worry though is that this likely slow for large copies, not to mentio=
n that
>> buf is likely to fail to allocate for large copy cases. As commented pre=
viously,
>> dm-kcopyd already does such copy well, with a read-write streaming pipel=
ine and
>> zone support too for the write side. This should really be reused, at le=
ast
>> partly, instead of re-implementing this read-write here.
>>
>=20
> I was a bit hesitant to use dm layer code in the block layer. It makes se=
nse to
> reuse the code as much as possible. Will try to reuse dm-kcopyd code for =
copy
> emulation part.

You missed my point. I never suggested that you use DM code in the block la=
yer.
That would be wrong. What I suggested is that you move the dm-kcopyd code f=
rom
DM into the block layer, changing the function names to blk_copy_xxx(). See=
 the
current interface in include/linux/dm-kcopyd.h: there is absolutely nothing=
 that
is DM specific in there, so moving that code into block/blk-copy.c should b=
e
straightforward, mostly.

The way I see it, your series should look something like this:
1) A prep patch that moves dm-kcopyd to the block layer, changing the API n=
ames
and converting all DM driver users to the new API. This may be a very large
patch though, so splitting it into multiple peaces may be required to facil=
itate
review.
2) A prep patch that introduces queue flags for devices to advertize their
support for simple copy and a generic api for simple copy BIOs
3) A patch that adds the use of simple copy BIO into the moved dm-kcopyd co=
de
4) The NVMe driver bits that probably will look like what you have now

With this, all DM drivers that currently use dm-kcopyd (RAID and dm-zoned a=
t
least) will get free offload using simple copy commands for sector copies w=
ithin
the same device. All other copy cases will still work as per kcopyd code. T=
hat
is very neat I think.

And you can add one more patch that use this generic copy block interface t=
o
implement copy_file_range for raw block devices as Darrick suggested.


[...]
>>> +static ssize_t queue_copy_offload_store(struct request_queue *q,
>>> +                                    const char *page, size_t count)
>>> +{
>>> +     unsigned long copy_offload;
>>> +     ssize_t ret =3D queue_var_store(&copy_offload, page, count);
>>> +
>>> +     if (ret < 0)
>>> +             return ret;
>>> +
>>> +     if (copy_offload < 0 || copy_offload > 1)
>>
>> err... "copy_offload !=3D 1" ?
>=20
> Initial thought was to keep it either 0 or 1.  I'll change it to 0 or els=
e.

If you use 0 and 1, then make copy_offload a bool. That is more natural giv=
en
the variable name.

[...]
>>> +static int blk_ioctl_copy(struct block_device *bdev, fmode_t mode,
>>> +             unsigned long arg)
>>> +{
>>> +     struct copy_range crange;
>>> +     struct range_entry *rlist;
>>> +     struct request_queue *q =3D bdev_get_queue(bdev);
>>> +     sector_t dest;
>>> +     int ret;
>>> +
>>> +     if (!(mode & FMODE_WRITE))
>>> +             return -EBADF;
>>> +
>>> +     if (!blk_queue_copy(q))
>>> +             return -EOPNOTSUPP;
>>
>> But you added the read-write emulation. So what is the point here ? This=
 ioctl
>> should work for any device, with or without simple copy support. Did you=
 test that ?
>>
>=20
> Sorry. It was a mistake. Will fix this.

Please make sure to test to catch such mistakes before sending. It does sou=
nd
like your read-write manual copy has not been tested.


--=20
Damien Le Moal
Western Digital Research



--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

