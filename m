Return-Path: <SRS0=qylv=OV=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 076ABC433F5
	for <dm-devel@archiver.kernel.org>; Fri,  1 Oct 2021 06:25:08 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 4C8D061A57
	for <dm-devel@archiver.kernel.org>; Fri,  1 Oct 2021 06:25:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 4C8D061A57
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=nvidia.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-561-aEx4lc16M32dWPuavI2miw-1; Fri, 01 Oct 2021 02:25:03 -0400
X-MC-Unique: aEx4lc16M32dWPuavI2miw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1711319251A2;
	Fri,  1 Oct 2021 06:24:59 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7AD8A5DD86;
	Fri,  1 Oct 2021 06:24:58 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 60D5F4E590;
	Fri,  1 Oct 2021 06:24:55 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 18U9hT2Y010836 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 30 Sep 2021 05:43:29 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 50BE4D29D0; Thu, 30 Sep 2021 09:43:29 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 48F03D74D9
	for <dm-devel@redhat.com>; Thu, 30 Sep 2021 09:43:21 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EC29D185A7A4
	for <dm-devel@redhat.com>; Thu, 30 Sep 2021 09:43:20 +0000 (UTC)
Received: from NAM11-DM6-obe.outbound.protection.outlook.com
	(mail-dm6nam11on2050.outbound.protection.outlook.com [40.107.223.50])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-496-RXejkpf8PzaHTuW7Atowdw-1; Thu, 30 Sep 2021 05:43:15 -0400
X-MC-Unique: RXejkpf8PzaHTuW7Atowdw-1
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
	by MW2PR12MB2442.namprd12.prod.outlook.com (2603:10b6:907:4::23) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.15;
	Thu, 30 Sep 2021 09:43:11 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
	([fe80::3db1:105d:2524:524]) by MW2PR12MB4667.namprd12.prod.outlook.com
	([fe80::3db1:105d:2524:524%7]) with mapi id 15.20.4566.014;
	Thu, 30 Sep 2021 09:43:11 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: =?utf-8?B?SmF2aWVyIEdvbnrDoWxleg==?= <javier.gonz@samsung.com>, Johannes
	Thumshirn <Johannes.Thumshirn@wdc.com>
Thread-Topic: [LSF/MM/BFP ATTEND] [LSF/MM/BFP TOPIC] Storage: Copy Offload
Thread-Index: AQHXtJz3aovD145e60qqb0tlGftm/6u8Ve+A
Date: Thu, 30 Sep 2021 09:43:11 +0000
Message-ID: <c1b0f954-0728-e6ab-73ab-7b466a7d2eb7@nvidia.com>
References: <BYAPR04MB49652C4B75E38F3716F3C06386539@BYAPR04MB4965.namprd04.prod.outlook.com>
	<PH0PR04MB74161CD0BD15882BBD8838AB9B529@PH0PR04MB7416.namprd04.prod.outlook.com>
	<CGME20210928191342eucas1p23448dcd51b23495fa67cdc017e77435c@eucas1p2.samsung.com>
	<20210928191340.dcoj7qrclpudtjbo@mpHalley.domain_not_set.invalid>
