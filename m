Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5181BC433EF
	for <dm-devel@archiver.kernel.org>; Mon,  7 Feb 2022 09:33:36 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-507-YvLie63kOoWcpE8iUovQsQ-1; Mon, 07 Feb 2022 04:33:31 -0500
X-MC-Unique: YvLie63kOoWcpE8iUovQsQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 194C3100F944;
	Mon,  7 Feb 2022 09:33:27 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5574F10595A1;
	Mon,  7 Feb 2022 09:33:26 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 88E541809CB9;
	Mon,  7 Feb 2022 09:33:20 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
	[10.11.54.10])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 2149w7q5012175 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 4 Feb 2022 04:58:07 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id B34C7401E6D; Fri,  4 Feb 2022 09:58:07 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AE577401DB1
	for <dm-devel@redhat.com>; Fri,  4 Feb 2022 09:58:07 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 922D41044564
	for <dm-devel@redhat.com>; Fri,  4 Feb 2022 09:58:07 +0000 (UTC)
Received: from NAM10-BN7-obe.outbound.protection.outlook.com
	(mail-bn7nam10on2053.outbound.protection.outlook.com [40.107.92.53]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-628-Kpm558t3N9iC4ofVDqjCQA-1; Fri, 04 Feb 2022 04:58:05 -0500
X-MC-Unique: Kpm558t3N9iC4ofVDqjCQA-1
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
	by CY4PR12MB1893.namprd12.prod.outlook.com (2603:10b6:903:127::23)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.15;
	Fri, 4 Feb 2022 09:58:03 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
	([fe80::846c:d3cd:5a30:c35]) by MW2PR12MB4667.namprd12.prod.outlook.com
	([fe80::846c:d3cd:5a30:c35%5]) with mapi id 15.20.4951.014;
	Fri, 4 Feb 2022 09:58:03 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: =?utf-8?B?SmF2aWVyIEdvbnrDoWxleg==?= <javier@javigon.com>
Thread-Topic: [RFC PATCH 3/3] nvme: add the "debug" host driver
Thread-Index: AQHYF5pGTuc0vK6aW0WDOYv4vbM4lKx/5pmAgAIScYCAABSnAIAAMdEAgAB7aoCAADa8gIAAGRyAgAAHXICAABoRgA==
Date: Fri, 4 Feb 2022 09:58:03 +0000
Message-ID: <4d5410a5-93c3-d73c-6aeb-2c1c7f940963@nvidia.com>
References: <alpine.LRH.2.02.2202011327350.22481@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.2202011333160.22481@file01.intranet.prod.int.rdu2.redhat.com>
	<270f30df-f14c-b9e4-253f-bff047d32ff0@nvidia.com>
	<20220203153843.szbd4n65ru4fx5hx@garbanzo>
	<CGME20220203165248uscas1p1f0459e548743e6be26d13d3ed8aa4902@uscas1p1.samsung.com>
	<20220203165238.GA142129@dhcp-10-100-145-180.wdc.com>
	<20220203195155.GB249665@bgt-140510-bm01>
	<863d85e3-9a93-4d8c-cf04-88090eb4cc02@nvidia.com>
	<2bbed027-b9a1-e5db-3a3d-90c40af49e09@opensource.wdc.com>
	<9d5d0b50-2936-eac3-12d3-a309389e03bf@nvidia.com>
	<20220204082445.hczdiy2uhxfi3x2g@ArmHalley.local>
In-Reply-To: <20220204082445.hczdiy2uhxfi3x2g@ArmHalley.local>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.11.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e1b4f437-41e9-4f1c-7cfa-08d9e7c4d5de
x-ms-traffictypediagnostic: CY4PR12MB1893:EE_
x-microsoft-antispam-prvs: <CY4PR12MB18937153F0E20E39E98764A5A3299@CY4PR12MB1893.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: tlGSUW0byVBXmqvHCWNFXYu6+k3OHN3Z9YO8BluoU9qLprs3UqvyMzVuF5aGYg+cNTB4fJCm2f90gFAdDqaVqpY09f2FyCgWYZi4otugqTiWZoFSxgHAZTOu/VK9yMiXcVRRmOIl2TgnH6RhoU0FHREAc+4CHDkUSzAeQGVG/wGhUrcP1FVHjSJqvVZgZYvy21oZddnIF1hqrI5We8LViPncZciwOx6lLf4rnrmtZTtLZUfOR290XcY2q7awD5lPv/RfggjjiVGs6tOpQkuKK6mlnjqMK4eQg7J4C6s4zebGyFb5s89EFF0Rt7dgPS4UhG2eozagyjgFzQ84zRuwtG51YHYYUs12HfunJQuD3swdLrE/vtSkJA1UOOmNbCQgV2DUA4+JpU0oIb2pluPVudjEBZKA/fs5vb/vtNchzhk5s0+HTQM3mO8RARfKG/cG1RPFULr3FfNNdiT22fiW6iLFQo+RDfpH0ijYoKVEUItwGecaUZ74tRswQnP/wh/JW70bYt4TdUYJksmAuPSCy2Hp1aboIIgBL3pm6p52ANhxogi/SrU2lCOXwm4b5DjNeX+42TUFRMddi2D0YrFVgkfzMJDa31diq93vVaUFNqg5BZIISC9IFsjkDU6btfeYOSIa5WVHWgl3pwpuR3zk3EHVwaerccRtoWCg6uRiNeBIAmn6OeZQeu7Ok06zATdng2v3Yniz/I0T8Z3bGMAp6fDjrU2ei0nRYigMTlQAdTEUzt/AwF7bP44+tPGJJGKbd77UgXDMi+2i8MjMZ0DIbg==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:MW2PR12MB4667.namprd12.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(13230001)(4636009)(366004)(8936002)(66476007)(66446008)(64756008)(91956017)(316002)(86362001)(7416002)(66556008)(36756003)(71200400001)(31696002)(2616005)(66946007)(6916009)(186003)(6486002)(508600001)(31686004)(5660300002)(76116006)(8676002)(54906003)(38100700002)(4326008)(122000001)(53546011)(6512007)(6506007)(38070700005)(2906002)(43740500002)(45980500001);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?LzBGUC80RTQ5ZkpNU2tHUDdxanBNNmwrbzBjUm5aM3FDMlo0aHRTL2R4cjZr?=
	=?utf-8?B?ZitYKyswemM1aEhGOTNVeGlNcUx5Yy8yR3krV2xKLzI2S3JIeXN3djRwNWtE?=
	=?utf-8?B?QXJTRjlGZG11MnZvMDJjM0hvYlpWa0Vrc09ZZ1RzaWhOVmxYcjIxZitjdHRD?=
	=?utf-8?B?YlZtb1hsUmVobFlzcjV3M0x2VlNEVXFNd2t0Q1Q4bjRJVXFDWTFPcUFQQXNk?=
	=?utf-8?B?MWZWeWVXTlVsOWdTTHpPRldoTmNjN1Uva0IvQnZLMDVOcWtOaExHSWw0djNR?=
	=?utf-8?B?ZkpaYVY1RVBUUWkwSzJkeXZGcDNxY2FsR2p3WnZuWWx3dnM5ZVhCb1UxOGd1?=
	=?utf-8?B?SGtuU0NOY0FPbWN1dzZUa3d3WWNvUXJmYVRTOElwRXBodXN1MXFGbHlSV2Mw?=
	=?utf-8?B?U0haUGhIbGxCdlprOVkxM1g5VlFkeUwxaG9hOVR5SzlsV1QxNURvUW1WY0ph?=
	=?utf-8?B?TTNvUmtUR0tkZm9WK3B0SytOMnJyb2lhTnRSK2tSOEVqYmVHZFpoRXF2SW5m?=
	=?utf-8?B?YlN6OGxMbkdzcjFrSDZ5TDVKS2QwYXArSnJKZDFGcVdTQkt5UXZnaXBUQm1w?=
	=?utf-8?B?eTJETTNJb09ycklObTE3RFRaK2tmLzRuQXhTekNNNmVJeHIwMVNaVlhJTEpy?=
	=?utf-8?B?YW9LcExSU1BnSFF6WXp1L3lTaUtEdE1XSWF2Tmx3SEcwQlhIcHhaTVZrNDFx?=
	=?utf-8?B?U1poN0FNMWd1eTFwY1diM1FkeXB0RGVjYkNjSEVGMmN4blRLaTljMUhOUWZ0?=
	=?utf-8?B?RHZUMVUxQ2VROTNDdmFYNkFLRHpPUUl2Z0dpUGFONXRXbFVrZXA2azBKZ0pL?=
	=?utf-8?B?ZWMrbDR0ZUdpeWVZTktRek5YS29CdzN0UDVEQWtLdG4xazdwbldWdXlMUkNC?=
	=?utf-8?B?bHlYVVpZOU9yMytBL3pkYk1SZlVhbjBNRkhSb2RtK0N1T0haZnovTFBlc0Z0?=
	=?utf-8?B?eTM0aGYxUVpqazVudjRtRklQOUxMSUY0Mjl4dStjSnErWng3cGFkTFRzZjBY?=
	=?utf-8?B?cE1LaUtnWWZ4RFlwc1hiYWZjY2o5amoyc3JHa04xWVBXL3J2OXQ1SHk5d3Mx?=
	=?utf-8?B?M3NTUW4ydVJsUnNuYkcrRDZBWllYZWJmc2wrZEs5c2JXZEVDR2JMRXkzdlNo?=
	=?utf-8?B?TXdUYVVjY1RIVHJrc0k3K2tQS3ZZTzBVUGxuditpUU1vaENlMFpHZnN3TkVQ?=
	=?utf-8?B?Vit1OWlyUGZUclphYk51VDhFWkJiUmFDdVlZTnFHY1h3ZkdzQ2pSU3NDZkRR?=
	=?utf-8?B?T2d3ZjdDVUY0VEYxVU5VTDVrZnVBcHdLN01CUys1N0VlTzd6MVFvbXlLNXNO?=
	=?utf-8?B?Zmh6b2xKOU05ZlU1azFCSnVvMXh2ZHhab3ZjWUw0aVZZcitFdXVLYzQ2K1Vn?=
	=?utf-8?B?a0tDWVE5TnpTbzErODZFOWRyZkdvQ2g1TkpzRFEwUG5yYTlyeEZETWdhTkxQ?=
	=?utf-8?B?VytKcWVuSW14c3BLTExCZFBsc0VJZGVQSExocEZkVnM3TlNrQkNpWnprMEJm?=
	=?utf-8?B?OVR1b3JqOW1LQUgxb0ZUeVNGLzd1Rk9ESHJVUytDVFBGb0d2Wis5TTlkcjFI?=
	=?utf-8?B?dHd4YUJOelRkQUdsaVY2TWRvajNMeEpVWDNZQ2xvbE4va0s3S1RFVlpOU0pi?=
	=?utf-8?B?VXE5MjVRL2FyK0c2OWNJN3J0RXFqVGxvU3RkR2VxUG5aOEc2Ti9sc1p3MkQr?=
	=?utf-8?B?Z1p6SmJiaGh0cFQvQzF2Q1ZrSlFpcE4xdFBubVpSYkdyNzRqampiVUtNekxU?=
	=?utf-8?B?TlJQRmZocnkraW9RVE1valVaY1gyb3VKclkzUWxsRjJvUHowSXM2UitSUjBk?=
	=?utf-8?B?Zkt6RVFpQmRYMmN3WHBwa216bDZoU3JYT2FzWHBodEd2Y1RRdXhVVDB3NUJR?=
	=?utf-8?B?TldNRlhTQndaTVVtMWN3QUZPb1Qva3QwRDhxSld2ZERYQUx3WC9JYVVIUXRC?=
	=?utf-8?B?d2JHWjl6cS9mYzdnUDVGc2N4RG93RVlUSUVyenpnR1ZOTzlrd3k2bjhta1pI?=
	=?utf-8?B?OEIrY0pwN3BPNXIzYUpvempoUzd2VVRXVnEwOEJrd0Zab1g2MUhYaXVyK1hB?=
	=?utf-8?B?UTlTWldMaCtBNzZFZUZTUUp5SE4zMjNxbTY4L0tiV2dpSUkwT2hQcFVBeG4w?=
	=?utf-8?B?NDIzUzVzRmZna05JUHM3MUtBdzVTQ1oxM1RuWjliTzVqcnllUmpOWW5qUTJP?=
	=?utf-8?Q?hjx5HCKQ+u7Pr7ePEUIW1UuBb8iOE0qZdOvTNzmB9+Ww?=
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e1b4f437-41e9-4f1c-7cfa-08d9e7c4d5de
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Feb 2022 09:58:03.5963 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: j4wjSsJ8bgHWohqfxVFJiRlTKLpX1FAU4ZlKd+kK06+wWt0AoKBPdovdRfsrrDhJ6ePO1IrRvR/4zvh5E7pi+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1893
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-MIME-Autoconverted: from base64 to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 2149w7q5012175
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Mon, 07 Feb 2022 04:33:18 -0500
Cc: Bart, "djwong@kernel.org" <djwong@kernel.org>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	"clm@fb.com" <clm@fb.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>,
	Adam Manzanares <a.manzanares@samsung.com>,
	"osandov@fb.com" <osandov@fb.com>,
	"msnitzer@redhat.com >> msnitzer@redhat.com" <msnitzer@redhat.com>,
	Assche <bvanassche@acm.org>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	Damien Le Moal <damien.lemoal@opensource.wdc.com>,
	Christoph Hellwig <hch@lst.de>,
	"roland@purestorage.com" <roland@purestorage.com>,
	"zach.brown@ni.com" <zach.brown@ni.com>,
	"dsterba@suse.com" <dsterba@suse.com>,
	"josef@toxicpanda.com" <josef@toxicpanda.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>, Keith Busch <kbusch@kernel.org>,
	"Frederick.Knight@netapp.com" <Frederick.Knight@netapp.com>,
	Jens Axboe <axboe@kernel.dk>, "tytso@mit.edu" <tytso@mit.edu>,
	Kanchan Joshi <joshi.k@samsung.com>,
	"martin.petersen@oracle.com >> Martin K.
	Petersen" <martin.petersen@oracle.com>,
	Luis Chamberlain <mcgrof@kernel.org>, "jack@suse.com" <jack@suse.com>,
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <CA1C6FA9A8CDA342B2FBFCFA1B38E460@namprd12.prod.outlook.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gMi80LzIyIDEyOjI0IEFNLCBKYXZpZXIgR29uesOhbGV6IHdyb3RlOgo+IE9uIDA0LjAyLjIw
MjIgMDc6NTgsIENoYWl0YW55YSBLdWxrYXJuaSB3cm90ZToKPj4gT24gMi8zLzIyIDIyOjI4LCBE
YW1pZW4gTGUgTW9hbCB3cm90ZToKPj4+IE9uIDIvNC8yMiAxMjoxMiwgQ2hhaXRhbnlhIEt1bGth
cm5pIHdyb3RlOgo+Pj4+Cj4+Pj4+Pj4gT25lIGNhbiBpbnN0YW50aWF0ZSBzY3NpIGRldmljZXMg
d2l0aCBxZW11IGJ5IHVzaW5nIGZha2Ugc2NzaSAKPj4+Pj4+PiBkZXZpY2VzLAo+Pj4+Pj4+IGJ1
dCBvbmUgY2FuIGFsc28ganVzdCB1c2Ugc2NzaV9kZWJ1ZyB0byBkbyB0aGUgc2FtZS4gSSBzZWUg
Ym90aCAKPj4+Pj4+PiBlZmZvcnRzCj4+Pj4+Pj4gYXMgZGVzaXJhYmxlLCBzbyBsb25nIGFzIHNv
bWVvbmUgbWFudGFpbnMgdGhpcy4KPj4+Pj4+Pgo+Pj4+Cj4+Pj4gV2h5IGRvIHlvdSB0aGluayBi
b3RoIGVmZm9ydHMgYXJlIGRlc2lyYWJsZSA/Cj4+Pgo+Pj4gV2hlbiB0ZXN0aW5nIGNvZGUgdXNp
bmcgdGhlIGZ1bmN0aW9uYWxpdHksIGl0IGlzIGZhciBlYXNpZXIgdG8gZ2V0IHNhaWQKPj4+IGZ1
bmN0aW9uYWxpdHkgZG9pbmcgYSBzaW1wbGUgIm1vZHByb2JlIiByYXRoZXIgdGhhbiBoYXZpbmcg
dG8gc2V0dXAgYQo+Pj4gVk0uIEMuZi4gcnVubmluZyBibGt0ZXN0cyBvciBmc3Rlc3RzLgo+Pj4K
Pj4KPj4gYWdyZWUgb24gc2ltcGxpY2l0eSBidXQgdGhlbiB3aHkgZG8gd2UgaGF2ZSBRRU1VIGlt
cGxlbWVudGF0aW9ucyBmb3IKPj4gdGhlIE5WTWUgZmVhdHVyZXMgKGUuZy4gWk5TLCBOVk1lIFNp
bXBsZSBDb3B5KSA/IHdlIGNhbiBqdXN0IGJ1aWxkCj4+IG1lbW9lcnkgYmFja2VkIE5WTWVPRiB0
ZXN0IHRhcmdldCBmb3IgTlZNZSBjb250cm9sbGVyIGZlYXR1cmVzLgo+Pgo+PiBBbHNvLCByZWNv
Z25pemluZyB0aGUgc2ltcGxpY2l0eSBJIHByb3Bvc2VkIGluaXRpYWxseSBOVk1lIFpOUwo+PiBm
YWJyaWNzIGJhc2VkIGVtdWxhdGlvbiBvdmVyIFFFTVUgKEkgdGhpbmsgSSBzdGlsbCBoYXZlIGlu
aXRpYWwgc3RhdGUKPj4gbWFjaGluZSBpbXBsZW1lbnRhdGlvbiBjb2RlIGZvciBaTlMgc29tZXdo
ZXJlKSwgdGhvc2Ugd2VyZSAibmFja2VkIiBmb3IKPj4gdGhlIHJpZ2h0IHJlYXNvbiwgc2luY2Ug
d2UndmUgZGVjaWRlZCBnbyB3aXRoIFFFTVUgYW5kIHVzZSB0aGF0IGFzIGEKPj4gcHJpbWFyeSBw
bGF0Zm9ybSBmb3IgdGVzdGluZywgc28gSSBmYWlsZWQgdG8gdW5kZXJzdGFuZCB3aGF0IGhhcwo+
PiBjaGFuZ2VkLi4gc2luY2UgZ2l2ZW4gdGhhdCBRRU1VIGFscmVhZHkgc3VwcG9ydHMgTlZNZSBz
aW1wbGUgY29weSAuLi4KPiAKPiBJIHdhcyBub3QgcGFydCBvZiB0aGlzIGNvbnZlcnNhdGlvbiwg
YnV0IGFzIEkgc2VlIGl0IGVhY2ggYXBwcm9hY2ggZ2l2ZQo+IGEgYmVuZWZpdC4gUUVNVSBpcyBm
YW50YXN0aWMgZm9yIGNvbXBsaWFuY2UgdGVzdGluZyBhbmQgSSBhbSBub3Qgc3VyZQo+IHlvdSBn
ZXQgdGhlIHNhbWUgbGV2ZWwgb2YgY29tbWFuZCBhbmFseXNpcyBhbnl3aGVyZSBlbHNlOyBhdCBs
ZWFzdCBub3QKPiB3aXRob3V0IHdyaXRpbmcgZGVkaWNhdGVkIGNvZGUgZm9yIHRoaXMgaW4gYSB0
YXJnZXQuCj4gCj4gVGhpcyBzYWlkLCB3aGVuIHdlIHdhbnQgdG8gdGVzdCBmb3IgcmFjZSBjb25k
aXRpb25zLCBRRU1VIGlzIHZlcnkgc2xvdy4KCkNhbiB5b3UgcGxlYXNlIGVsYWJvcmF0ZSB0aGUg
c2NlbmFyaW8gYW5kIG51bWJlcnMgZm9yIHNsb3duZXNzIG9mIFFFTVU/CgpGb3IgcmFjZSBjb25k
aXRpb25zIHRlc3Rpbmcgd2UgY2FuIGJ1aWxkIGVycm9yIGluamVjdGlvbiBmcmFtZXdvcmsKYXJv
dW5kIHRoZSBjb2RlIGltcGxlbWVudGF0aW9uIHdoaWNoIHByZXNlbnQgaW4ga2VybmVsIGV2ZXJ5
d2hlcmUuCgo+IEZvciBhIHNvZnR3YXJlLW9ubHkgc29sdXRpb24sIHdlIGhhdmUgZXhwZXJpbWVu
dGVkIHdpdGggc29tZXRoaW5nCj4gc2ltaWxhciB0byB0aGUgbnZtZS1kZWJ1ZyBjb2RlIHRoYSBN
aWt1bGFzIGlzIHByb3Bvc2luZy4gQWRhbSBwb2ludGVkIHRvCj4gdGhlIG52bWUtbG9vcCB0YXJn
ZXQgYXMgYW4gYWx0ZXJuYXRpdmUgYW5kIHRoaXMgc2VlbXMgdG8gd29yayBwcmV0dHkKPiBuaWNl
bHkuIEkgZG8gbm90IGJlbGlldmUgdGhlcmUgc2hvdWxkIGJlIG1hbnkgY2hhbmdlcyB0byBzdXBw
b3J0IGNvcHkKPiBvZmZsb2FkIHVzaW5nIHRoaXMuCj4gCgpJZiBRRU1VIGlzIHNvIGluY29tcGV0
ZW50IHRoZW4gd2UgbmVlZCB0byBhZGQgZXZlcnkgYmlnIGZlYXR1cmUgaW50bwp0aGUgTlZNZU9G
IHRlc3QgdGFyZ2V0IHNvIHRoYXQgd2UgY2FuIHRlc3QgaXQgYmV0dGVyID8gaXMgdGhhdCB3aGF0
CnlvdSBhcmUgcHJvcG9zaW5nID8gc2luY2UgaWYgd2UgaW1wbGVtZW50IG9uZSBmZWF0dXJlLCBp
dCB3aWxsIGJlCmhhcmQgdG8gbmFjayBhbnkgbmV3IGZlYXR1cmVzIHRoYXQgcHBsIHdpbGwgY29t
ZSB1cCB3aXRoCnNhbWUgcmF0aW9uYWxlICJ3aXRoIFFFTVUgYmVpbmcgc2xvdyBhbmQgaGFyZCB0
byB0ZXN0IHJhY2UKY29uZGl0aW9ucyBldGMgLi4iCgphbmQgaWYgdGhhdCBpcyB0aGUgY2FzZSB3
aHkgd2UgZG9uJ3QgaGF2ZSBaTlMgTlZNZU9GIHRhcmdldAptZW1vcnkgYmFja2VkIGVtdWxhdGlv
biA/IElzbid0IHRoYXQgYSBiaWdnZXIgYW5kIG1vcmUKY29tcGxpY2F0ZWQgZmVhdHVyZSB0aGFu
IFNpbXBsZSBDb3B5IHdoZXJlIGNvbnRyb2xsZXIgc3RhdGVzCmFyZSBpbnZvbHZlZCB3aXRoIEFF
TnMgPwoKWk5TIGtlcm5lbCBjb2RlIHRlc3RpbmcgaXMgYWxzbyBkb25lIG9uIFFFTVUsIEkndmUg
YWxzbyBmaXhlZApidWdzIGluIHRoZSBaTlMga2VybmVsIGNvZGUgd2hpY2ggYXJlIGRpc2NvdmVy
ZWQgb24gUUVNVSBhbmQgSSd2ZSBub3QKc2VlbiBhbnkgaXNzdWVzIHdpdGggdGhhdC4gR2l2ZW4g
dGhhdCBzaW1wbGUgY29weSBmZWF0dXJlIGlzIHdheSBzbWFsbGVyCnRoYW4gWk5TIGl0IHdpbGwg
bGVzcyBsaWtlbHkgdG8gc3VmZmVyIGZyb20gc2xvd25lc3MgYW5kIGV0YyAobGlzdGVkCmFib3Zl
KSBpbiBRRU1VLgoKbXkgcG9pbnQgaXMgaWYgd2UgYWxsb3cgb25lLCB3ZSB3aWxsIGJlIG9wZW5p
bmcgZmxvb2RnYXRlcyBhbmQgd2UgbmVlZCAKdG8gYmUgY2FyZWZ1bCBub3QgdG8gYmxvYXQgdGhl
IGNvZGUgdW5sZXNzIGl0IGlzIF9hYnNvbHV0ZWx5Cm5lY2Vzc2FyeV8gd2hpY2ggSSBkb24ndCB0
aGluayBpdCBpcyBiYXNlZCBvbiB0aGUgc2ltcGxlIGNvcHkKc3BlY2lmaWNhdGlvbi4KCj4gU28g
aW4gbXkgdmlldyBoYXZpbmcgYm90aCBpcyBub3QgcmVwbGljYXRpb24gYW5kIGl0IGdpdmVzIG1v
cmUKPiBmbGV4aWJpbGl0eSBmb3IgdmFsaWRhdGlvbiwgd2hpY2ggSSBiZWxpZXZlIGl0IGlzIGFs
d2F5cyBnb29kLgo+IAoKLWNrCgoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJl
ZGhhdC5jb20KaHR0cHM6Ly9saXN0bWFuLnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1k
ZXZlbA==

