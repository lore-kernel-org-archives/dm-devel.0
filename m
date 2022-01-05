Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 414B5C433EF
	for <dm-devel@archiver.kernel.org>; Thu,  6 Jan 2022 05:19:53 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-602-6p5V9lFeNYunKS17TRDRQg-1; Thu, 06 Jan 2022 00:19:43 -0500
X-MC-Unique: 6p5V9lFeNYunKS17TRDRQg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F345D83DCC9;
	Thu,  6 Jan 2022 05:19:38 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8E97512E3B;
	Thu,  6 Jan 2022 05:19:38 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id DC4654BB7C;
	Thu,  6 Jan 2022 05:19:37 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 205LuQjG025307 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 5 Jan 2022 16:56:26 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 0F7CF40CFD29; Wed,  5 Jan 2022 21:56:26 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 08A9840CFD26
	for <dm-devel@redhat.com>; Wed,  5 Jan 2022 21:56:26 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DF70810184A1
	for <dm-devel@redhat.com>; Wed,  5 Jan 2022 21:56:25 +0000 (UTC)
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-21-91pY-WWoMjye-xKoRRKFqg-1; Wed, 05 Jan 2022 16:56:24 -0500
X-MC-Unique: 91pY-WWoMjye-xKoRRKFqg-1
X-IronPort-AV: E=McAfee;i="6200,9189,10217"; a="241361645"
X-IronPort-AV: E=Sophos;i="5.88,265,1635231600"; d="scan'208";a="241361645"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
	by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
	05 Jan 2022 13:55:20 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,265,1635231600"; d="scan'208";a="618110417"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
	by fmsmga002.fm.intel.com with ESMTP; 05 Jan 2022 13:55:19 -0800
Received: from orsmsx604.amr.corp.intel.com (10.22.229.17) by
	ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
	15.1.2308.20; Wed, 5 Jan 2022 13:55:19 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
	orsmsx604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
	15.1.2308.20 via Frontend Transport; Wed, 5 Jan 2022 13:55:19 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.105)
	by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	15.1.2308.20; Wed, 5 Jan 2022 13:55:19 -0800
Received: from PH0PR11MB4855.namprd11.prod.outlook.com (2603:10b6:510:41::12)
	by PH0PR11MB5808.namprd11.prod.outlook.com (2603:10b6:510:129::12)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.15;
	Wed, 5 Jan 2022 21:55:17 +0000
Received: from PH0PR11MB4855.namprd11.prod.outlook.com
	([fe80::38cc:22c0:928a:95b7]) by
	PH0PR11MB4855.namprd11.prod.outlook.com
	([fe80::38cc:22c0:928a:95b7%9]) with mapi id 15.20.4844.016;
	Wed, 5 Jan 2022 21:55:17 +0000
From: "Bae, Chang Seok" <chang.seok.bae@intel.com>
To: Eric Biggers <ebiggers@kernel.org>, "dm-devel@redhat.com"
	<dm-devel@redhat.com>
Thread-Topic: [PATCH v4 00/13] x86: Support Key Locker
Thread-Index: AQHX8IXgPtLMRzOkzUOX4xWFKhqGg6w0Uf6AgCDKzgA=
Date: Wed, 5 Jan 2022 21:55:17 +0000
Message-ID: <4101B942-6327-49A9-BE8B-9E51F0427F50@intel.com>
References: <20211214005212.20588-1-chang.seok.bae@intel.com>
	<YbqRseO+TtuGQk5x@sol.localdomain>
