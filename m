Return-Path: <SRS0=jAWR=FP=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB9FBC4361B
	for <dm-devel@archiver.kernel.org>; Fri, 11 Dec 2020 16:26:25 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 227EA23EB3
	for <dm-devel@archiver.kernel.org>; Fri, 11 Dec 2020 16:26:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 227EA23EB3
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-161-yNnLhJUnNvKJTIWO8rAutw-1; Fri, 11 Dec 2020 11:26:21 -0500
X-MC-Unique: yNnLhJUnNvKJTIWO8rAutw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5ED3E107565A;
	Fri, 11 Dec 2020 16:26:15 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 155D610013C0;
	Fri, 11 Dec 2020 16:26:14 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id E44FA4E58F;
	Fri, 11 Dec 2020 16:26:11 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BBGQ91k016770 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 11 Dec 2020 11:26:09 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 4701C2026D3F; Fri, 11 Dec 2020 16:26:09 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 416A22026D12
	for <dm-devel@redhat.com>; Fri, 11 Dec 2020 16:26:04 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C4685811E85
	for <dm-devel@redhat.com>; Fri, 11 Dec 2020 16:26:04 +0000 (UTC)
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-125-wtFVNGjAO6KRYQn_Y_FCyA-1; Fri, 11 Dec 2020 11:26:02 -0500
X-MC-Unique: wtFVNGjAO6KRYQn_Y_FCyA-1
IronPort-SDR: 3KFJbNYFL8JmzKKepNliLy4A9LmIeAaXx/Y0Xr3GF+GVUEk76BG9X0ex2Cs3RYbAPBPfcO/DAh
	wxxtTdFc1CSFkDhMaxtJPbtzJJCJ6oo3jfEq8iYkmJcelAmE+l4sN3hTGPZZ58f+OxBik6Qyrj
	tE3WkUkvYcDAKUVCCoz/tqmuoawmvfDmg7zvw/idgCe1UCZcCXp5RimGLiePVUAL35nOo68ksu
	oSrZlRaWuWAQDKGdb5g5MmMgmNUStrzF348M+XHQ0YtICIyI5JbaWyVH7vyo4+Pvlm1CKHGQ9c
	4K8=
X-IronPort-AV: E=Sophos;i="5.78,411,1599494400"; d="scan'208";a="258685781"
Received: from mail-bl2nam02lp2056.outbound.protection.outlook.com (HELO
	NAM02-BL2-obe.outbound.protection.outlook.com) ([104.47.38.56])
	by ob1.hgst.iphmx.com with ESMTP; 12 Dec 2020 00:28:01 +0800
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
	(2603:10b6:803:47::21) by SN2PR04MB2143.namprd04.prod.outlook.com
	(2603:10b6:804:e::25) with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12;
	Fri, 11 Dec 2020 16:25:57 +0000
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
	([fe80::65d7:592a:32d4:9f98]) by
	SN4PR0401MB3598.namprd04.prod.outlook.com
	([fe80::65d7:592a:32d4:9f98%6]) with mapi id 15.20.3589.038;
	Fri, 11 Dec 2020 16:25:57 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: SelvaKumar S <selvakuma.s1@samsung.com>, "linux-nvme@lists.infradead.org"
	<linux-nvme@lists.infradead.org>
Thread-Topic: [RFC PATCH v3 1/2] block: add simple copy support
Thread-Index: AQHWz83y7bUu+jQhLUujuAOdfzAPcw==
Date: Fri, 11 Dec 2020 16:25:57 +0000
Message-ID: <SN4PR0401MB359867B95139ACD1ACFF0E709BCA0@SN4PR0401MB3598.namprd04.prod.outlook.com>
References: <20201211135139.49232-1-selvakuma.s1@samsung.com>
	<CGME20201211135200epcas5p217eaa00b35a59b3468c198d85309fd7d@epcas5p2.samsung.com>
	<20201211135139.49232-2-selvakuma.s1@samsung.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [129.253.240.72]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 350dcab8-f7d2-4aef-4f64-08d89df170a1
