Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 482A8C433EF
	for <dm-devel@archiver.kernel.org>; Fri,  4 Feb 2022 09:42:15 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-604-biNXM71RPiCxQUmhi4bsjg-1; Fri, 04 Feb 2022 04:42:09 -0500
X-MC-Unique: biNXM71RPiCxQUmhi4bsjg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9E3361853035;
	Fri,  4 Feb 2022 09:42:05 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7C4421F41D;
	Fri,  4 Feb 2022 09:42:05 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 55B121806D1D;
	Fri,  4 Feb 2022 09:42:05 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 2143HbAk015365 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 3 Feb 2022 22:17:37 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 0B42740CFD7B; Fri,  4 Feb 2022 03:17:37 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 062D140CFD45
	for <dm-devel@redhat.com>; Fri,  4 Feb 2022 03:17:37 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DA6F128ECA87
	for <dm-devel@redhat.com>; Fri,  4 Feb 2022 03:17:36 +0000 (UTC)
Received: from NAM02-SN1-obe.outbound.protection.outlook.com
	(mail-sn1anam02on2041.outbound.protection.outlook.com [40.107.96.41])
	by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-295-QSSQMFCMObKv0YzK9uqw8Q-1; Thu, 03 Feb 2022 22:12:43 -0500
X-MC-Unique: QSSQMFCMObKv0YzK9uqw8Q-1
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
	by BYAPR12MB3096.namprd12.prod.outlook.com (2603:10b6:a03:ad::13)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12;
	Fri, 4 Feb 2022 03:12:40 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
	([fe80::846c:d3cd:5a30:c35]) by MW2PR12MB4667.namprd12.prod.outlook.com
	([fe80::846c:d3cd:5a30:c35%5]) with mapi id 15.20.4951.014;
	Fri, 4 Feb 2022 03:12:40 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Adam Manzanares <a.manzanares@samsung.com>
Thread-Topic: [RFC PATCH 3/3] nvme: add the "debug" host driver
Thread-Index: AQHYF5pGTuc0vK6aW0WDOYv4vbM4lKx/5pmAgAIScYCAABSnAIAAMdEAgAB7aoA=
Date: Fri, 4 Feb 2022 03:12:40 +0000
Message-ID: <863d85e3-9a93-4d8c-cf04-88090eb4cc02@nvidia.com>
References: <f0e19ae4-b37a-e9a3-2be7-a5afb334a5c3@nvidia.com>
	<20220201102122.4okwj2gipjbvuyux@mpHalley-2>
	<alpine.LRH.2.02.2202011327350.22481@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.2202011333160.22481@file01.intranet.prod.int.rdu2.redhat.com>
	<270f30df-f14c-b9e4-253f-bff047d32ff0@nvidia.com>
	<20220203153843.szbd4n65ru4fx5hx@garbanzo>
	<CGME20220203165248uscas1p1f0459e548743e6be26d13d3ed8aa4902@uscas1p1.samsung.com>
	<20220203165238.GA142129@dhcp-10-100-145-180.wdc.com>
	<20220203195155.GB249665@bgt-140510-bm01>
In-Reply-To: <20220203195155.GB249665@bgt-140510-bm01>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
	Thunderbird/91.3.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 59907c04-becb-4258-055c-08d9e78c33ee