In-Reply-To: <YbqRseO+TtuGQk5x@sol.localdomain>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2c960268-86f1-4ae0-ab1d-08d9d0960fd8
x-ms-traffictypediagnostic: PH0PR11MB5808:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-microsoft-antispam-prvs: <PH0PR11MB58083747BFC77D0C77711A9AD84B9@PH0PR11MB5808.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: zMlOl7SHv60/Am7lPgx3B4fcgN1k7+WIFZo1+EfSvBy6A4t00oPGlwnAyS1wWbbP96ueK+1YbVASDCeQUwozwMiS0MRDCxiXhV61ejYcIAjP+n07JkYgM6Xma73nYcGDUs1JQg5k3ngZ3MX7MLYxJw3AdSuaC6Gwh9zaZVuc/PGOoey6kx2ge9xFgLrY4nFci8QjvAYE1ZdaTW3TfC0JHFR5jbAMCBSqqjmoHZZCQI7KAu51L01SOQcN5DwUmVtyR2jORy+MgdtXVjqffWP/8hW57IDGr83TKFuCRd0CjGb5zdUGxJZF/+1/N3p34YamEbcgmui9wwOt+yxi04rQ7y3AvrCSO6yLUgYKWasguLsklb67EcSugQEY2dmJ2ehDfa5G8kohZ+8QgstFfS03BG5WnfQn2xtX8okOwxCDxKtd0u5rB2wwx5YKq4Cg8BBY0NUumKACeoBfcFDxkYwImWW2DboNGM7SJZu98sk1RazGXC0UGC77jP0qiiCk2QEwYSlcCKkllX3wOkO664Rrvo61OTZksIy9sI6oCLBjHMpB2cNpfNr29g+vnPfhQNm7S84F1MPy8O0yErwA3E9YnqWS49uY5pS41l3U55Hvi+UUte/UCliLni0BnBiEPpp476Lr2+3Kk6b7FgP3Wp3007VNsAaXKlEP8zX5vfHmFLWD1WI5QxQUJW94F4M0hEIcBGi0VaS3teBPykfYSFrsk5lTsy6ET/oKs+12ignujmecsJQaYGFuAaLWbp8WNmaHOUHsiASVjGEEowpXX8pS/Tya0RwcsDUexF4HvkMomUQidQWXtxPNyjNT6WtKGUsO4ZHyV7xuY4IG9686A/+OyA==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:PH0PR11MB4855.namprd11.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(366004)(6486002)(110136005)(6512007)(8676002)(122000001)(26005)(38070700005)(83380400001)(186003)(8936002)(5660300002)(71200400001)(76116006)(54906003)(6506007)(66946007)(66446008)(66476007)(7416002)(33656002)(36756003)(82960400001)(316002)(2616005)(64756008)(4326008)(966005)(86362001)(508600001)(38100700002)(66556008)(2906002)(53546011)(45980500001);
	DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?M3VFazRBRTg3ZUQ3cW9HNUp6TFJPTmdpZmM5bDQ5RFU3c05vMkd5Y1VITUxx?=
	=?utf-8?B?MmRXTnRha2FoeStBK2dKT3oyeTU4NVdlRmE0dkplcXdtTlNnUG5CL2h2MkJp?=
	=?utf-8?B?RmVUODJjZlFaejcvZkZXOHl4bXZKK1FvaTZmZVNtL2lya25BVHRKU1QzMmc2?=
	=?utf-8?B?b0lHZVFPQ0Z6OEwxdVgxSEJOdlFmOVRjZ2VZdUNNazMrSURVR1BuQXlUM1RQ?=
	=?utf-8?B?aDZ1T2lIa2NaS2N6Sk5NdnFDRDRsVWJnWEJQQWQ3WmRlRzE5bGZDZGMzVWFK?=
	=?utf-8?B?Q2VXcUV1a3pEeThFclN4ZC8vbDI4Y3BpdnBXS1FGcG1GdWdhQjRsTk5acHNr?=
	=?utf-8?B?dzR0czVVNmtXRGpDMGRqUXFKdHBUTjllTm1DWXlOY25xMjgzYzBsRXhEeUZD?=
	=?utf-8?B?cFh1UzhPTGhxcUNhMDh5d3grdFliMHNVbG13YlF0c2FaWDhPVzRnNUNVbHE2?=
	=?utf-8?B?YnhMZnBCUzY3T3BZaXNFeXo1cnNZQmJHQlcwZ3FuRG5BRGpmWGIvY3ZKVTdR?=
	=?utf-8?B?Z1RQNERJZzc2amZ2bmdJRWw1VUlQYWdSQmdNem1YL1c0YVUrSkR0cW9pejBG?=
	=?utf-8?B?VmxIblZqMEkwVmI2TlpNR1VTcFd0OVNSK2Y3T1hSK3E0alpqR1c1MHdycE5W?=
	=?utf-8?B?dzIrYm5xS1prWWlvQzFiby9LK01qbHM2Nlhjb1hrcmJJUVpJd2ZvcVA4cGQr?=
	=?utf-8?B?K1o3SEhqWEpzTkIzUFJUYVhySWF4TzFHVmpOck5uUm8rK2hXcGdTdUJOL2Yx?=
	=?utf-8?B?eG92elhVRXdTaGkvazJDRVVFS3B6eWsvVFBXdWFSNWpQdlBaa09Ja3BtbjhY?=
	=?utf-8?B?d1dGWG9vV3ZVVWRrNHhqTThUakROamtRcVRhMnNVMTBYdVpJaFp1UXBOWnpM?=
	=?utf-8?B?UnFLbGYwRVZnK2UwUEdOQndRd0I0bno4TnJFWUhWN2pVcFVwS2NMUzJ1UmNC?=
	=?utf-8?B?Zk56b1ZGaUtvdTh0U21jOFppMmVGY0Q3T1pXczIxVG9ZazdSYWprcVg1VXdn?=
	=?utf-8?B?amt0TTQ3QkxFSlNYUEFKNXFEMEpFVTd6WWU1a2dGeldCODZKUmZMUkVjWEwr?=
	=?utf-8?B?ZlZ5d2dWOTVlNFZQdW1hOG1ON2JKaXR3SEY4Sy9lc0pXeVRZNWk2Y2gwelZy?=
	=?utf-8?B?SjF2ci9oemlrbEhIRU84cWJXenBJV0FQZkQvaElSVkYwZ0FLYWlBOVVOc2J4?=
	=?utf-8?B?amJIUzhkMHI0bTE0aC9YM2tCS0o2ZWIyL3ZONjdLZlh2dDVrTVRTOGdBWFhX?=
	=?utf-8?B?V1NRR01oR1kycG9KV0F2aFQ4Wk8zc1NQUVBBLzI0NUdsd0VCL1QwQkhyalRX?=
	=?utf-8?B?MmJ2ZzZtMFV1UVErS0hFUFBVVmhjVE1LN2hmOEpuM3ZicGRhMy9jcXlJQkg4?=
	=?utf-8?B?WGw3djcvN0pKYXdPdW9obGU4TE5wc0JuMm1FWno5RjJVYkhDVGl0YzNhZjRx?=
	=?utf-8?B?VlZUV0puUU5lSFZIRzhpNjBlcVl5MjE1eDRYVE9ncGtURkVEVnRKQW81TlR1?=
	=?utf-8?B?L0xDSGlzVkFzNFl4QzZwOEZJcFV5VlpzelVURlhSYnZKNi8vejIrSEJMVGpC?=
	=?utf-8?B?dy9vZ3VlVGJtZ1V2ZnhzU2VzR2VVRXBWakVYZnNwVG5rdzBmQ25IV3JyYjBF?=
	=?utf-8?B?VGc4UVJHZ0h5aFhlWDlNNXVKS1lVREZDcDB1TlF1cTlja2oyVHFTVFdad1Jk?=
	=?utf-8?B?c3l0c2ZuTFljbHF5TFZtb0I1QytGdm5vYTk4d0dxU1p1QmlZUlZNUnlpTVh6?=
	=?utf-8?B?a3VsOEZGUWtUYklQeXkxb05hZE5pRXdnYXVCRW5HczM3Wk8vUzl1T3d4TlIr?=
	=?utf-8?B?R3FrWTY4VGY3QUZDMHZnT2h5aC9qTHFXL0ZCamx5cXIrYysySjIvSGZiVnhs?=
	=?utf-8?B?dGllZGQrbytBV2xNZEdrYUEwT1Y0MXpaeDhVMCtKUDNhNXRmY0NQcmwyWjBk?=
	=?utf-8?B?T0o1WWlFb1oyTloyNEZQVTQ4Z1cyWXdWRk9vdWluUGhqdnpZL1YyZXd4MnU4?=
	=?utf-8?B?NGdEMXZMbVd6K3ZReUlJcHF5eC9mZ2tvYlRtTkhPSzdjQVpqUE9rY0ZubDBn?=
	=?utf-8?B?OVFmZjJ4MEYybW94RW8ySjJoem5kcWdDTXd6M2ZLWG5VMzBiTGFtc2tBdkdB?=
	=?utf-8?B?cnB3TWJyZldySjlTK1pNa0RLb01oMDRzNWVxRTBHVTFLWmZtOE90TDhTZ2lL?=
	=?utf-8?B?cGZxUHNSMWlHaHE5amxWYmMrbEl5ZHdBa1BzUEF0VFd6d29oRG1uOExhc21a?=
	=?utf-8?Q?x1RZhb4OViKwRxWSk1rAXhzUrINPsFdT5vvW6S/XXg=3D?=
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4855.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c960268-86f1-4ae0-ab1d-08d9d0960fd8
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jan 2022 21:55:17.8071 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pkjJkT5hoD4iJOn1gFaYE012dq0Rf3tKbOpZv/on8ZRPKlY0a7jQXeoEja69UWGQmt3LD5672nCsV1tyA+9zeehSTGe9UPcnxNUrD5w0xnA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5808
X-OriginatorOrg: intel.com
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 205LuQjG025307
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Thu, 06 Jan 2022 00:19:37 -0500
Cc: "Shankar, Ravi V" <ravi.v.shankar@intel.com>, Dave
	Hansen <dave.hansen@linux.intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	the arch/x86 maintainers <x86@kernel.org>, "Williams,
	Dan J" <dan.j.williams@intel.com>, Linux Kernel
	Mailing List <linux-kernel@vger.kernel.org>, "Krishnakumar,
	Lalithambika" <lalithambika.krishnakumar@intel.com>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	"Lutomirski, Andy" <luto@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
	Borislav Petkov <bp@suse.de>, Ingo Molnar <mingo@kernel.org>,
	"Gairuboyina, Charishma1" <charishma1.gairuboyina@intel.com>,
	"Dwarakanath, Kumar N" <kumar.n.dwarakanath@intel.com>
