Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83330C43219
	for <dm-devel@archiver.kernel.org>; Fri,  4 Feb 2022 09:42:12 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-219-3P3HdRGXOlyX6D9fL2m5Aw-1; Fri, 04 Feb 2022 04:42:08 -0500
X-MC-Unique: 3P3HdRGXOlyX6D9fL2m5Aw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CA6F01091DA6;
	Fri,  4 Feb 2022 09:42:03 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A9BA11F2FB;
	Fri,  4 Feb 2022 09:42:03 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 824404A7C9;
	Fri,  4 Feb 2022 09:42:03 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21435YsE013702 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 3 Feb 2022 22:05:34 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 36E0540F9D77; Fri,  4 Feb 2022 03:05:34 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 321EC40F9D6D
	for <dm-devel@redhat.com>; Fri,  4 Feb 2022 03:05:34 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 13C763806657
	for <dm-devel@redhat.com>; Fri,  4 Feb 2022 03:05:34 +0000 (UTC)
Received: from NAM12-BN8-obe.outbound.protection.outlook.com
	(mail-bn8nam12on2069.outbound.protection.outlook.com [40.107.237.69])
	by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-363-zdO8U1j8Op2XlIwbNM3BhQ-1; Thu, 03 Feb 2022 22:05:32 -0500
X-MC-Unique: zdO8U1j8Op2XlIwbNM3BhQ-1
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
	by MN2PR12MB4423.namprd12.prod.outlook.com (2603:10b6:208:24f::18)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12;
	Fri, 4 Feb 2022 03:05:30 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
	([fe80::846c:d3cd:5a30:c35]) by MW2PR12MB4667.namprd12.prod.outlook.com
	([fe80::846c:d3cd:5a30:c35%5]) with mapi id 15.20.4951.014;
	Fri, 4 Feb 2022 03:05:30 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Luis Chamberlain <mcgrof@kernel.org>, Adam Manzanares
	<a.manzanares@samsung.com>
Thread-Topic: [RFC PATCH 3/3] nvme: add the "debug" host driver
Thread-Index: AQHYF5pGTuc0vK6aW0WDOYv4vbM4lKx/xVyAgAI7dYCAALgbgA==
Date: Fri, 4 Feb 2022 03:05:30 +0000
Message-ID: <242979a2-6a4d-30fe-2aaf-911b576e2cda@nvidia.com>
References: <f0e19ae4-b37a-e9a3-2be7-a5afb334a5c3@nvidia.com>
	<20220201102122.4okwj2gipjbvuyux@mpHalley-2>
	<alpine.LRH.2.02.2202011327350.22481@file01.intranet.prod.int.rdu2.redhat.com>
	<CGME20220201183359uscas1p2d7e48dc4cafed3df60c304a06f2323cd@uscas1p2.samsung.com>
	<alpine.LRH.2.02.2202011333160.22481@file01.intranet.prod.int.rdu2.redhat.com>
	<20220202060154.GA120951@bgt-140510-bm01>
	<20220203160633.rdwovqoxlbr3nu5u@garbanzo>
In-Reply-To: <20220203160633.rdwovqoxlbr3nu5u@garbanzo>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
	Thunderbird/91.3.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7bb1b37d-44d6-469c-6032-08d9e78b33bf