x-ms-traffictypediagnostic: BYAPR12MB3096:EE_
x-microsoft-antispam-prvs: <BYAPR12MB3096E2E1137FC138265F688AA3299@BYAPR12MB3096.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: bWP0zAl0cseiTGfVM/bOonE4Y/3fo5bTNAxmXqncir1ImSIFHt0DKfaZ5O0QiDby3sUEmnD8KeJiTg6VquMBTjgtHE7wViPm0R4pO++wuvYKvYDvGei9Y5y+kqEioQ/JDmXO7mnC/U1W1pwVuuKQ0em5DjUWwMuoooWEczaemme43VenIh9XGbh0wDIPSJqIyG45GAfPeQOnvPlAV+jcKR7rqDytE3i+g7gOwr5CAOme5X02dn2eAYe8rtoaevKz5fQxVkZmQ0/6ejT6T20l7gu7ThUVeEMUFYXenua75ANW0lkPwUGeWtFlCncMlzwbiY01rXZzHoeJJmPUm2nBacwnSV/h3fMybxCvYEwNK1G4QPW/Tm6rfQNVMEkC/nNq4400m3YhPFxUgepE0r9cxuGvSHbSw1szjm0Syj110lkCv8dYAHpNR0lt0G0ZEpO6EEA0j3cFiTA3HitLYrlRTSsOn+8pUdH2j7osMUz3U6RNyNrrF6HYapOvHnvonh630AQZGKUxpJrRddQysCAXFabYh4jyWaSffwNPwe2nfn7cU9n3NUoM/hTOZBXdMvYAMbSok5E5jqebSJVG3iDyJym39+5CCYTBG2VaUaIPOYi6p5gZ6mBs9rPpuOLYwJ8lgVEJmS1HEYittT1/GMYe0w8CFf257OF+ouP2hy6oRIS6XyNAlblSfpHA5hrvahk89vYF/wCa6UHMlh8MD7+WOj9G9OwNkQj6k6EmwmV+JyRxBpAsedGAagLmejEV67tLDMRJAe8kLGMfi4l8YEe+0A==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:MW2PR12MB4667.namprd12.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(13230001)(4636009)(366004)(71200400001)(186003)(38100700002)(6506007)(6512007)(508600001)(2616005)(6486002)(38070700005)(122000001)(2906002)(316002)(31696002)(54906003)(83380400001)(66446008)(91956017)(5660300002)(86362001)(66946007)(8676002)(76116006)(31686004)(7416002)(6916009)(4744005)(36756003)(4326008)(8936002)(66476007)(66556008)(64756008)(43740500002)(45980500001);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?K0E2UHc3eGV1MkZFUm1nejZZUm11eGJGTVNGZUtudWd5WlJ2QjJVOVhDZmVU?=
	=?utf-8?B?UVRoUDRhR3pBZ0RYUUJSSnM4bkVaakdEMTk5UzUrNHArbzA4U1BmTjZsMmRz?=
	=?utf-8?B?RWRsOXV3OEx4dE1uVjI2dGpyek5wa01QL05yMjNMemRxYzMvL2d6WEc4MUp0?=
	=?utf-8?B?UGhmOUZsSmc5M2lrcnhya0xsN0k2MTZXVTNyNC9Sa2Q1SzdtUU5xVXgrODRo?=
	=?utf-8?B?emEwd2V5VS9KdlViSTRKa0YyRWFMVXMwNjRNbFh6dkV5ZmJTRkxmd24yeVp4?=
	=?utf-8?B?QTVNN3hjc3JqNFI4bmVlVGhqemhWeWNkMGF5V1NPaFIvVldCSHRSUGsyWkdV?=
	=?utf-8?B?TEUxK0RWV2RBaDNac2R6ZkFsb1ZvRWpmQlRMbU9iSjZ5UGxiQlNWc1l4aEk5?=
	=?utf-8?B?aUNBU25KSW1paXZQVTk5YlQxZFhQd2ZWYmpDS2hBL0gveUZQVVFkZU8vSm9R?=
	=?utf-8?B?am16R1gvc2lMRzNiUmwwaHcvSXJPSTdiZVpwWk40TXZ4NVA5VE52aUY3Y2ZF?=
	=?utf-8?B?aE91cStoUGhEK1BDSFZZK3ZzbzN2dW8xQlpyaGlwWXZyaldBVy9SVmhtbGpN?=
	=?utf-8?B?MnMrYnhRQzlkMFlBc0RraHlDUjFiTk1YMUJuNFpnNSs2YUk4ZEkxZFkrVURk?=
	=?utf-8?B?VHhVTDhjaTEycG9YOG1aajV6OE9MaVVQSlRwaFhtb2VLMU5panoyZXdVd1RX?=
	=?utf-8?B?OURLai9wWEtieXZuK3hQOTVKQ3JvTmlEWkF6YmxKR0xYZzlRL0VMNjBsc3ZZ?=
	=?utf-8?B?aDdmZ21xOXFMbkxzTzlSRHQvTXAvVjZwRTNwSTdERFlob0t1emtyeTV0T3J2?=
	=?utf-8?B?a09HZVVzUmxxL1FROW1EdnlKenhDc2E2K2poMjRiWlZPZGFLTUlYaVIxRkpQ?=
	=?utf-8?B?Z1hpZlh6bWIwUlIrSWRNYVZSeERWUUxlZjhWd1hPZ0xRRVB6MUlFZ1JaTG9Y?=
	=?utf-8?B?c1RFOWwzcklLamExOTZBbTFoWmRJbHBIamhPcm1GM0I1OGFidkdtRzM5bzd5?=
	=?utf-8?B?cFJ0ZEZzSW9tSlRQTXh0WUJ0blFNb3hqRUZMTWYzS005WFF5QktUQ3hKeWFy?=
	=?utf-8?B?N3JsL0tWbFdEWndYbzlSQmJ6N0xEWGFGUy9PdXZPYjJWZ2JNdVpCcTI4Nnd0?=
	=?utf-8?B?My9uSS9USGxNYjY1UmpsWDUwOSsxcmsxcW14T2pPWDczZGRySHd6WFRjc3hJ?=
	=?utf-8?B?THFhd1pGYUZ2ZUg3elVoVVdUbERNWTAvMS8vTG9LSmpmdkxjR3JLcjVxUG5J?=
	=?utf-8?B?OHozV2s0VVJzRXNwVXBrMjR1Q3l3Q2JRaTlPWXp5NHRJTkhOcHEwdFZadURm?=
	=?utf-8?B?WXhUNXJZejB2ZkRKdy9ndlZsdFhRL2Y2cEoySjFONmJNUThpSHJqaHB5OVlT?=
	=?utf-8?B?YUZIWlg4aEY2ZkhyakNjYWZ3Q0hXd0R1cEJhdnVnQW0rV1hyck1POUZobEFS?=
	=?utf-8?B?S2pFbElCbWU2YWtZRFBsS1VzZkYrWFoxYXVDcmdxMXVOQk1FUVVacUVaWGhr?=
	=?utf-8?B?L041TFdDREEwYVY1RzFEdm5lU29oTm1kSUlGNWlTM1JTZExPVEI0aW4xakxK?=
	=?utf-8?B?WktUcTJjeUFBNEsxK2sxME5RUUVxWkc0U2wxQXNZZTNTbkE0VHF1U1I1ejR2?=
	=?utf-8?B?VVAvempFcFN2WVVFV3B3UzV5N3I0NzFmSFR6U0FVRTg4L2NvREltbmtoV2o5?=
	=?utf-8?B?UWg0dUlwdTdidHp6Vy9xYmVoZktQcis3R2IrUDZNTXUwdk5sb2FvSCtNTmo4?=
	=?utf-8?B?dWFudFNoRFJSNkxNLzB4ZFdxd3BOTTIxb2dmekpkd0FHTXRwSTY4MU4wOXJv?=
	=?utf-8?B?RmNTSTBOUkhzVFI5eGtmZXJYc1BMUlJxVkhUcFV2bzdTSlpjT3huQ085Y3d3?=
	=?utf-8?B?QnpLcUcxUlhnSzhqUUpIMnEzOVBXRCtOWFdoOWREMEtvQndjRHh1TThzMjRX?=
	=?utf-8?B?MkRwL2lZQmtkNmxKZWw0UzNMRGpWQ2t2cUxmTlBjWmNMc1RpcXVPZ0lWazlm?=
	=?utf-8?B?V2sxc0daM1hXbE5NV0czbVBFOFIxTHQxYUZ2UXQwb2FUN2dlb0RnbjhvTlJQ?=
	=?utf-8?B?UWYxM3ZNWFNJSGd4RUhuQUZTUEJjZElHNmd6TTRyVW1Ndk1KOGF0TWtHZFh1?=
	=?utf-8?B?VitjK0xYSlNDRVJ1aHB2bFF5YnR5dzhrRXlKdWhYZEhaYmdCQXhBTkQzbzVy?=
	=?utf-8?B?MUVjclFPTXhkdFREK0lFYWFqREQ5VEZldTF0S0FaSDd6amVYS2tPNldhSkFv?=
	=?utf-8?B?ZWpjdE45dDUreXYrY1lOK1FCckd3PT0=?=
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 59907c04-becb-4258-055c-08d9e78c33ee
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Feb 2022 03:12:40.0904 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cskadpYcWyuwHHTwCFJPpwlHe1ypBhqX2zevTYgggkPg+9DN5xfD2e3QvCwXJsVZ6G5vcTV9ub2Eta2opIt23Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3096
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-MIME-Autoconverted: from base64 to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 2143HbAk015365
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Fri, 04 Feb 2022 04:41:43 -0500
Cc: "djwong@kernel.org" <djwong@kernel.org>, Jens,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	"clm@fb.com" <clm@fb.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>,
	"osandov@fb.com" <osandov@fb.com>,
	=?utf-8?B?SmF2aWVyIEdvbnrDoWxleg==?= <javier@javigon.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	"roland@purestorage.com" <roland@purestorage.com>,
	"zach.brown@ni.com" <zach.brown@ni.com>,
	"dsterba@suse.com" <dsterba@suse.com>,
	"msnitzer@redhat.com >> msnitzer@redhat.com" <msnitzer@redhat.com>,
	"josef@toxicpanda.com" <josef@toxicpanda.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>, Keith Busch <kbusch@kernel.org>,
	"Frederick.Knight@netapp.com" <Frederick.Knight@netapp.com>,
	Axboe <axboe@kernel.dk>, "tytso@mit.edu" <tytso@mit.edu>,
	Kanchan Joshi <joshi.k@samsung.com>,
	"martin.petersen@oracle.com >> Martin K. Petersen"
	<martin.petersen@oracle.com>, Luis Chamberlain <mcgrof@kernel.org>,
	"jack@suse.com" <jack@suse.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	"lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>
Subject: Re: [dm-devel] [RFC PATCH 3/3] nvme: add the "debug" host driver
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <6326D3543531B14E9A33FEF6B268DD16@namprd12.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit


>>> One can instantiate scsi devices with qemu by using fake scsi devices,
>>> but one can also just use scsi_debug to do the same. I see both efforts
>>> as desirable, so long as someone mantains this.
>>>

Why do you think both efforts are desirable ?

NVMe ZNS QEMU implementation proved to be perfect and works just
fine for testing, copy offload is not an exception.

>>> For instance, blktests uses scsi_debug for simplicity.
>>>
>>> In the end you decide what you want to use.
>>
>> Can we use the nvme-loop target instead?
> 
> I am advocating for this approach as well. It presentas a virtual nvme
> controller already.
> 

It does that assuming underlying block device such as null_blk or
QEMU implementation supports required features not to bloat the the
NVMeOF target.

-ck



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

