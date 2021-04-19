Return-Path: <SRS0=qgW3=JQ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9B2FC433ED
	for <dm-devel@archiver.kernel.org>; Mon, 19 Apr 2021 13:02:37 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 64A836113C
	for <dm-devel@archiver.kernel.org>; Mon, 19 Apr 2021 13:02:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 64A836113C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-392-zTFu0xtQOpOcqYL02lCdTA-1; Mon, 19 Apr 2021 09:02:33 -0400
X-MC-Unique: zTFu0xtQOpOcqYL02lCdTA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9CD7F79EC2;
	Mon, 19 Apr 2021 13:02:29 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2E900610F1;
	Mon, 19 Apr 2021 13:02:29 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 0C9231806D17;
	Mon, 19 Apr 2021 13:02:28 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 13JD2PxK023745 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 19 Apr 2021 09:02:26 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id CFD994368B; Mon, 19 Apr 2021 13:02:25 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C8C4543686
	for <dm-devel@redhat.com>; Mon, 19 Apr 2021 13:02:23 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 54A0985A5BA
	for <dm-devel@redhat.com>; Mon, 19 Apr 2021 13:02:23 +0000 (UTC)
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-165-umfxQvGhMnCPYv9W1eSdEA-1; Mon, 19 Apr 2021 09:02:18 -0400
X-MC-Unique: umfxQvGhMnCPYv9W1eSdEA-1
IronPort-SDR: xqNcnZx1ZhrN+1NAKilfediZFlV5NiWhPTYVkmuEWjlDOoMtP08cwPMaGWmpEgaMuGUyzPIsG+
	jUOmD1VhuBGp27+ZNJgxSB4pvQ0g7AHy8sV2NV4yOoijs4UYRBwCvEGp5OQ7j7w9K8ttVAjWbA
	QkrgEXC5jZhCR80RfJuyME+/m4iFtqd5P0iANFqvxnHzhk4FO8WEbofUDviOQ6oHxUnfwPu9Ft
	hDq8gZyDdIvclATsejykKOLdIPDZJ4FnSK7skV3EfZozIk+BeIv3KqZHmqhTLim4UqLpJKYTjW
	kp8=
X-IronPort-AV: E=Sophos;i="5.82,234,1613404800"; d="scan'208";a="169974056"
Received: from mail-bn7nam10lp2100.outbound.protection.outlook.com (HELO
	NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.100])
	by ob1.hgst.iphmx.com with ESMTP; 19 Apr 2021 21:02:15 +0800
Received: from BL0PR04MB6514.namprd04.prod.outlook.com (2603:10b6:208:1ca::23)
	by BL0PR04MB5059.namprd04.prod.outlook.com (2603:10b6:208:54::29)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.19;
	Mon, 19 Apr 2021 13:02:12 +0000
Received: from BL0PR04MB6514.namprd04.prod.outlook.com
	([fe80::8557:ab07:8b6b:da78]) by
	BL0PR04MB6514.namprd04.prod.outlook.com
	([fe80::8557:ab07:8b6b:da78%3]) with mapi id 15.20.4042.024;
	Mon, 19 Apr 2021 13:02:12 +0000
From: Damien Le Moal <Damien.LeMoal@wdc.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Thread-Topic: [dm-devel] [PATCH v2 0/3] Fix dm-crypt zoned block device support
Thread-Index: AQHXMzIMIWm8p8e930y0CZBnJXiLwQ==
Date: Mon, 19 Apr 2021 13:02:11 +0000
Message-ID: <BL0PR04MB65147D94E7E30C3E1063A282E7499@BL0PR04MB6514.namprd04.prod.outlook.com>
References: <20210417023323.852530-1-damien.lemoal@wdc.com>
	<alpine.LRH.2.02.2104190840310.9677@file01.intranet.prod.int.rdu2.redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2400:2411:43c0:6000:d019:11b6:a627:87d8]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ff83eae9-22da-4d86-49bc-08d9033358f1
