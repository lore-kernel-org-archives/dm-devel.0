Return-Path: <SRS0=ZVdP=FM=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4901DC4361B
	for <dm-devel@archiver.kernel.org>; Tue,  8 Dec 2020 13:26:17 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C02AA23AA8
	for <dm-devel@archiver.kernel.org>; Tue,  8 Dec 2020 13:26:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C02AA23AA8
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-384-k9wIxfUEOWSiPUfI3NW0vw-1; Tue, 08 Dec 2020 08:26:13 -0500
X-MC-Unique: k9wIxfUEOWSiPUfI3NW0vw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DFC7510054FF;
	Tue,  8 Dec 2020 13:26:08 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7823850C0A;
	Tue,  8 Dec 2020 13:26:08 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 1295D4BB7B;
	Tue,  8 Dec 2020 13:26:06 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0B8DOpJD017263 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 8 Dec 2020 08:24:52 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id AC43F1004140; Tue,  8 Dec 2020 13:24:51 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A7A25110F0B0
	for <dm-devel@redhat.com>; Tue,  8 Dec 2020 13:24:49 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4B4EE100FBC5
	for <dm-devel@redhat.com>; Tue,  8 Dec 2020 13:24:49 +0000 (UTC)
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-414-BTH-_qErPdGkTZMGlD8atw-1; Tue, 08 Dec 2020 08:24:45 -0500
X-MC-Unique: BTH-_qErPdGkTZMGlD8atw-1
IronPort-SDR: fb+bTgp3khtlTJU1k780w0Mgb/LQlDHmka4017BhxJFw++OKZJvthnX3hi35EvE37Ww4vCURIk
	ldJ+oghszShiUxAMnk/9gD1bTbir/laQpoFEeu+MJgmDH4fNY/OtH2NKrIjYQJDxX8YzQpJG/P
	u5ZnRV9fFWMc4s2BPPdDe0QHlLH6+F8DQaXCJ8es439dbikk9fEP1o9PGARNC1rrNsiUAmeDAv
	o50JQ1l/s+SWUON1XqsYT35E11+uhqdXxnFVgu8zbHngMxTQ3jakD8Ywk1l7Ud5dZXUIpBXh6E
	QLk=
X-IronPort-AV: E=Sophos;i="5.78,402,1599494400"; d="scan'208";a="258402624"
Received: from mail-dm6nam11lp2176.outbound.protection.outlook.com (HELO
	NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.176])
	by ob1.hgst.iphmx.com with ESMTP; 08 Dec 2020 21:39:27 +0800
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
	(2603:10b6:803:47::21) by SN4PR0401MB3597.namprd04.prod.outlook.com
	(2603:10b6:803:45::18) with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.23;
	Tue, 8 Dec 2020 13:24:40 +0000
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
	([fe80::65d7:592a:32d4:9f98]) by
	SN4PR0401MB3598.namprd04.prod.outlook.com
	([fe80::65d7:592a:32d4:9f98%6]) with mapi id 15.20.3589.038;
	Tue, 8 Dec 2020 13:24:40 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: =?iso-8859-1?Q?Javier_Gonz=E1lez?= <javier@javigon.com>
Thread-Topic: [RFC PATCH v2 0/2] add simple copy support
Thread-Index: AQHWyi08xMuKL73ZZUaIarInYKlQvg==
Date: Tue, 8 Dec 2020 13:24:40 +0000
Message-ID: <SN4PR0401MB3598226CD4A32F65320A47379BCD0@SN4PR0401MB3598.namprd04.prod.outlook.com>
References: <CGME20201204094719epcas5p23b3c41223897de3840f92ae3c229cda5@epcas5p2.samsung.com>
	<20201204094659.12732-1-selvakuma.s1@samsung.com>
	<20201207141123.GC31159@lst.de>
	<01fe46ac-16a5-d4db-f23d-07a03d3935f3@suse.de>
	<20201207192453.vc6clbdhz73hzs7l@mpHalley>
	<SN4PR0401MB35988951265391511EBC8C6E9BCD0@SN4PR0401MB3598.namprd04.prod.outlook.com>
	<20201208122248.utv7pqthmmn6uwv6@mpHalley>
	<SN4PR0401MB35983464199FB173FB0C29479BCD0@SN4PR0401MB3598.namprd04.prod.outlook.com>
	<20201208131333.xoxincxcnh7iz33z@mpHalley>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [129.253.240.72]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 10798663-c440-4025-bf1f-08d89b7c9e17