x-ms-traffictypediagnostic: MN2PR12MB4423:EE_
x-microsoft-antispam-prvs: <MN2PR12MB4423F24D51A52898F76E2490A3299@MN2PR12MB4423.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4125
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: XO1aUShBnfmy+kbnIObm6e7VEpOwWBZ1np0uJvAJtsjE0teguDRvxHgSVQMeM70djdK9Qm5TKHQETySEvlPgdCn/w9s9Mbtq88xnbwIIrk5QrLigpiRgVKoXpjjyW0o59JQASvoAyhKVD+XRPBxB/P7qh9Y4C1QIqBVJBbkEklfrSXfzEpnSua9STaXOrWSi1FxQlcHakvueiL3qAFxtoZyp62H2B9GCjC8cbJhqP/ujdTmAoK7KZJxxmn9wOIxtMChj/i+EGkR0LGuah84htvzs2HwHQe/rx7bn3r6TKX8x9StO89AfspPX7zn4BOOO/OacCAD76reOz6Epf0tRoz40msjqSBGgo3B6ANmPI1570Hf6EdrEAsVphUHfCsXOXgznIIf2TUNQw2IyzQGD7h/FuGip6H06ubzRkRN/SY0WrTSYoxFXJ09zHJR2HDtvht+jEDYDBrRwUzUOJF8CYlGHMra4HFmePUN64sM+4P5B/EFEyjzhIu92ao9bbr68GFlJLRDVB9RqHczlrty6LOd0hiQoVjfvwi3jUFfTh/5+09CK1rjENzvbuAk8gUF/q2uLVa0zv/MCzRRYZ8J2eoM3SyBsGOmDGqnrZtikSsCjWnjBL1lIq/8IxbSuD/IhmF2GzwsnTjESqOtEAC091UwenSCrhpjebMZnKZZ/H3VSABJSubQ6+PqF6GEnsqtqWModuFY2hURkOABOw+M7bxNCjJmxiPekMw69yj+2VafCJe1hZUzA0gbqgvouLbxC
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:MW2PR12MB4667.namprd12.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(13230001)(4636009)(366004)(54906003)(7416002)(110136005)(38100700002)(86362001)(122000001)(508600001)(6486002)(5660300002)(31696002)(2906002)(4744005)(38070700005)(76116006)(316002)(91956017)(66946007)(66556008)(66446008)(64756008)(8936002)(8676002)(4326008)(66476007)(186003)(2616005)(53546011)(71200400001)(6506007)(6512007)(31686004)(36756003)(45980500001)(43740500002);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WXBnaGFabzNramNPaFAwYkdaSERqUDByMlUwWElEdEFzanJCWHBlRXJNTW9D?=
	=?utf-8?B?R2lDNm96NEp3d0xzVkVHYThndjJJc1lpUHF0Rm1oU1RldXFuWkRxTzBJeWx2?=
	=?utf-8?B?ZFdjUXJsbUs5SWRQWXllVE1RZm96dTVNKzFIZTdSNzJQdklWZ2VYWnRXRmhV?=
	=?utf-8?B?YXd0ZTFERTZGczFHSzEzSlVPdGJHVFQyakthK01ES0tncS9DSnlpNkNWYmtD?=
	=?utf-8?B?a1RjdjZEOEFyQnNqWVVVSGtsTGUzUXZCMSt2TWFUMzBGdVpIZk8vZmtrVm1r?=
	=?utf-8?B?ZVhyRTNXNWFMWk1NUzkvQWd0NWZNU2lURlBhbSt6UUFEdHFlT3VKTnM5TVlL?=
	=?utf-8?B?ODNCSnpmWDlqQ0lWZTUya1FBa2hlN1UrbXNvaTdxNHFkdzZQZllHZ0Y5UnJ3?=
	=?utf-8?B?RzUvWmxIQUxEYzZBQTJmNWpibldQd1hLS3lETTVka0l2dzJSNTlZd3BPQ29H?=
	=?utf-8?B?WXd1Wm1GS2JQMEduaXhtanRwY3FPczlCaGYxQUlOZ1N5YlQzZnNWSlVGeEc3?=
	=?utf-8?B?SlNsZ0JwOVVJdHoveW5ocW1NSWNISnJnbGVtdDU0SnRmT1ZnNVRjWXBuKzVl?=
	=?utf-8?B?ekNrU213Vko1UFBDbmpleHVrKzVKaCt5RjV4ekZiT2tiVkNyMmNVdkh1OUEx?=
	=?utf-8?B?OUlBZzZVemNhUDdKQkptMjBqbG1DTUVXRFFhblltRnp0OWNNV3pEQnExZy9l?=
	=?utf-8?B?a01sOFg4cFBaT2ZWUW0vcUdPb0hFMS9iMDJzamxMLzhGWU5DZGp5UTVpMzZu?=
	=?utf-8?B?RTl3RjE4dVpKZGVQY0drQlZYdjVyU0ZWRmdjN1VxTlRhR3hrSzQ5U3Q2ZTVh?=
	=?utf-8?B?a1pubUZlVDQ3SlI0TGgwRHRsSDVyWDJkTEFBeGdTNXZzYk5nU0VjRHJwdUdP?=
	=?utf-8?B?WkNzcGRqcHdlclRWTCtUVTlIUU5jWllFODZLNWRzZldDc082d2VpSEUzV3BE?=
	=?utf-8?B?bWgrdWdxVVA0Yzdqa21adlc0Vm9mYkVGM3pCbzNzUGdkWWpBK1N2c2c1Z21Y?=
	=?utf-8?B?ckxmcFlyL0dldjNHYXpmbDFnd3NHYW1vcXUvT2FIUzVzTktlTkx4RmFGWHo2?=
	=?utf-8?B?T3Y1R043UzlyWjQ2b1ZRU2Z1SThnVXlxSVo5LytCZG9acUxheFBWNHd0a1dQ?=
	=?utf-8?B?UlpUMTFabnVrMUNjN3JwSTlMbWRjUURnMUs5dllNclJqSzJnQkhBeXAzWUQx?=
	=?utf-8?B?NGtGSDlORlJmQXBJS0ltUU1nWW90NTNjTWRaY1B5bW5DWDh2U3JsRTNQcXo3?=
	=?utf-8?B?ZHcxb2MyaGUwdUVXd3FrVnJGNHFmWElXN0tidE9QaWhnQ3Bxcnd2TWJoYitw?=
	=?utf-8?B?UGlLbzkrZi8zOExPbFZCRWZVMXIxOXlOekRKSGNWa2Z6dUZwNG5mUHFOU1FC?=
	=?utf-8?B?VGJlalh0dnk3WG9EVXJDOVFZMjkwbmhVRkJaSU5rWTNSTDZNQndFRERqUTNQ?=
	=?utf-8?B?R21jcDc5YU0vVFNqZXNNN3ZaZ3FsVndDWWtGV2ZnMjlDVmQ2aGxLUUN2Uysr?=
	=?utf-8?B?OEkxZW5XV281czV0SHhjMHlyZ2FBNzRIU2lWekZSMVVybXRoNHg3VzRybk1J?=
	=?utf-8?B?OXF0WGJoUVNWdTJvR05lVXIrbVNoYzJ6KzE4dlM5RlFwQmY3YkZFUnhFcWhV?=
	=?utf-8?B?cjY3RTYwbG1COXlyR3VFMHQwQUJQOUljTzdrYmdIWTNkcE9jNk00MCtsZnZM?=
	=?utf-8?B?clF2QVgwVmZZVWtzQzZGamZ0WlEwY2lCcjFrbU9lM1hvYm1WMnM3enhqQWpV?=
	=?utf-8?B?Zlc0cUtQY3VrNHhJRVJaMTJZOFVZUDU0TXM1R1hHZGM2NUNLYytYWk5XNFNm?=
	=?utf-8?B?Ris1VlI5WHlWMnNHZnFPNk4vVm9PdXpxR0lyb3JNVHBzUW5HMHRGTk9vd2dS?=
	=?utf-8?B?eFFOS0tXc0tmOGd6MGoxQ2NQZndkVktUdVIxdURKUGdLOHVtSVZIV1lHdU5j?=
	=?utf-8?B?Q3FTTVI5WWlDUXl3c0dhUDQwdXZCekxtWHNJV1I0bkJBa3hoVU9jd2lKNkM2?=
	=?utf-8?B?bE1zSnZVeHRWQ1I2S1E2eVkvcHNDaGR0Wkg5L0s3alJKTHRqd2VpNXRpbHRJ?=
	=?utf-8?B?RUFtV09qUWFudXZNYzhIclFMb21oQ2NZeEUydnhweWVHZWpVVDZKcGhYS0Ix?=
	=?utf-8?B?TlN4WnZ4TzhINVR0WHZNLzJrYStLTG0zYkNvcy9TNmZxbjFVOFJOSG8wcmJs?=
	=?utf-8?B?UW9HUTF6aDZrRnBTcVgvSmJZUzk5UEhpVGlYeG5FUzJBYmFOYzgraUtGN1lJ?=
	=?utf-8?B?ZVVSY0lOUU9adXZ1UnJ6eUJRZ1hnPT0=?=
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7bb1b37d-44d6-469c-6032-08d9e78b33bf
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Feb 2022 03:05:30.3036 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WiVQJHldvECS90ngkrURvLtSLk2z5o9FjxiZa9apTNtMy8EUrNm35NbEvLDqqyDDHurznU7NqTKw5xlx/ncSFg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4423
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 21435YsE013702
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Fri, 04 Feb 2022 04:41:43 -0500
Cc: Bart, "djwong@kernel.org" <djwong@kernel.org>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	"clm@fb.com" <clm@fb.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>,
	"osandov@fb.com" <osandov@fb.com>,
	=?utf-8?B?SmF2aWVyIEdvbnrDoWxleg==?= <javier@javigon.com>,
	Assche <bvanassche@acm.org>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	"roland@purestorage.com" <roland@purestorage.com>,
	"zach.brown@ni.com" <zach.brown@ni.com>,
	"dsterba@suse.com" <dsterba@suse.com>,
	"msnitzer@redhat.com >> msnitzer@redhat.com" <msnitzer@redhat.com>,
	"josef@toxicpanda.com" <josef@toxicpanda.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>, "kbus
	@imap.gmail.com>> Keith Busch" <kbusch@kernel.org>,
	"Frederick.Knight@netapp.com" <Frederick.Knight@netapp.com>,
	Jens Axboe <axboe@kernel.dk>, "tytso@mit.edu" <tytso@mit.edu>,
	Kanchan Joshi <joshi.k@samsung.com>,
	"martin.petersen@oracle.com >> Martin K.
	Petersen" <martin.petersen@oracle.com>, "jack@suse.com" <jack@suse.com>,
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
Content-ID: <3D9FCC340B339844A9F3FDF367AA635E@namprd12.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 2/3/22 08:06, Luis Chamberlain wrote:
> On Wed, Feb 02, 2022 at 06:01:13AM +0000, Adam Manzanares wrote:
>> BTW I think having the target code be able to implement simple copy without
>> moving data over the fabric would be a great way of showing off the command.
> 
> Do you mean this should be implemented instead as a fabrics backend
> instead because fabrics already instantiates and creates a virtual
> nvme device? And so this would mean less code?
> 
>    Luis
> 

This should not be implemented on the fabrics backend at all or even
in nvme-loop. Use QEMU for testing memory backed features.

-ck



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