x-ms-traffictypediagnostic: BL0PR04MB5059:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BL0PR04MB5059115DD2989DC5D1C603E1E7499@BL0PR04MB5059.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:10000
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: SLHAkeTYE0P0uo1U/rYH8iSdgehgTg/sFkMgpBvjhSFCP1l1tj7W39a9KUtJgcw/Sfb1uVXr30DNPj1yKdawH69GL6CU3Xs67IEojj9ISP1IIhVrW2IfGRlq+S9AN02+ezuMq+2t35h4hhjz5ukFqdh1xZlRh6h+0uQLi7x2DhQdE9zDGyoIWAjQT1N/carpjoIiJzzH+VHwHRmH2LhzNXvvFxTNeSVxiQF8rPrK0y/ndmw1pKtEqQsmQHyv6wkwXPjgtAoIX7/5QruTKc/CtI6ARGobRM5DT2vM+vg49GLEuDg5cj6KOxxVeA6bjEl+/gBJMhG+tHu6FC6oBLEUULrLMHaEfK997x75KD1wWFITB3nOvU0lCclVg3/JkpU4AA3C+aOsYFgJDnOk2eUShXLHl2ks450Ksch6T81Do7zGQj7yp+IyXPT+ZDgRN27XO1U7cWZIAbQ88DaaTUofmT+vM5nzUwnZCTiGTuHHVCLdrYnMl4pUQGK0N+qopoU7IXuqrtMo7q8U7ilwoqLYVnpMdsG1LlVM43qPVDM3OY6WzEFc57I/+eNonLMYYyKA5qlM/wq/YVZe512XKsGBAyKs6dbs4DXBJ1ELF3+rCsU=
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:BL0PR04MB6514.namprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(376002)(346002)(136003)(39860400002)(366004)(396003)(8676002)(64756008)(55016002)(66946007)(52536014)(71200400001)(66446008)(9686003)(86362001)(66556008)(122000001)(54906003)(6916009)(316002)(66476007)(33656002)(478600001)(5660300002)(8936002)(91956017)(38100700002)(76116006)(4326008)(7696005)(7416002)(6506007)(53546011)(186003)(2906002)(83380400001);
	DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?j9TpK8qi93hXUy7xagj8wmKl6ChndPsz9D/LbdK43dE74uTGpGzqy//kBxiK?=
	=?us-ascii?Q?MuFsoV/OPUvzJiN75kJ8IvaF4b14cBDGzxIQ0BVmN7qdfFct3uUDzTkpCAHI?=
	=?us-ascii?Q?/QqYyOZtHEU+vR70kte5xhBi0NKH8BWEr9OTLnLvWlLuCdqmykb89fivPmmX?=
	=?us-ascii?Q?BWQHnJ3ATWswfgRqTAsh63gTZwg1bMahLUFWa34cX3QRk1Q0nMgaCseHBWU7?=
	=?us-ascii?Q?ZCTE2MUoL4Qfm/xyPUUet52Lmievw07WZa0cka/tiiWWpYAgnF5aAhhYw6WQ?=
	=?us-ascii?Q?T2YXIbpUoaWCFezyTYnlvsUJ6sUHmkosItPRleO/dtOd0rA0UoZl/eozndwG?=
	=?us-ascii?Q?Uc7W7Mc7gLfomR10aFYsN9ksl9EadgKPqckmtzcNM6WiPhxV5xOyA0lWqekU?=
	=?us-ascii?Q?x5rBoEs9O/MYfUnYIal2CxsCABzCNSzO1SNJK9tj878/XQaFRhfIuAs2EN7I?=
	=?us-ascii?Q?i8Zow/thZBm4JMqRwysYnml260g5W9g1YiVH/NVqlpgu56o72ftdhouIYWvD?=
	=?us-ascii?Q?XyxVKNuvMLe6kFfySIahhXi4jtG1r6+/F4YR9e+LinhDH+tBYciXLC6l/TAk?=
	=?us-ascii?Q?naeT96hUQcW+Gjkdcz1Xxqjj4dsp31DS+s+8HTCg909eQM2rmtJit1VwTFBq?=
	=?us-ascii?Q?klFlbrVk5WoffdK3/o5q8h5GJd9gmztkiUiNdPE7iIoZRCrJJ3pTKhVDykLw?=
	=?us-ascii?Q?7jiWeozPmCoUa7rHTF7cWnDMwGs6fP8A5y003TIm3+lo6A0dm+F93fyVFmBe?=
	=?us-ascii?Q?PdTYO83Z9CpozSd87itMDghN/IyGXlBGLQtnLzO+zntJU2AaDMozfBflfIKj?=
	=?us-ascii?Q?j4iyqNZ0TaLMdgsWSjjqgJKmGcl3toqvClW1E04A2u2REtcuQpPc/Rx4JEn5?=
	=?us-ascii?Q?QJ1C3+t+/s1UBt4TTwP3faaEfoGyq2riTmYQT8utlsdkwijV66wnfmiOqdZS?=
	=?us-ascii?Q?FevaafR9GrgD8fHayWoLNUkNQSvEHrxuZPsBAq4Sk0OAFl/SLV9eYQBOYUsc?=
	=?us-ascii?Q?8C/mj9wlq47+yj8ton2vsDgdlHaeD1mEiPIkAxjdLQyu6locaZYrMgaaO82c?=
	=?us-ascii?Q?RJmwLK2+EVevHmnKr2Er8ZGPWSnU7j/RiZekR26XMePoZik0m0kJuG8S3kvg?=
	=?us-ascii?Q?BGS/hOzrvNFBtk0+7dDcGTlicOHCXl2boLHPiKZKXmUGb8i4GN9mK35FUVip?=
	=?us-ascii?Q?b3wtfk0RIRzHqrnzJv69+QcNv2VjBtT7Y6Ex1bjLzUkc7ETGnKlLYqpDCyfp?=
	=?us-ascii?Q?qtHSc/vjO1bkaC0fdw9TVx83yAJD4WETepu1/wHhRSleaXWMIOPeUsvzssG9?=
	=?us-ascii?Q?mcAouGJhdU+q4sSJHs6nr2tSXV4bvPik5Sluk0DEFhDtE8WtZRtB4MhVGpGY?=
	=?us-ascii?Q?qZ5wuiRSuFK/4tHaWYl0Y27QMiZOF9yD7NUATXNQV1kyoLjF1w=3D=3D?=
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR04MB6514.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ff83eae9-22da-4d86-49bc-08d9033358f1
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Apr 2021 13:02:11.8894 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GbIpHg7w9ScOXSYD0TxBTIArKUGC9rYLMkyxOMERoZ91nKQ3az01MHoWhy1CkMeVL2A/aCWYT20jgSau4jiJbQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR04MB5059
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 13JD2PxK023745
X-loop: dm-devel@redhat.com
Cc: Jens Axboe <axboe@kernel.dk>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	Mike Snitzer <snitzer@redhat.com>, Christoph,
	Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	Hellwig <hch@lst.de>