x-ms-traffictypediagnostic: SN4PR0401MB3597:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN4PR0401MB359773CB1B0034B8931C20259BCD0@SN4PR0401MB3597.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:9508
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: c2PLqFM/Jm3mCxGb2iAJ7P19oC1TfnGtmHWbypWEN+5MAmxBp6MUaFBPZEWCiz83phD63b1ZEfDMFBl/GUuH4Yc/qP679K0sjaSstvrMoO++72CDWxYtyxx9pR5FUZdHBmWPes5q8Nsj+e/leZqleUMvh68xOjDc74HgGR7+CgJbYtF6E+kWcFr8OgxaOR2eJ7jAjh8uY+sQvrDkOZL/060Btx9kKdmTUedrr3W5gTiKPFB7YWh2NW9sreYsjB0eXehJjuZ12XmaUPyAcgcVXARyOuXx5EjTXClmK77hWA2zgvDceo0tEyy6vBETI4exDFnXfy6QYe3Lgxldvu+Jww==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:SN4PR0401MB3598.namprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(346002)(136003)(376002)(366004)(4326008)(66476007)(91956017)(55016002)(7696005)(508600001)(64756008)(76116006)(9686003)(66556008)(5660300002)(8676002)(2906002)(8936002)(66946007)(86362001)(7416002)(6916009)(33656002)(52536014)(83380400001)(6506007)(66446008)(26005)(186003)(54906003)(71200400001)(53546011);
	DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata: =?iso-8859-1?Q?JDlF4xjuWz48JgWAeT6R0gHSc7vBPMAYX1Iifak8svrQTF6ofyjwSm2wkI?=
	=?iso-8859-1?Q?Mz0cs2yYeB0KCe09bK820AXPs7Hy40YqUbdTgey+9J7je9JmqLHn8XszFb?=
	=?iso-8859-1?Q?/erzT/UwTxwzOAfOAY4vRXzfu7ISE/T+B4M0iZHy9beR7WSo/02VQBykNG?=
	=?iso-8859-1?Q?6KV3q20i6fLDg33m0/hAVxjgGpROd4+DF7y4/pbbfOByf5bdpilz7YQoRg?=
	=?iso-8859-1?Q?GP3V4duYTmePyrtmJVx3Si4NsFTAuM6M4o1TqMbWq8vlDYz0cshY62HDbc?=
	=?iso-8859-1?Q?f3IXmOgA7Fiq253lCmzw5Vvinfu1TWpXGP36Hb1jBXRD9aBZD6/MQDbM5Z?=
	=?iso-8859-1?Q?P4wmzjrItBGKyqtPWDWGGiSRZkVgJ1vSwvQE13xusCl2Qoo9pq9b+nz540?=
	=?iso-8859-1?Q?6JettY9PtPX82eF1ABNyDNAQ2+WEEyoqX9fnuQw4xg4gfGaS4rO3TpAD/K?=
	=?iso-8859-1?Q?z8gZO72Waj+Z4mQSXN4f9170MdAlvtfii5YvB3Qxc5V1nri/vkCKqxal6P?=
	=?iso-8859-1?Q?CcLafYQbKQ+qHw0ANyMBr/4KZooFeRd5UyxqYqxM0txlNnEOSwfNYVgD7t?=
	=?iso-8859-1?Q?5IbdWISg1yLsrkTvoUp1f3iXsLvrS7PvwFlQx/bnRao7iEybm2SejxV7jm?=
	=?iso-8859-1?Q?IbTKquTCV9gFV+fk6wKW8ZZI407u8uz1RHzd0qQafc398ehZyLQFaJPnk7?=
	=?iso-8859-1?Q?xs2uQkImVox93YhcqSycbRmsLh4iihZL+VXhAGvllaDyTHdcNkS4hJRC2v?=
	=?iso-8859-1?Q?qa7dWBqJm0s10o3Ui0YQucKhNfoOp30+p4r6j+dI+lYL/z2ibJrhWk5wNp?=
	=?iso-8859-1?Q?VcQTHMBKICQ3+bJVYWZ2nGOk4BOdbR1+HcSXCHugdSirTNHJPdRvyJiMNe?=
	=?iso-8859-1?Q?oWEf1B69VFcGGXb6Qtl/Gd43C1Bg49WUUpv2js2siRdi4U0lmI7NUOm2qX?=
	=?iso-8859-1?Q?o5mncb7KTsliZ2XElNAoHd9XtP1XDBLZLu97maJWfjxj8tWJJfVmq5MBUj?=
	=?iso-8859-1?Q?z9bYGqfeHbpMihUHPC8U7n0wiBfMeOhyUy8LSc?=
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN4PR0401MB3598.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 10798663-c440-4025-bf1f-08d89b7c9e17
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Dec 2020 13:24:40.2752 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TdRTaI6g/b3dVS9wANrGo3W7hTOb+JWw3Q4aOh4P33V5HBLvSx8iQjqjszszzV2ySMtCA/ZyEc4qJlvQIy9LCV13i3bMKVgmpTb/1WWbe+E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR0401MB3597
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 0B8DOpJD017263
X-loop: dm-devel@redhat.com
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, Damien Le Moal <Damien.LeMoal@wdc.com>,
	S <selvakuma.s1@samsung.com>, "sagi@grimberg.me" <sagi@grimberg.me>,
	"snitzer@redhat.com" <snitzer@redhat.com>, SelvaKumar,
	"selvajove@gmail.com" <selvajove@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	"nj.shetty@samsung.com" <nj.shetty@samsung.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>, Patocka <mpatocka@redhat.com>,
	"joshi.k@samsung.com" <joshi.k@samsung.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	"kbusch@kernel.org" <kbusch@kernel.org>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	Christoph Hellwig <hch@lst.de>, Mikulas,
	Bart Van Assche <bvanassche@acm.org>