In-Reply-To: <20210928191340.dcoj7qrclpudtjbo@mpHalley.domain_not_set.invalid>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
	Thunderbird/91.1.2
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 81ce62ce-b56c-4737-68ef-08d983f6b7ae
x-ms-traffictypediagnostic: MW2PR12MB2442:
x-microsoft-antispam-prvs: <MW2PR12MB2442B7A3E508E6B51CD0DD15A3AA9@MW2PR12MB2442.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: j607uCoOoLdqnyboCoDplMyqsdNSSW1Qxqxn8PXJlNkTvj/Zb+YxUyK1pcZhtUD/jqrNQOHrL1Xy9OEJxcAXTadDA33OIQtWFz40K0m+Gv2sOFjImsoQWtYMYFnPSjxe6WkcNNz0SqgFfsDNsI8MxyKdPjQpcIkdW0ibz5N30Jwa8orSMlZHQsj+bFrZDOVnry/rPoLLitk9SwfRN1Xv99JCBpwhiG5e7F9FqqQjmWgs9HHT2LG5TQNbrUJ28NngWT8jIkjnoANXP/PP532UHJ2aL33NuWfAHCdHUnpZeeXRcP6+ORKJW3iCS3F8OmihOLIVWa8KZviyYPDUkSktBCm+nmDlgVh+hYr0i2+Rhds3NXtS+JeNAd4aALxTUp/kMAHe/afg7MVsmVlnKBFCLzZtw5ZEo6WAz1aBigbKLnhCLv4rzB4SMZ7qIUJDElTxTf3AatoMqNCE5IhvkjQl5UD07Qx6Rlno+g6KlLEBYKZJpdLrnDe/C0yuU43To6vik8y0In6dpgsuz62l3UBMgDD8UKpI66LQL+vDrYuRXA6X6HA7p7MTLOIXizJX4Rtt1nk9Zg0bxkoh2qHU0Ii/B+XByyCvoXGqLiEBPFWZ9Z23doCuoHmEw9Ac/QpPMvXkHqDuVkN9kMjDcY16tSTgDW/BSiez6PXUju27SOsl99RhUY0qqB3BTMcLgtV+tkC5VTkm7o+I8LKVptin9BTdPQWiHwMulvEDH6+Rlm8ZmPl2Erw7v2OpbOOWj8oIDyCu4FiOozSTBdMOB1sQt6sH9w==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:MW2PR12MB4667.namprd12.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(366004)(6512007)(316002)(83380400001)(8676002)(71200400001)(7416002)(6506007)(2906002)(31686004)(36756003)(26005)(91956017)(186003)(4326008)(2616005)(8936002)(5660300002)(86362001)(110136005)(54906003)(6486002)(508600001)(66946007)(66476007)(76116006)(122000001)(66446008)(66556008)(31696002)(38070700005)(64756008)(38100700002)(43740500002)(45980500001);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NEg0cVgzN3EyQTlRT2ZtQUJ2WTNxYmErcXpzeEdHWEVRcmR5c0FMUlh4MmVU?=
	=?utf-8?B?Ty92Mnp0T2UxUVQwUzd4Wmh3VFhaNEY5eklmQ2xEUTN4UGthUG0yYmZSSDN6?=
	=?utf-8?B?UTlZNG5yWEdLWjR1dWI2MWJQZy8wNmhZQm10U3d6bVczQ2Iyd2dTYmFHenpN?=
	=?utf-8?B?VUZ0M3BPVTZDNUd6Qm51aERRbHNCZDNIOElwVjhEbi9XLzhNckRIWW5BZlVC?=
	=?utf-8?B?dXlmTXF2TWg2dDZsRm80UmlzMzlKaG5jNko4YUdOK3Y0M05WSDl1cUxZTEpW?=
	=?utf-8?B?K2VFWHVRb3JSK3BIa2YyaDRjWXJKZW5DZk5aYnEwUnl2Y2ZmYkJJb1hJYWRu?=
	=?utf-8?B?WCtDMnRGL2g1MmNYNE00WTF3SkRRZ1BxM1NKNExFaEJVUm1JNXlBNlFNQndy?=
	=?utf-8?B?UFV1WS9KT254enhHNUpQM25zWXVoNE5tMVdGdTdEQjExQmdNelJuOUNCZ0d4?=
	=?utf-8?B?V1lVTGw3UE9lSTZyMno0SGMxQmJPZklTZWd0emVMMWRQd2doc1BMUmV3YXZq?=
	=?utf-8?B?MTVoNTdSYktXcmtVeWFKTTR3cTlyYnlDcmk4dzJJYkNPYWU2UGRWU3VIL3lz?=
	=?utf-8?B?ZWo5NC8xYXFXSjMwVGVNTUl0Qllva2VJWDErMGVrQjc1UHlsc2JvWFFMd2JD?=
	=?utf-8?B?S1VwcUpDUWhpSUlXRHJ5eXVyZFVhcWFxdWxwellKaHB6Q0xWQTZIdkovNHZ4?=
	=?utf-8?B?b2xxN1R5WHhhVklDUlljdXl1eUhmK0diRDlETWNWQnBlQTdLbWExRmVhWWxD?=
	=?utf-8?B?WXAvNGtkbUtrOUZIVVhQOThsTDVPSEh1YjZWZ2IyNnJ3WmJNc2hMeEJSUjht?=
	=?utf-8?B?eEhOZXgxc1RkWGgwaklsNWhac0Z1TlA1RVlYSHFkZ0pyRzJKcEoyK2NTWjN5?=
	=?utf-8?B?RW5FOVlCNDBqVWdHODZkM0F3QnlEM1kxZTVVR1R4TmNhOVV3QmxCcFpiT0dX?=
	=?utf-8?B?Nng1anI1c1Z1TGZkTTlLdjg2K2NqQ3E1WnRucE9pSjFVMGhqNTE2SHo0UGVn?=
	=?utf-8?B?Kzc1ZTFPRXVpZTRWbXhhczBlTU1DMzg3dStkTGpadHNteTVhZHNDRlpKeEZV?=
	=?utf-8?B?VDBIaFg0dEMwQU5id0tlMWI5TmdrWlNTQnpNVFZCajBQd1c0dWlndWFJN3ZR?=
	=?utf-8?B?VmNhTlh3VG1Wd1VjY0VtUFRqNEh2aUFIdE9lbURZMytpNVUvN21LN045Vi8r?=
	=?utf-8?B?M0FOK3JBS2NDSmU4Rjc4U202TmdSWUxyanVDeWlvSldPWDRPOERKOUhUUHlx?=
	=?utf-8?B?Sm9qTXdNazFPRHFBK2MydEpmN1kyTHplRXpLeHJxN09MdUdOR0xLK05MVGRR?=
	=?utf-8?B?QmJhQy83OGpuS213Wk82N3FlUUNMakNPMkY2WU1jajlwK2ROeElDbW1OWmVU?=
	=?utf-8?B?b1l5OUtLTG4vWWxIZFVCOC9vcnBRbmUxUFRuUC9oZEEwKzlhQ2ZSNksyeXB4?=
	=?utf-8?B?Rm04T25XcDJ4SU1LM2J0NCtOTllDWldYbTVJdXVGSFZ5VzY3K2tJUWdrTTdw?=
	=?utf-8?B?YUZTTURUVjBheTlvS3ZZZllFTmhOUHV6UG56VHNkU3VySTR4OThZczFtU2pL?=
	=?utf-8?B?Q0ZhbEorTzdwNEp2MGdtamkyaWVCS0lUdjMwbHU3dWxYMk96d2w5dkhCODA2?=
	=?utf-8?B?Uks1YjdxZC92U2NiOWZ0NU9JZFJVSEttWGRUZ1JHVkNTeUlJOWp0RDFwREVk?=
	=?utf-8?B?aEkrSGNaVUE5b3BIUDkrNXk1TG1DRmFnNXFKQ3p4dnl1cEVIZTZadFh6NVQv?=
	=?utf-8?Q?Ta6oJjsCjt9qMC7P+8=3D?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 81ce62ce-b56c-4737-68ef-08d983f6b7ae
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Sep 2021 09:43:11.5340 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vTedOFZJZ+uBys45CPMkRArj1B7by2DXmQRupbClzsc2pCP54pLAjjLkXYhH8BCUm5xhAkK/dhmgmqoUi8Ndyw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR12MB2442
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-MIME-Autoconverted: from base64 to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 18U9hT2Y010836
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Fri, 01 Oct 2021 02:24:53 -0400
Cc: Nitesh, Fu <vincent.fu@samsung.com>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	Adam Manzanares <a.manzanares@samsung.com>,
	"osandov@fb.com" <osandov@fb.com>,
	"msnitzer@redhat.com" <msnitzer@redhat.com>,
	"bvanassche@acm.org" <bvanassche@acm.org>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"hch@lst.de" <hch@lst.de>,
	"roland@purestorage.com" <roland@purestorage.com>,
	Shetty <nj.shetty@samsung.com>, "zach.brown@ni.com" <zach.brown@ni.com>,
	SelvaKumar S <selvakuma.s1@samsung.com>,
	Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"mpatocka@redhat.com" <mpatocka@redhat.com>,
	"kbusch@kernel.org" <kbusch@kernel.org>,
	"Frederick.Knight@netapp.com" <Frederick.Knight@netapp.com>,
	"axboe@kernel.dk" <axboe@kernel.dk>, Kanchan Joshi <joshi.k@samsung.com>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>, Vincent,
	"lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>,
	"rwheeler@redhat.com" <rwheeler@redhat.com>
Subject: Re: [dm-devel] [LSF/MM/BFP ATTEND] [LSF/MM/BFP TOPIC] Storage: Copy
	Offload
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <049DEE6DC5469349ADC32795CC0EFE79@namprd12.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Javier,

> 
> Hi all,
> 
> Since we are not going to be able to talk about this at LSF/MM, a few of
> us thought about holding a dedicated virtual discussion about Copy
> Offload. I believe we can use Chaitanya's thread as a start. Given the
> current state of the current patches, I would propose that we focus on
> the next step to get the minimal patchset that can go upstream so that
> we can build from there.
> 

I agree with having a call as it has been two years I'm trying to have 
this discussion.

Before we setup a call, please summarize following here :-

1. Exactly what work has been done so far.
2. What kind of feedback you got.
3. What are the exact blockers/objections.
4. Potential ways of moving forward.

Although this all information is present in the mailing archives it is 
scattered all over the places, looking at the long CC list above we need 
to get the everyone on the same page in order to have a productive call.

Once we have above discussion we can setup a precise agenda and assign 
slots.

> Before we try to find a date and a time that fits most of us, who would
> be interested in participating?
> 
> Thanks,
> Javier

-ck

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