Subject: Re: [dm-devel] [PATCH v2 0/3] Fix dm-crypt zoned block device
	support
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 2021/04/19 21:52, Mikulas Patocka wrote:
> 
> 
> On Sat, 17 Apr 2021, Damien Le Moal wrote:
> 
>> Mike,
>>
>> Zone append BIOs (REQ_OP_ZONE_APPEND) always specify the start sector
>> of the zone to be written instead of the actual location sector to
>> write. The write location is determined by the device and returned to
>> the host upon completion of the operation.
> 
> I'd like to ask what's the reason for this semantics? Why can't users of 
> the zoned device supply real sector numbers?

They can, if they use regular write commands :)

Zone append was designed to address sequential write ordering difficulties on
the host. Unlike regular writes which must be delivered to the device in
sequential order, zone append commands can be sent to the device in any order.
The device will process the write at the WP position when the command is
executed and return the first sector written. This command makes it easy on the
host in multi-queue environment and avoids the need for serializing commands &
locking zones for writing. So very efficient performance.

>> This interface, while simple and efficient for writing into sequential
>> zones of a zoned block device, is incompatible with the use of sector
>> values to calculate a cypher block IV. All data written in a zone is
>> encrypted using an IV calculated from the first sectors of the zone,
>> but read operation will specify any sector within the zone, resulting
>> in an IV mismatch between encryption and decryption. Reads fail in that
>> case.
> 
> I would say that it is incompatible with all dm targets - even the linear 
> target is changing the sector number and so it may redirect the write 
> outside of the range specified in dm-table and cause corruption.

DM remapping of BIO sectors is zone compatible because target entries must be
zone aligned. In the case of zone append, the BIO sector always point to the
start sector of the target zone. DM sector remapping will remap that to another
zone start as all zones are the same size. No issue here. We extensively use
dm-linear for various test environment to reduce the size of the device tested
(to speed up tests). I am confident there are no problems there.

> Instead of complicating device mapper with imperfect support, I would just 
> disable REQ_OP_ZONE_APPEND on device mapper at all.

That was my initial approach, but for dm-crypt only since other targets that
support zoned devices are fine. However, this breaks zoned block device
requirement that zone append be supported so that users are presented with a
uniform interface for different devices. So while simple to do, disabling zone
append is far from ideal.

> 
> Mikulas
> 
> 


-- 
Damien Le Moal
Western Digital Research



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