Subject: Re: [dm-devel] [RFC PATCH v2 0/2] add simple copy support
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On 08/12/2020 14:13, Javier Gonz=E1lez wrote:
> On 08.12.2020 12:37, Johannes Thumshirn wrote:
>> On 08/12/2020 13:22, Javier Gonz=E1lez wrote:
>>> Good idea. Are you thinking of a sysfs entry to select the backend?
>>
>> Not sure on this one, initially I thought of a sysfs file, but then
>> how would you do it. One "global" sysfs entry is probably a bad idea.
>> Having one per block device to select native vs emulation maybe? And
>> a good way to benchmark.
>=20
> I was thinking a per block device to target the use case where a certain
> implementation / workload is better one way or the other.

Yes something along those lines.

>>
>> The other idea would be a benchmark loop on boot like the raid library
>> does.
>>
>> Then on the other hand, there might be workloads that run faster with
>> the emulation and some that run faster with the hardware acceleration.
>>
>> I think these points are the reason the last attempts got stuck.
>=20
> Yes. I believe that any benchmark we run would be biased in a certain
> way. If we can move forward with a sysfs entry and default to legacy
> path, we would not alter current behavior and enable NVMe copy offload
> (for now) for those that want to use it. We can then build on top of it.
>=20
> Does this sound like a reasonable approach?
>=20

Yes this sounds like a reasonable approach to me.



--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