Subject: Re: [dm-devel] [PATCH v4 00/13] x86: Support Key Locker
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <345CA196D9EA76419281CD0D66F5200C@namprd11.prod.outlook.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gRGVjIDE1LCAyMDIxLCBhdCAxNzowOSwgRXJpYyBCaWdnZXJzIDxlYmlnZ2Vyc0BrZXJuZWwu
b3JnPiB3cm90ZToKPiBPbiBNb24sIERlYyAxMywgMjAyMSBhdCAwNDo1MTo1OVBNIC0wODAwLCBD
aGFuZyBTLiBCYWUgd3JvdGU6Cj4+ID09IERpc2sgRW5jcnlwdGlvbiBVc2UgQ2FzZSA9PQo8c25p
cD4KPj4gICAkIGNyeXB0c2V0dXAgbHVrc0Zvcm1hdCAtLWNpcGhlcj0iY2FwaTp4dHMtYWVzLWFl
c2tsLXBsYWluIiA8ZGV2aWNlPgo+IAo+IHBsYWluNjQgaXMgc3VwcG9zZWQgdG8gYmUgdXNlZCB0
aGVzZSBkYXlzLCBub3QgcGxhaW4uCgpJIHNlZS4KCj4+ID09IE5vbiBVc2UgQ2FzZXMgPT0KPj4g
Cj4+IEJhcmUgbWV0YWwgZGlzayBlbmNyeXB0aW9uIGlzIHRoZSBvbmx5IHVzZSBjYXNlIGludGVu
ZGVkIGJ5IHRoZXNlIHBhdGNoZXMuCj4gCj4gU2luY2UgZG0tY3J5cHQgaXMgdGhlIHVzZSBjYXNl
IGZvciB0aGVzZSBwYXRjaGVzLCB5b3UgcHJvYmFibHkgc2hvdWxkIENDIHRoaXMKPiBwYXRjaHNl
dCB0byBkbS1kZXZlbEByZWRoYXQuY29tIHNvIHRoYXQgdGhlIGRtLWNyeXB0IGRldmVsb3BlcnMg
YXJlIGF3YXJlIG9mIGl0LgoKT2gsIEkgc2hvdWxkIGhhdmUgaW5jbHVkZWQgdGhlbS4gSSB3YXMg
bm90IGF3YXJlIG9mIHRoaXMgbWFpbGluZyBhZGRyZXNzLgoKSGkgRE0tY3J5cHQgZm9sa3MsCgpI
ZXJlIGlzIHRoZSBwYXRjaCBzZXJpZXM6CiAgICBodHRwczovL2xvcmUua2VybmVsLm9yZy9sa21s
LzIwMjExMjE0MDA1MjEyLjIwNTg4LTEtY2hhbmcuc2Vvay5iYWVAaW50ZWwuY29tL3QvCgpJIHdv
dWxkIGFwcHJlY2lhdGUgaWYgeW91IGdpdmUgYW55IGZlZWRiYWNrIG9uIHRoaXMgZmVhdHVyZeKA
mXMgdXNlIGNhc2Ugd2l0aCB5b3Vycy4KCj4+ICstLS0tLS0tLS0tLSstLS0tLS0tLS0tLS0tLS0r
LS0tLS0tLS0tLS0tLS0tKwo+PiB8IENpcGhlciAgICB8ICAgRW5jcnlwdGlvbiAgfCBEZWNyeXB0
aW9uICAgIHwKPj4gfCAoQUVTLUtMKSAgfCAgICAoTWlCL3MpICAgIHwgKE1pQi9zKSAgICAgICB8
Cj4+ICstLS0tLS0tLS0tLSstLS0tLS0tLS0tLS0tLS0rLS0tLS0tLS0tLS0tLS0tKwo+PiB8IEFF
Uy1DQkMgICB8ICAgICA1MDUuMyAgICAgfCAgIDIwOTcuOCAgICAgIHwKPj4gfCBBRVMtWFRTICAg
fCAgICAgMTEzMCAgICAgIHwgICA2OTYuNCAgICAgICB8Cj4+ICstLS0tLS0tLS0tLSstLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tKwo+IAo+IFdoeSBpcyBBRVMtWFRTIGRlY3J5cHRpb24g
c28gbXVjaCBzbG93ZXIgdGhhbiBBRVMtWFRTIGVuY3J5cHRpb24/ICBUaGV5IHNob3VsZAo+IGJl
IGFib3V0IHRoZSBzYW1lLgoKQW5hbHl6aW5nIGFuZCB1bmRlcnN0YW5kaW5nIHRoaXMgd2l0aCBz
cGVjaWZpYyBoYXJkd2FyZSBpbXBsZW1lbnRhdGlvbiB0YWtlcwp0aW1lIGZvciB1cy4gV2lsbCBj
b21lIGJhY2sgYW5kIHVwZGF0ZSB5b3Ugd2hlbiB3ZSBoYXZlIGFueXRoaW5nIHRvIHNoYXJlIGhl
cmUuCgo+IEFsc28sIGlzIHRoZSBBRVMtQ0JDIHN1cHBvcnQgcmVhbGx5IHVzZWZ1bCwgZ2l2ZW4g
dGhhdCBmb3IgZGlzayBlbmNyeXB0aW9uLAo+IEFFUy1YVFMgaXMgcmVjb21tZW5kZWQgb3ZlciBB
RVMtQ0JDIHRoZXNlIGRheXM/CgpZZXMsIHdlIHVuZGVyc3RhbmQgdGhhdCBBRVMtWFRTIGlzIHRo
ZSBwcmltYXJ5IG9wdGlvbiBmb3IgZGlzayBlbmNyeXB0aW9uLgoKQnV0IGl0IHNlZW1zIHRoYXQg
QUVTLUNCQyBoYWQgYmVlbiB1c2VkIGZvciBkaXNrIGVuY3J5cHRpb24sIFsxXToKCiAgICBDb21w
YXJpbmcgWFRTIHRvIENCQyBmb3IgaGFyZCBkaXNrIGVuY3J5cHRpb24KICAgICAgICBJZiBhIHN0
b3JhZ2UgZGV2aWNlIHZlbmRvciBpcyBzZWVraW5nIEZJUFMgMTQwLTIgY2VydGlmaWNhdGlvbiB0
b2RheSwKICAgICAgICB0aGV5IHdpbGwgdHlwaWNhbGx5IHVzZSBDQkMgZW5jcnlwdGlvbiwgb3Ig
ZXZlbiBFQ0IuIENCQyBpcyBhIGdvb2QKICAgICAgICBtb2RlLCAuLi4KCkFzIGxvbmcgYXMgaXQg
aXMgZmFjdHVhbCB0aGF0IHRoZSBtb2RlIHdhcyBvbmNlIHBvcHVsYXIsIGl0IGNhbiBoZWxwIHNv
bWVib2R5CndobyB3YW50cyB0byB1c2UgS2V5IExvY2tlciBmb3IgYW4gb2xkIGRpc2sgaW1hZ2Ug
SSB0aGluay4KClRoYW5rcywKQ2hhbmcKClsxXSBodHRwczovL2NzcmMubmlzdC5nb3YvQ1NSQy9t
ZWRpYS9Qcm9qZWN0cy9CbG9jay1DaXBoZXItVGVjaG5pcXVlcy9kb2N1bWVudHMvQkNNL0NvbW1l
bnRzL1hUUy9YVFNfY29tbWVudHMtQmFsbC5wZGYKCgoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0
CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly9saXN0bWFuLnJlZGhhdC5jb20vbWFpbG1hbi9s
aXN0aW5mby9kbS1kZXZlbA==