x-ms-traffictypediagnostic: SN2PR04MB2143:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN2PR04MB21439BAF7E03A5EE175205B59BCA0@SN2PR04MB2143.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:6430
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: 0/z9C2lKihgmLqDmO0DBr1PGZyf00HH7Ob61BT6gRF43tEFb/ZsGSQcXGJ93yhS1JWh12J6Y8WIOL1CEdH9F0Of+l6NCqGJVQj1bYipHxfltEK/1vJmSGobAboNiu/VP2FiezXjeppSwVNmHhIWM2iknZ/u6neQ6oUyADEXq++EKDqqZlV/bOpEudkP5bavTPDyWGjVVzZzU9Lf1HVe1Su9Oq9o+4UkCT3aoSUmKp47J3V+hs5HWEkn11RbvTizEVJQjWUMfpURqBdqZZp5ItHO/dHR6jKSP6HpjkSOSm45LU1hpZ8vTHoowt9jYdNCZ
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:SN4PR0401MB3598.namprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(346002)(136003)(376002)(366004)(2906002)(76116006)(66476007)(64756008)(186003)(66446008)(71200400001)(110136005)(53546011)(7416002)(33656002)(55016002)(52536014)(8676002)(66946007)(8936002)(86362001)(7696005)(83380400001)(66556008)(9686003)(4326008)(91956017)(508600001)(54906003)(26005)(6506007)(5660300002);
	DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?o/8mc+OP6SxgDy2SY29553XGgMWUazCqlMZ/q7HEJN0FxceCRvbYOLZ3Tanu?=
	=?us-ascii?Q?/A/4I8KgrP67ni/BwPHFOOA+2Wtim9bhg84QAfq1oXKfHYsMmKtQjzffjVu2?=
	=?us-ascii?Q?lEqs1wwEBB59nFJlKHpBrAm6JBUN6GinBc2wWpi+6LLXO3M+ovivARgVctqm?=
	=?us-ascii?Q?Tka24Jjx0EA7eULiMDgJyeizzxnYmjLggBkkoER7Gho3rfQBkny1MRDSVuUJ?=
	=?us-ascii?Q?KtGr5658jfXz5Rse9wktl4L3gHtXpiHS3AypJKuDFjE2AHRkz54u201GtKvN?=
	=?us-ascii?Q?uzjxkZLAn9AHU7usg89Gev2sb2sYaSGB5jsixjknObyE9EyofhrWj0wcbEud?=
	=?us-ascii?Q?jIEm7rZO+3UqI6kLBgIRwoktzilB1ZuDsoDObX3436vLScDyu1hCLWlhzY1u?=
	=?us-ascii?Q?EtE51lgejkbncUGvnZus718YG81NGL9ylXx1R3Lget+a9wOoiOIZMy+2sF4V?=
	=?us-ascii?Q?KyeTLQG0Ilpz4XuO84883FURUKJBl+3u/2pT8d8nouMrNFJQFTknXsxnXv5H?=
	=?us-ascii?Q?EAzvfpPyZXSiqUZgDXuSACA/XfSQ9LDlte73tXDEd/945NKQMC9EeQxbluP7?=
	=?us-ascii?Q?0lp3UhWASumQMmCrsFWlzAnglQICpfBE7+JUrG5GmlH9B5yKsYA9Pi+yywlK?=
	=?us-ascii?Q?gRJbo1Aa4icr3QB4Dt2hnxzgLggw/zXPC2YS8vS2OPROe9ggBMe+Z8/0r6DS?=
	=?us-ascii?Q?OEjfZ+/HKaYHIBIOaI1DX9LVPchVZIJZgnV+TqN1yAqvLsxcO7mKVjB9O/4s?=
	=?us-ascii?Q?zEBuC7dP/Rv8SZXhZERznY8HzqdeuYyPBFenWz/vmaeuzKBzWWWtYFrJSdj2?=
	=?us-ascii?Q?rpvPkQLXc0a5NwUXlqM66MxJRBSB5OVYRhChA2ncFA55DlvVc6I1+xFUpBsI?=
	=?us-ascii?Q?qOoRvIteb6KCNVCL25ohU1lXc+skO7wPSgA/15LS55UcQs91YaiFmNtGVNr1?=
	=?us-ascii?Q?r9Q4o1gQxa2iDEBO/5Q8NW40wCr/uNZAA2TRdmNF+bavxG0+9r0TFVfC80Cn?=
	=?us-ascii?Q?Wl3R?=
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN4PR0401MB3598.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 350dcab8-f7d2-4aef-4f64-08d89df170a1
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Dec 2020 16:25:57.3695 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: djyFGdR9AjKUyY8KLcZJgBfxKBS+dY9MYgddnJvK575qF22vOpzJ26qaDm+jl3oxtgEGEWDkuazNWm9hj4Faqg2nvJo7nYsgbgksG/0Yd9Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN2PR04MB2143
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 0BBGQ91k016770
X-loop: dm-devel@redhat.com
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, Damien Le Moal <Damien.LeMoal@wdc.com>,
	"sagi@grimberg.me" <sagi@grimberg.me>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"selvajove@gmail.com" <selvajove@gmail.com>,
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
Subject: Re: [dm-devel] [RFC PATCH v3 1/2] block: add simple copy support
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 11/12/2020 15:57, SelvaKumar S wrote:
[...] 
> +int blk_copy_emulate(struct block_device *bdev, struct blk_copy_payload *payload,
> +		gfp_t gfp_mask)
> +{
> +	struct request_queue *q = bdev_get_queue(bdev);
> +	struct bio *bio;
> +	void *buf = NULL;
> +	int i, nr_srcs, max_range_len, ret, cur_dest, cur_size;
> +
> +	nr_srcs = payload->copy_range;
> +	max_range_len = q->limits.max_copy_range_sectors << SECTOR_SHIFT;
> +	cur_dest = payload->dest;
> +	buf = kvmalloc(max_range_len, GFP_ATOMIC);

Why GFP_ATOMIC and not the passed in gfp_mask? Especially as this is a kvmalloc()
which has the potential to grow quite big.

> +int __blkdev_issue_copy(struct block_device *bdev, sector_t dest,
> +		sector_t nr_srcs, struct range_entry *rlist, gfp_t gfp_mask,
> +		int flags, struct bio **biop)
> +{

[...]

> +	total_size = struct_size(payload, range, nr_srcs);
> +	payload = kmalloc(total_size, GFP_ATOMIC | __GFP_NOWARN);

Same here. 


> diff --git a/block/ioctl.c b/block/ioctl.c
> index 6b785181344f..a4a507d85e56 100644
> --- a/block/ioctl.c
> +++ b/block/ioctl.c
> @@ -142,6 +142,47 @@ static int blk_ioctl_discard(struct block_device *bdev, fmode_t mode,
>  				    GFP_KERNEL, flags);
>  }
>  
> +static int blk_ioctl_copy(struct block_device *bdev, fmode_t mode,
> +		unsigned long arg, unsigned long flags)
> +{

[...]

> +
> +	rlist = kmalloc_array(crange.nr_range, sizeof(*rlist),
> +			GFP_ATOMIC | __GFP_NOWARN);

And here. I think this one can even be GFP_KERNEL.

 




--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

